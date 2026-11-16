"""Shared live simulator/hardware limit propagation checks; no motion commands.

DOC: motor user = direction * dial + OFF. USER: four requested limit modes.
COMPAT: with sync off, enabled native limits bound motor field edits without
propagating those edits back to ECMC. These acceptance cases deliberately fail
if that boundary or the independent zero pair cannot be established; no
fallback silently enables synchronization.
"""
from contextlib import contextmanager
import math
import time
import json
import threading

# ESS motor.h::MF_RW_SOFT_LIMITS. A writable driver PV is not proof that
# the motor record has consumed the corresponding aggregate-status callback.
RW_SOFT_LIMITS_MASK = 1 << 8
STABLE_SECONDS = 3.1  # More than three idle motor polls at the supported 1 Hz.


class LimitSession:
    FIELDS = ('.DIR', '.OFF', '.FOFF', '.DLLM', '.DHLM', '.LLM', '.HLM',
              '-CfgSyncSftLim', '-CfgDLLM-RB', '-CfgDHLM-RB',
              '-CfgDLLM-En-RB', '-CfgDHLM-En-RB')
    WRITES = {'.DIR', '.OFF', '.FOFF', '.DLLM', '.DHLM', '.LLM', '.HLM',
              '-CfgSyncSftLim', '-CfgDLLM', '-CfgDHLM', '-CfgDLLM-En', '-CfgDHLM-En'}

    def __init__(self, case, axis):
        self.case, self.rig, self.axis = case, case.rig, axis
        rig = self.rig
        if hasattr(rig, 'authorized') and not rig.authorized:
            raise RuntimeError('hardware preflight must authorize configuration tests')
        self.saved = {s: rig.get(axis, s) for s in self.FIELDS}
        case.assertGreater(rig.get(axis, '.MRES'), 0,
                           'live limit cases require positive MRES; negative MRES is covered standalone')
        self.positions = {a: rig.get(a, '-PosAct') for a in rig.profile['axes']}
        for a in self.positions:
            case.assertEqual(rig.get(a, '-Busy'), 0, 'stop axes before configuration checks')
        self.state_machine = rig.client.get(rig.prefix + 'SM00-EnaCmd')
        self.center = self.positions[axis]
        low, high = self.saved['-CfgDLLM-RB'], self.saved['-CfgDHLM-RB']
        self.width = min(self.center-low, high-self.center) / 2
        if not math.isfinite(self.width) or self.width <= 1e-5:
            raise AssertionError('configuration tests require position inside a finite native range')
        self.tolerance = rig.profile.get('tolerance', .002)

    def stationary(self):
        for a, before in self.positions.items():
            self.case.assertEqual(self.rig.get(a, '-Busy'), 0, a + ' unexpected motion')
            self.case.assertEqual(self.rig.get(a, '-ErrId'), 0, a + ' unexpected native error')
            self.case.assertEqual(self.rig.get(a, '-EnaAct'), 0, a + ' drive must remain disabled')
            self.case.assertAlmostEqual(self.rig.get(a, '-PosAct'), before,
                                        delta=self.tolerance, msg=a + ' native position changed')
        return True

    def wait(self, predicate, description):
        def observed():
            self.stationary()
            return predicate()
        waiter = getattr(self.rig, 'wait_configuration', self.rig.wait)
        # Hardware configuration waits do not require native/motor limits to
        # match; identity/motion authority remains with the existing runner.
        try:
            waiter(observed, self.axis + ' ' + description)
        except AssertionError as error:
            fields = ('.MFLG', '-CfgSyncSftLim', '.DLLM', '.DHLM', '.LLM', '.HLM',
                      '.DIR', '.OFF', '-CfgDLLM-RB', '-CfgDHLM-RB')
            actual = {f: self.rig.get(self.axis, f) for f in fields}
            raise AssertionError(str(error) + '\nLimit handshake evidence: ' +
                                 json.dumps(actual, sort_keys=True)) from error

    def write(self, field, value):
        if field not in self.WRITES or not math.isfinite(value):
            raise ValueError('unsupported limit-test configuration write')
        self.stationary()
        if hasattr(self.rig, 'touched'):
            self.rig.touched.add(self.axis)
        self.rig.client.put(self.rig.prefix + self.axis + field, value)

    def values(self, expected):
        return all(abs(self.rig.get(self.axis, field)-value) < 1e-6
                   for field, value in expected.items())

    def expect(self, expected, description):
        self.wait(lambda: self.values(expected), description + '; expected ' + str(expected))

    def stable(self, expected):
        deadline = time.monotonic() + STABLE_SECONDS
        def observed():
            self.case.assertTrue(self.values(expected), 'unexpected limit propagation: ' + str(expected))
            return time.monotonic() >= deadline
        self.wait(observed, 'independent values remain unchanged across polls')

    def sync(self, enabled):
        self.write('-CfgSyncSftLim', enabled)
        self.expect({'-CfgSyncSftLim': enabled}, 'sync setting acknowledged')
        self.wait(lambda: bool(int(self.rig.get(self.axis, '.MFLG')) & RW_SOFT_LIMITS_MASK)
                  == bool(enabled), 'motor record acknowledges MF_RW_SOFT_LIMITS=' + str(enabled))

    def native(self, low, high, enabled=True):
        if not self.saved['-CfgDLLM-RB'] <= low < high <= self.saved['-CfgDHLM-RB']:
            raise ValueError('temporary native range must stay inside the saved envelope')
        self.write('-CfgDLLM', low)
        self.write('-CfgDHLM', high)
        for side in ('DLLM', 'DHLM'):
            self.write('-Cfg'+side+'-En', int(enabled))
        self.expect({'-CfgDLLM-RB': low, '-CfgDHLM-RB': high,
                     '-CfgDLLM-En-RB': int(enabled), '-CfgDHLM-En-RB': int(enabled)},
                    'native limit pair and enable flags')

    def motor(self, low, high):
        self.write('.DLLM', low)
        self.write('.DHLM', high)
        self.expect({'.DLLM': low, '.DHLM': high}, 'requested motor dial limits')

    def pair(self, fraction):
        return self.center-self.width*fraction, self.center+self.width*fraction

    def begin(self):
        if hasattr(self.rig, 'touched'):
            self.rig.touched.update(self.positions)
        self.rig.client.put(self.rig.prefix + 'SM00-EnaCmd', 0)
        errors = self.rig.stop_all()
        if errors:
            raise RuntimeError('stop before limit tests: ' + '; '.join(errors))
        # Hardware stop_all submits STOP; it does not disable amplifiers.
        # Disable only after idle, and wait for feedback before editing limits.
        waiter = getattr(self.rig, 'wait_configuration', self.rig.wait)
        waiter(lambda: all(self.rig.get(a, '-Busy') == 0 for a in self.positions),
               'idle axes before disabling drives')
        for a in self.positions:
            self.rig.client.put(self.rig.prefix+a+'-EnaCmd', 0)
        waiter(lambda: all(self.rig.get(a, '-EnaAct') == 0 for a in self.positions),
               'disabled drives before limit changes')
        self.wait(lambda: self.rig.client.get(self.rig.prefix+'SM00-EnaCmd') == 0,
                  'state machine held during limit configuration')
        self.sync(0)
        self.write('.FOFF', 1)

    def restore(self):
        # Stop and restore with sync OFF first, preserving original independent
        # pairs, direction, offset and enable flags. Never issue SET/VAL/native
        # execute, or enable sync as a cleanup shortcut.
        self.rig.stop_all()
        saved = self.saved
        self.sync(0)
        self.write('.FOFF', 1)
        self.write('.DIR', saved['.DIR'])
        self.write('.OFF', saved['.OFF'])
        self.native(saved['-CfgDLLM-RB'], saved['-CfgDHLM-RB'], enabled=False)
        self.write('-CfgDLLM-En', saved['-CfgDLLM-En-RB'])
        self.write('-CfgDHLM-En', saved['-CfgDHLM-En-RB'])
        self.motor(saved['.DLLM'], saved['.DHLM'])
        self.write('.FOFF', saved['.FOFF'])
        self.sync(saved['-CfgSyncSftLim'])
        self.expect(saved, 'original motor/native coordinates, independent pairs and flags restored')
        self.rig.client.put(self.rig.prefix+'SM00-EnaCmd', self.state_machine)
        # Verify acknowledgment, not just submission of the restoration write.
        waiter = getattr(self.rig, 'wait_configuration', self.rig.wait)
        waiter(lambda: self.rig.client.get(self.rig.prefix+'SM00-EnaCmd') == self.state_machine,
               'original state-machine enable restored')


class LimitModeChecks:
    """Shared verdicts; transport ownership remains in the SIM/HW runner."""
    @contextmanager
    def limit_session(self, axis):
        session = LimitSession(self, axis)
        try:
            session.begin()
            yield session
        finally:
            session.restore()

    def test_motor_only_limits_without_sync(self):
        for axis in self.rig.profile['physical']:
            with self.limit_session(axis) as s:
                low, high = s.pair(.5)
                native_low, native_high = s.pair(1)
                s.native(native_low, native_high, enabled=False)
                s.motor(low, high)
                s.stable({'.DLLM': low, '.DHLM': high, '-CfgSyncSftLim': 0,
                          '-CfgDLLM-RB': native_low, '-CfgDHLM-RB': native_high,
                          '-CfgDLLM-En-RB': 0, '-CfgDHLM-En-RB': 0})

    def test_controller_only_limits_without_sync(self):
        for axis in self.rig.profile['physical']:
            with self.limit_session(axis) as s:
                low, high = s.pair(.8)
                # Clear the native enables before establishing the special
                # motor 0/0 pair.  Once an enabled native range is published as
                # the motor record's read-only range, two sequential caputs
                # cannot reliably cross through an otherwise-invalid partial
                # zero pair.  Re-enable the native range only after 0/0 exists.
                s.native(low, high, enabled=False)
                s.motor(0, 0)
                s.write('-CfgDLLM-En', 1)
                s.write('-CfgDHLM-En', 1)
                s.stable({'.DLLM': 0, '.DHLM': 0, '-CfgDLLM-RB': low,
                          '-CfgDHLM-RB': high, '-CfgSyncSftLim': 0,
                          '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1})

    def test_nested_independent_limits_without_sync(self):
        for axis in self.rig.profile['physical']:
            with self.limit_session(axis) as s:
                low, high = s.pair(.8)
                motor_low, motor_high = s.pair(.4)
                s.native(low, high)
                s.expect({'.DLLM': low, '.DHLM': high},
                         'motor record consumes the changed native boundary')
                s.motor(motor_low, motor_high)
                s.stable({'.DLLM': motor_low, '.DHLM': motor_high,
                          '-CfgDLLM-RB': low, '-CfgDHLM-RB': high, '-CfgSyncSftLim': 0,
                          '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1})

    def test_native_limits_bound_unsynced_motor_limits(self):
        for axis in self.rig.profile['physical']:
            with self.limit_session(axis) as s:
                native_low, native_high = s.pair(.6)
                motor_low, motor_high = s.pair(.3)
                requested_low, requested_high = s.pair(.9)
                s.native(native_low, native_high)
                s.expect({'.DLLM': native_low, '.DHLM': native_high},
                         'motor record consumes the changed native boundary')
                s.motor(motor_low, motor_high)
                s.write('.DLLM', requested_low)
                s.write('.DHLM', requested_high)
                s.expect({'.DLLM': native_low, '.DHLM': native_high,
                          '-CfgDLLM-RB': native_low, '-CfgDHLM-RB': native_high,
                          '-CfgSyncSftLim': 0},
                         'enabled native range bounds unsynced motor limit edits')
                s.stable({'.DLLM': native_low, '.DHLM': native_high,
                          '-CfgDLLM-RB': native_low, '-CfgDHLM-RB': native_high,
                          '-CfgDLLM-En-RB': 1, '-CfgDHLM-En-RB': 1,
                          '-CfgSyncSftLim': 0})

    def test_motor_soft_limit_callback_rate_is_bounded(self):
        """Motor limit CA events stay at the nominal 1 Hz poll scale."""
        duration = STABLE_SECONDS
        names = [self.rig.prefix + axis + field
                 for axis in self.rig.profile['axes'] for field in ('.DLLM', '.DHLM')]
        # The offline boundary validates the verdict and its negative control;
        # live SIM/HW clients exercise real CA subscriptions below.
        if not hasattr(self.rig.client, 'factory'):
            count = 1000 if self.rig.client.defect == 'high_soft_limit_callback_rate' else 0
            self.assertLessEqual(count, 6, 'synthetic high-rate motor soft-limit callbacks')
            return
        counts = {name: 0 for name in names}
        lock = threading.Lock()
        pvs = []
        try:
            for name in names:
                pv = self.rig.client.factory(name, auto_monitor=True)
                self.assertTrue(pv.wait_for_connection(timeout=self.rig.client.timeout),
                                'connect soft-limit monitor ' + name)
                def callback(pvname=name, **_kwargs):
                    with lock: counts[pvname] += 1
                token = pv.add_callback(callback)
                pvs.append((pv, token))
            # Exclude each subscription's initial value event.
            time.sleep(.2)
            with lock:
                for name in counts: counts[name] = 0
            deadline = time.monotonic() + duration
            while time.monotonic() < deadline:
                for axis in self.rig.profile['axes']:
                    self.assertEqual(self.rig.get(axis, '-Busy'), 0,
                                     axis + ' moved during callback-rate check')
                time.sleep(.05)
            with lock: observed = dict(counts)
            # Nominal idle poll is 1 Hz. Initial-event exclusion plus two-event
            # scheduling margin avoids timing-edge flakes while rejecting loops.
            limit = math.ceil(duration) + 2
            self.assertTrue(all(count <= limit for count in observed.values()),
                            f'motor soft-limit callback rate exceeds poll bound {limit}: {observed}')
        finally:
            for pv, token in pvs:
                pv.remove_callback(token)

    def test_synced_limits_in_both_directions(self):
        for axis in self.rig.profile['physical']:
            with self.limit_session(axis) as s:
                s.sync(1)
                low, high = s.pair(.8)
                s.native(low, high)
                s.expect({'.DLLM': low, '.DHLM': high}, 'native-to-motor limit propagation')
                low, high = s.pair(.4)
                s.motor(low, high)
                s.expect({'-CfgDLLM-RB': low, '-CfgDHLM-RB': high}, 'motor-to-native propagation')

    def test_offsets_and_direction_preserve_dial_and_native_limits(self):
        for axis in self.rig.profile['physical']:
            with self.limit_session(axis) as s:
                for sync in (0, 1):
                    s.sync(sync)
                    # Use a distinct synchronized boundary.  devMotorAsyn
                    # intentionally suppresses a same-value RO status update,
                    # so reusing the unsynchronized pair would not exercise
                    # native-to-motor propagation on the second iteration.
                    low, high = s.pair(.8 if not sync else .7)
                    s.native(low, high)
                    if not sync:
                        s.expect({'.DLLM': low, '.DHLM': high},
                                 'motor record consumes the changed native boundary')
                        low, high = s.pair(.4)
                        s.motor(low, high)
                    else:
                        s.expect({'.DLLM': low, '.DHLM': high}, 'synced starting dial pair')
                    native = {f: self.rig.get(axis, f) for f in ('-CfgDLLM-RB', '-CfgDHLM-RB')}
                    for direction, offset in ((0, 0), (0, 10), (0, -10), (1, 0), (1, 10), (1, -10)):
                        s.write('.DIR', direction)
                        s.write('.OFF', offset)
                        expected_low, expected_high = ((low+offset, high+offset) if direction == 0
                                                      else (offset-high, offset-low))
                        s.expect({'.DIR': direction, '.OFF': offset, '.DLLM': low, '.DHLM': high,
                                  '.LLM': expected_low, '.HLM': expected_high, **native},
                                 'OFF/DIR transforms user limits without shifting native limits')
                        s.stable({'.DLLM': low, '.DHLM': high, **native})

    def test_user_limit_edits_with_offsets_and_sync(self):
        for axis in self.rig.profile['physical']:
            with self.limit_session(axis) as s:
                s.sync(1)
                for direction, offset in ((0, 10), (0, -10), (1, 10), (1, -10)):
                    # Widen within the original envelope before narrowing again.
                    start_low, start_high = s.pair(1)
                    s.native(start_low, start_high)
                    s.expect({'.DLLM': start_low, '.DHLM': start_high},
                             'previous native readback settles before editing user fields')
                    s.write('.DIR', direction); s.write('.OFF', offset)
                    low, high = s.pair(.4)
                    user_low, user_high = ((low+offset, high+offset) if direction == 0
                                          else (offset-high, offset-low))
                    s.write('.LLM', user_low); s.write('.HLM', user_high)
                    s.expect({'.DLLM': low, '.DHLM': high, '-CfgDLLM-RB': low, '-CfgDHLM-RB': high},
                             'user limit edits convert exactly once before reaching ECMC')
