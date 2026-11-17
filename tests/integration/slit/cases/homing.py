"""Homing through motor fields and native commands, using physical sensor geometry."""
from .base import SlitCase
from ..plant import HomingInputs
from collections import deque
import json
import threading
import time
import unittest


# Native 15 and motor 25 perform manual reference setting. Motor 15 is blocked
# by the motor record; 25 is its supported alias and maps to native 15.
EDGES = {1: -.4, 2: .4, 3: -.08, 4: .08, 5: 0., 6: 0.,
         7: .08, 8: -.08, 9: 0., 10: 0., 14: -.4}


class HomingTests(SlitCase):
    axis = 'TR_HI'

    def setUp(self):
        # Decide applicability before preparation or cleanup registration: an
        # expected skip must not re-reference encoders or issue any motion.
        if self.loop != 'closed':
            if self._testMethodName.endswith(('_sequence_21', '_sequence_22')):
                self.skipTest('21/22 require the primary absolute EL5042 encoder')
            if self._testMethodName.endswith('_abort_encoder'):
                self.skipTest('not-ready abort requires the primary EL5042 encoder')
        try:
            capability = self.rig.client.get(self.rig.prefix + 'SIM:SlitTest:HomingSchema')
        except Exception as error:
            raise AssertionError('homing requires the updated dedicated slit_matrix_sim_test IOC; '
                                 'restart it with the home-cam links and HomingSchema marker') from error
        self.assertEqual(capability, 2, 'restart the dedicated IOC with updated axis homing YAML and HomingSchema=2')
        super().setUp()
        # Sync disabled permits independent motor and controller limit pairs.
        if self.rig.get(self.axis, '-CfgSyncSftLim'):
            self.rig.wait(lambda: all(abs(self.rig.get(self.axis, motor) - self.rig.get(self.axis, native)) < 1e-6
                                     for motor, native in (('.LLM', '-CfgDLLM-RB'), ('.HLM', '-CfgDHLM-RB'))),
                          'synchronized motor/native limits agree before homing setup', 5)
        self.saved = {field: self.rig.get(self.axis, field) for field in (
            '-HomProc.OMSL', '-HomProc', '-HomPos', '-VelToHom', '-VelFrmHom', '-AccHom', '-HomUseHVEL',
            '-CfgSyncSftLim', '-CfgDLLM-RB', '-CfgDHLM-RB', '.LLM', '.HLM', '.DLLM', '.DHLM',
            '-CfgDLLM-En-RB', '-CfgDHLM-En-RB', '-MtnCmd_.DISA', '-MtnCmd_.DISV')}
        self.addCleanup(self.restore_reference)
        # The normal record follows movHomCmd through DOL. Use supervisory
        # control during the test so writing HomProc selects the requested ID.
        self.rig.put(self.axis, '-HomProc.OMSL', 0)
        # The UI calcout selects cmdData when MtnCmd changes. Suspend only
        # that automatic selector while testing explicit native sequence IDs.
        self.rig.put(self.axis, '-MtnCmd_.DISV', 1)
        self.rig.put(self.axis, '-MtnCmd_.DISA', 1)
        for field, value in (('-HomUseHVEL', 0), ('-VelToHom', .2), ('-VelFrmHom', .1), ('-AccHom', 1)):
            self.rig.put(self.axis, field, value)
        self.complete = None

    def physical(self):
        return self.rig.plant.physical_position(self.axis)

    def configure_sensors(self, start=0, missing_cam=False):
        self.rig.plant.configure_homing(self.axis)
        if abs(self.rig.get(self.axis, '-PosAct') - start) > .015:
            self.rig.native_move(self.axis, start)
        self.rig.plant.configure_homing(self.axis, HomingInputs(cam_enabled=not missing_cam))
        expected_home = int(not missing_cam and -.08 <= start <= .08)
        self.rig.wait(lambda: self.rig.get(self.axis, '-HomeSwitch') == expected_home,
                      'position-based home cam published at initial position', 3)

    def moving_flags(self):
        self.rig.check_native_error(self.axis)
        self.assertLess(abs(self.physical()), .8, 'physical homing travel must remain bounded')
        return (self.rig.get(self.axis, '-Busy') == 1 and self.rig.get(self.axis, '.DMOV') == 0
                and self.rig.get(self.axis, '.MOVN') == 1 and self.rig.get(self.axis, '-Homed') == 0)

    def start_home(self, sequence, trigger, position=0, field='.HOMF', moving=True):
        self.rig.wait_native_stopped(self.axis)
        self.rig.wait(lambda: self.rig.get(self.axis, '.DMOV') == 1
                      and not int(self.rig.get(self.axis, '.MSTA')) & (1 << 9),
                      'motor idle and recovered before next homing request', 5)
        self.rig.put(self.axis, '-EnaCmd', 1)
        self.rig.wait(lambda: self.rig.get(self.axis, '-EnaAct') == 1, 'drive enabled before homing', 6)
        self.rig.put(self.axis, '-HomPos', position)
        self.rig.put(self.axis, '-HomProc', sequence)
        self.rig.wait(lambda: self.rig.get(self.axis, '-HomProc') == sequence,
                      'requested motor home procedure selected', 3)
        self.complete = None
        self.home_event('request home', sequence=sequence, trigger=trigger)
        if trigger == 'motor':
            self.complete = self.rig.client.put(self.rig.name(self.axis, field), 1, wait=False)
        else:
            self.rig.put(self.axis, '-ExeCmd', 0)
            self.rig.put(self.axis, '-MtnCmd', 10)
            self.rig.put(self.axis, '-MtnCmdData', sequence)
            self.rig.wait(lambda: self.rig.get(self.axis, '-MtnCmd') == 10
                          and self.rig.get(self.axis, '-MtnCmdData') == sequence,
                          'native HOMING command and sequence staged', 3)
            self.rig.put(self.axis, '-ExeCmd', 1)
        self.home_event('home request issued')
        self.rig.trace.append({'action': 'homing triggered', 'sequence': sequence, 'trigger': trigger,
                               'motor_field': field if trigger == 'motor' else None})
        # Observe motion immediately. A full IOC snapshot reads hundreds of
        # PVs and can consume the whole search or the cam-abort window.
        if moving:
            self.rig.wait(self.moving_flags, f'{trigger} home {sequence}: Busy=1 DMOV=0 MOVN=1 Homed=0', 4)
            self.home_event('moving flags observed')
            # MtnCmdData reads control.cmdData (the request), not the
            # sequencer's resolved status.cmdData. Request 14 stays 14 here;
            # the physical edge check in success() verifies its configured home.
            self.assertEqual(self.rig.get(self.axis, '-MtnCmdData'), sequence,
                             'the command PV must retain the requested homing procedure')

    def finished_flags(self):
        return (self.rig.get(self.axis, '-Busy') == 0 and self.rig.get(self.axis, '.DMOV') == 1
                and self.rig.get(self.axis, '.MOVN') == 0 and self.rig.get(self.axis, '-SeqState') == 0
                and self.rig._drive_stationary(self.axis)
                and (self.complete is None or self.complete.is_set()))

    def finish_home(self, expected_position=None, stationary_at=None):
        def done():
            self.rig.check_native_error(self.axis)
            physical = self.physical()
            self.assertLess(abs(physical), .8)
            if stationary_at is not None:
                self.assertAlmostEqual(physical, stationary_at, delta=.003,
                                       msg='manual reference must not move the plant')
            return (self.finished_flags() and self.rig.get(self.axis, '-Homed') == 1
                    and (expected_position is None
                         or abs(self.rig.get(self.axis, '-PosAct') - expected_position) <= .002))
        description = 'homing completes: Busy=0 DMOV=1 MOVN=0 Homed=1'
        if expected_position is not None: description += f' and actual position={expected_position:g}'
        self.rig.wait(done, description, 15)
        self.home_event('completion observed')
        self.assertEqual(self.rig.get(self.axis, '.LVIO'), 0)
        self.assertEqual(self.rig.get(self.axis, '.SEVR'), 0)

    def success(self, sequence, trigger):
        return self.trace_home(self._success, sequence, trigger)

    def trace_home(self, operation, sequence, trigger):
        # Capture asynchronous publication without adding CA polling traffic.
        # Keep verdicts unchanged: this diagnoses missed/incorrect transitions.
        if not hasattr(self.rig.client, 'factory'):
            return operation(sequence, trigger)
        events = deque(maxlen=512)
        lock = threading.Lock()
        started = time.monotonic()
        subscriptions = []

        def event(field, value, timestamp=None):
            if hasattr(value, 'item'):
                value = value.item()
            with lock:
                events.append({'seconds': time.monotonic() - started,
                               'field': field, 'value': value,
                               'ioc_timestamp': timestamp})

        def callback(field):
            def changed(value=None, timestamp=None, **kwargs):
                event(field, value, timestamp)
            return changed

        self._home_event = event
        try:
            for field in ('.DMOV', '.MOVN', '.MIP', '.MSTA', '-Busy', '-ExeCmd-RB',
                          '-SeqState', '-Homed', '-ErrId', '-EnaAct'):
                pv = self.rig.client.factory(self.rig.name(self.axis, field), auto_monitor=True)
                token = pv.add_callback(callback(field))
                subscriptions.append((pv, token))
            self.home_event('before homing setup')
            return operation(sequence, trigger)
        except unittest.SkipTest:
            raise
        except Exception as error:
            self.home_event('failed: ' + str(error).split('\n')[0])
            with lock:
                captured = list(events)
            raise AssertionError(str(error) + '\nHoming status transitions '
                                 '(CA events; fields are not an atomic snapshot):\n'
                                 + json.dumps(captured, indent=2)) from error
        finally:
            self._home_event = None
            for pv, token in subscriptions:
                pv.remove_callback(token)
            with lock:
                captured = list(events)
            self.rig.trace.append({'action': 'homing status transitions', 'axis': self.axis,
                                   'sequence': sequence, 'trigger': trigger, 'events': captured})

    def home_event(self, stage, **details):
        event = getattr(self, '_home_event', None)
        if event:
            event('stage', stage)
            for key, value in details.items():
                event(key, value)
            complete = getattr(self, 'complete', None)
            event('motor_callback_complete', None if complete is None else complete.is_set())

    def _success(self, sequence, trigger):
        if sequence in (21, 22) and self.loop != 'closed':
            self.skipTest('21/22 require the primary absolute EL5042 encoder')
        start = .25 if sequence in (7, 9) else (-.25 if sequence in (8, 10) else 0)
        if sequence in (15, 25): start = .2
        self.configure_sensors(start)
        if sequence in (21, 22):
            # Absolute phase is near 1380 mm in this fixture; sequence 21
            # references the next turn, sequence 22 the preceding turn.
            # Widen coordinates, while the independent physical bound stays .8.
            # Homing disables native limit directions. Set both coordinate
            # interfaces explicitly rather than depending on limit-sync policy.
            self.rig.put(self.axis, '-CfgSyncSftLim', 0)
            self.rig.put(self.axis, '-CfgDLLM', -20000)
            self.rig.put(self.axis, '-CfgDHLM', 20000)
            self.rig.put(self.axis, '.DLLM', -20000)
            self.rig.put(self.axis, '.DHLM', 20000)
            self.rig.wait(lambda: self.rig.get(self.axis, '.LLM') == -20000
                          and self.rig.get(self.axis, '.HLM') == 20000
                          and self.rig.get(self.axis, '-CfgDLLM-RB') == -20000
                          and self.rig.get(self.axis, '-CfgDHLM-RB') == 20000,
                          'motor and native coordinate limits widened for absolute phase homing', 5)
        before = self.physical()
        field = '.HOMR' if sequence in (1, 3, 5, 7, 9, 21) else '.HOMF'
        self.start_home(sequence, trigger, field=field, moving=sequence not in (15, 25))
        if sequence in (15, 25):
            # No moving transient is required, and Homed may already be true.
            # The requested coordinate is the acknowledgement of this request.
            self.finish_home(expected_position=0, stationary_at=before)
        else:
            self.finish_home()
        actual, physical = self.rig.get(self.axis, '-PosAct'), self.physical()
        if sequence in (15, 25):
            self.assertAlmostEqual(physical, before, delta=.003, msg='manual reference must not move the plant')
            self.assertAlmostEqual(actual, 0, delta=.002)
        elif sequence in (21, 22):
            config = self.rig.profile['physical'][self.axis]
            period = (1 << config['absolute_bits']) / config['absolute_counts_per_mm']
            phase = (physical - config['absolute_offset_mm']) % period
            expected = phase - period if sequence == 21 else phase
            self.assertAlmostEqual(actual, expected, delta=.025,
                                   msg='absolute homing must preserve the measured phase within its turn')
        else:
            actual, physical = self.verify_switch_reference(sequence)
        self.rig.trace.append({'action': 'homing reference verified', 'sequence': sequence,
                               'trigger': trigger, 'physical_mm': physical, 'actual': actual,
                               'snapshot': self.rig.snapshot()})

    def verify_switch_reference(self, sequence):
        samples = []
        def referenced():
            self.rig.check_native_error(self.axis)
            self.assertEqual(self.rig.get(self.axis, '-Busy'), 0, 'reference verification must not restart motion')
            self.assertEqual(self.rig.get(self.axis, '-Homed'), 1, 'successful reference must remain homed')
            self.assertTrue(self.rig._drive_stationary(self.axis), 'reference verification requires standstill')
            actual, physical = self.rig.get(self.axis, '-PosAct'), self.physical()
            self.assertLess(abs(physical), .8)
            samples.append({'actual': actual, 'physical': physical, 'offset': physical-actual})
            if len(samples) > 8: samples.pop(0)
            return abs(physical - actual - EDGES[sequence]) <= .025
        try:
            # Homed/status and position are separate published PVs. Allow the
            # final position to arrive without changing the physical edge or
            # tolerance. A persistent wrong reference still times out.
            self.rig.wait(referenced, 'new reference matches physical switch edge/cam midpoint after position publication', 3)
        finally:
            self.rig.trace.append({'action': 'homing reference observations', 'sequence': sequence,
                                   'expected_offset': EDGES[sequence], 'samples': samples})
        return samples[-1]['actual'], samples[-1]['physical']

    def wait_home_phase(self, predicate, description, timeout):
        def checked():
            self.rig.check_native_error(self.axis)
            self.assertLess(abs(self.physical()), .8,
                            'physical homing travel must remain bounded')
            return predicate()
        self.rig.wait(checked, description, timeout)

    def abort(self, cause, trigger, sequence=7):
        # Subscribe instead of polling additional PVs: synchronous diagnostic
        # reads compete with the CA plant and can themselves change timing.
        if not hasattr(self.rig.client, 'factory'):
            return self._abort(cause, trigger, sequence)
        events = deque(maxlen=512)
        lock = threading.Lock()
        started = time.monotonic()
        subscriptions = []

        def event(field, value, timestamp=None):
            if hasattr(value, 'item'): value = value.item()
            with lock:
                events.append({'seconds': time.monotonic()-started, 'field': field,
                               'value': value, 'ioc_timestamp': timestamp})

        def callback(field):
            def changed(value=None, timestamp=None, **kwargs):
                event(field, value, timestamp)
            return changed

        self._abort_event = event
        log_control = self.rig.prefix + 'MCU-RTLog-Ctrl'
        previous_log_control = None
        try:
            previous_log_control = int(self.rig.client.get(
                self.rig.prefix + 'MCU-RTLog-Ctrl-RB'))
            self.rig.client.put(log_control, previous_log_control | 1)
            self.rig.wait(lambda: int(self.rig.client.get(
                self.rig.prefix + 'MCU-RTLog-Ctrl-RB')) & 1,
                'INFO logging enabled for homing abort diagnostics', 3)
            for field in ('.DMOV', '.MOVN', '.MIP', '.MSTA', '-Busy', '-ExeCmd-RB',
                          '-SeqState', '-Homed', '-ErrId', '-EnaAct'):
                pv = self.rig.client.factory(self.rig.name(self.axis, field), auto_monitor=True)
                token = pv.add_callback(callback(field))
                subscriptions.append((pv, token))
            event('stage', 'before home')
            return self._abort(cause, trigger, sequence)
        except unittest.SkipTest:
            raise
        except Exception as error:
            event('stage', 'failed: ' + str(error).split('\n')[0])
            with lock:
                captured = list(events)
            raise AssertionError(str(error) + '\nHoming abort/reset transitions '
                                 '(CA events; fields are not an atomic snapshot):\n'
                                 + json.dumps(captured, indent=2)) from error
        finally:
            for pv, token in subscriptions:
                pv.remove_callback(token)
            self._abort_event = None
            with lock:
                captured = list(events)
            self.rig.trace.append({'action': 'homing abort/reset transitions', 'axis': self.axis,
                                   'cause': cause, 'trigger': trigger, 'events': captured})
            if previous_log_control is not None:
                self.rig.client.put(log_control, previous_log_control)

    def abort_event(self, stage):
        event = getattr(self, '_abort_event', None)
        if event:
            event('stage', stage)
            event('motor_callback_complete', self.complete is None or self.complete.is_set())

    def _abort(self, cause, trigger, sequence=7):
        if cause == 'encoder' and self.loop != 'closed':
            self.skipTest('not-ready abort requires the primary EL5042 encoder')
        self.configure_sensors(.25 if sequence in (7, 9) else 0, missing_cam=cause == 'missing_cam')
        self.start_home(sequence, trigger)
        self.abort_event('home active')
        if cause == 'reverse_stop':
            self.wait_home_phase(lambda: self.rig.get(self.axis, '-SeqState') == 3
                          and self.rig.get(self.axis, '-VelAct') > .02,
                          'homing has reversed away from end switch toward cam', 8)
        elif cause == 'cam_stop':
            self.wait_home_phase(lambda: self.rig.get(self.axis, '-SeqState') == 2
                          and -.04 < self.physical() < .04,
                          'homing is between the two cam edges', 5)
        self.abort_event('request abort: ' + cause)
        if cause in ('stop', 'reverse_stop', 'cam_stop'):
            self.rig.put(self.axis, '-StpCmd', 1)
        elif cause == 'disable':
            self.rig.put(self.axis, '-EnaCmd', 0)
        elif cause == 'drive':
            self.rig.plant.inject(self.axis, drive_fault=True)
        elif cause == 'encoder':
            self.rig.plant.inject(self.axis, ready=False)
        expected_error = {'drive': 0x1460e, 'encoder': 0x14417, 'missing_cam': 0x14d04}.get(cause, 0)
        def aborted():
            error = int(self.rig.get(self.axis, '-ErrId'))
            self.assertIn(error, (0, expected_error), 'unexpected fault during homing abort')
            self.assertLess(abs(self.physical()), .8)
            return error == expected_error and self.finished_flags()
        self.rig.wait(aborted, f'{cause}: sequence aborts and clears Busy/DMOV/MOVN', 10)
        self.abort_event('abort completion observed')
        self.assertEqual(self.rig.get(self.axis, '-Homed'), 0, 'aborted search must not report homed')
        self.rig.trace.append({'action': 'homing aborted', 'cause': cause, 'trigger': trigger,
                               'sequence': sequence, 'snapshot': self.rig.snapshot()})
        if cause in ('disable', 'drive', 'encoder'):
            self.rig.wait(lambda: self.rig.get(self.axis, '-EnaAct') == 0 and self.rig.brake(self.axis) == 0,
                          'abort withdraws drive enable and applies brake', 5)
        self.rig.plant.inject(self.axis, ready=True, drive_fault=False)
        self.rig.wait(lambda: self.rig.encoder_status(self.axis) & 4 and not self.rig.drive_status(self.axis) & 8,
                      'fault input restored before reset', 3)
        if expected_error:
            self.abort_event('reset requested')
            self.rig.reset()
            self.abort_event('reset acknowledged')
        stopped = self.physical()
        self.verify_abort_recovery(stopped)
        # A new explicit request must work, without restarting the old search.
        self.rig.plant.configure_homing(self.axis, HomingInputs())
        self.rig.native_move(self.axis, .25)
        self.start_home(7, trigger)
        self.finish_home()

    def verify_abort_recovery(self, stopped):
        def native_idle():
            self.rig.check_native_error(self.axis)
            self.assertEqual(self.rig.get(self.axis, '-Busy'), 0, 'reset must not restart homing')
            self.assertEqual(self.rig.get(self.axis, '-SeqState'), 0, 'aborted sequencer must stay idle')
            self.assertEqual(self.rig.get(self.axis, '-Homed'), 0, 'reset must not falsely set Homed')
            self.assertTrue(self.rig._drive_stationary(self.axis), 'reset must not restart drive motion')
            self.assertLess(abs(self.physical() - stopped), .015, 'plant must stay at aborted position')

        def idle():
            self.abort_event('recovery check')
            native_idle()
            return self.finished_flags()

        # Reset can trigger another motor status/coordinate callback after the
        # abort callback completed. Guard native standstill throughout this
        # bounded settling interval; never wait through actual resumed motion.
        self.rig.wait(idle, 'motor completion flags settle after homing abort/reset', 5)
        self.rig.assert_stays(idle, 'abort/reset must not replay homing or falsely set Homed')

    def post_home_move(self, trigger):
        return self.trace_home(lambda sequence, source: self._post_home_move(source),
                               14, trigger)

    def _post_home_move(self, trigger):
        transport = self.rig.open_text_commands()
        self.addCleanup(self.rig.close_text_commands, transport)
        number = self.rig.profile['axes'][self.axis]
        command = self.rig.text_command
        previous = int(command(f'GetAxisEncConfigIndex({number})', query=True))
        self.addCleanup(command, f'Cfg.SelectAxisEncConfig({number},{previous})')
        command(f'Cfg.SelectAxisEncConfig({number},{1 if self.loop == "open" else 2})')
        enabled = command(f'GetAxisHomePostMoveEnable({number})', query=True)
        target = command(f'GetAxisHomePostMoveTargetPosition({number})', query=True)
        self.assertEqual(enabled, 0, 'post-home fixture must start with post-move disabled')
        def restore():
            errors = self.rig.stop_all()
            command(f'Cfg.SetAxisHomePostMoveEnable({number},{int(enabled)})')
            command(f'Cfg.SetAxisHomePostMvPos({number},{target:.12g})')
            # Procedure 14 reloads encoder configuration into the sequencer;
            # a Cfg write alone does not reset its cached post-home settings.
            self.rig.reset()
            # unittest runs tearDown before registered cleanups; tearDown
            # clears faults and the simulated sensor scene. Restore switches
            # before searching again to reload the original configuration.
            self.rig.plant.configure_homing(self.axis, HomingInputs())
            self.start_home(14, trigger)
            self.finish_home()
            command(f'Cfg.SelectAxisEncConfig({number},{previous})')
            self.assertFalse(errors, 'STOP before restoring home configuration: ' + str(errors))
        self.addCleanup(restore)
        command(f'Cfg.SetAxisHomePostMvPos({number},0.2)')
        command(f'Cfg.SetAxisHomePostMoveEnable({number},1)')
        self.assertEqual(command(f'GetAxisHomePostMoveTargetPosition({number})', query=True), .2)
        self.assertEqual(command(f'GetAxisHomePostMoveEnable({number})', query=True), 1)
        self.configure_sensors()
        self.start_home(14, trigger)
        self.rig.wait(self.post_move_flags, 'post-home positioning stays Busy/DMOV=0/MOVN=1 after reference', 10)
        self.finish_home()
        self.assertAlmostEqual(self.rig.get(self.axis, '-PosAct'), .2, delta=.015)
        self.assertAlmostEqual(self.physical(), -.2, delta=.025,
                               msg='post-home target must use the new backward-limit reference')

    def post_move_flags(self):
        self.rig.check_native_error(self.axis)
        self.assertLess(abs(self.physical()), .8)
        # status2 publishes the low byte of the internal sequence state.
        return (self.rig.get(self.axis, '-SeqState') == (1003 & 0xff)
                and self.rig.get(self.axis, '-Homed') == 1
                and self.rig.get(self.axis, '-Busy') == 1
                and self.rig.get(self.axis, '.DMOV') == 0
                and self.rig.get(self.axis, '.MOVN') == 1)

    def test_motor_post_home_move(self):
        self.post_home_move('motor')

    def test_native_post_home_move(self):
        self.post_home_move('native')

    def restore_reference(self):
        # Keep feedback alive through STOP. Never reset the plant counters to
        # conceal an offset: reference each real encoder back to physical mm.
        self.assertLess(abs(self.physical()), .8, 'cleanup must not start new motion after a travel-bound failure')
        self.rig.plant.clear_faults()
        errors = self.rig.stop_all()
        if errors: raise AssertionError('homing cleanup STOP failed: ' + '; '.join(errors))
        self.rig.wait(lambda: self.rig.encoder_status(self.axis) & 4 and not self.rig.drive_status(self.axis) & 8,
                      'healthy feedback before restoring references', 5)
        self.rig.reset()
        for encoder in (1, 2):
            self.rig.put(self.axis, '-EnaCmd', 0)
            self.rig.wait_drive_disabled(self.axis)
            self.rig.put(self.axis, '-SetEncIdCmd-RB', encoder)
            reference = self.physical()
            self.start_home(25, 'motor', position=reference, moving=False)
            self.finish_home(expected_position=reference, stationary_at=reference)
            self.assertAlmostEqual(self.rig.get(self.axis, '-PosAct'), self.physical(), delta=.002)
        self.rig.put(self.axis, '-EnaCmd', 0)
        self.rig.wait_drive_disabled(self.axis)
        self.rig.put(self.axis, '-SetEncIdCmd-RB', 1 if self.loop == 'open' else 2)
        # Cleanup needs a verified zero position, not proof of a new move.
        # A tiny/already-zero request can finish between CA observations, so
        # do not require a fresh Busy=1 pulse here as native motion tests do.
        self.rig.stage_native(self.axis, 3, position=0)
        self.rig.put(self.axis, '-ExeCmd', 1)
        self.rig.wait_native_stopped(self.axis, target=0)
        # The fixture's atTarget tolerance is 0.01 mm. A completed return may
        # legitimately auto-disable before reaching the tighter 0.002 mm used
        # above to verify coordinate references. Cleanup must use the normal
        # positioning tolerance, without re-referencing away residual motion.
        self.rig.wait(lambda: abs(self.physical()) < .01
                      and abs(self.rig.get(self.axis, '-PosAct')) < .01,
                      'homing cleanup verifies physical and encoder zero within 10 um', 5)
        self.rig.put(self.axis, '-ExeCmd', 0)
        errors = self.rig.stop_all()
        if errors: raise AssertionError('homing cleanup disable failed: ' + '; '.join(errors))
        # The motor poller must acknowledge the small reference again before
        # tight limits return. Its old absolute readback may still be ~1380 mm
        # even after the native encoder/physical position has reached zero.
        self.rig.sync_motor_record(self.axis)
        # Restore the requested policy before the pairs. Do not turn sync on
        # merely to restore independent motor/controller limits.
        self.rig.put(self.axis, '-CfgSyncSftLim', self.saved['-CfgSyncSftLim'])
        self.rig.put(self.axis, '-CfgDLLM', self.saved['-CfgDLLM-RB'])
        self.rig.put(self.axis, '-CfgDHLM', self.saved['-CfgDHLM-RB'])
        self.rig.put(self.axis, '-CfgDLLM-En', self.saved['-CfgDLLM-En-RB'])
        self.rig.put(self.axis, '-CfgDHLM-En', self.saved['-CfgDHLM-En-RB'])
        self.rig.wait(lambda: abs(self.rig.get(self.axis, '-CfgDLLM-RB') - self.saved['-CfgDLLM-RB']) < 1e-6
                      and abs(self.rig.get(self.axis, '-CfgDHLM-RB') - self.saved['-CfgDHLM-RB']) < 1e-6,
                      'original homing-test coordinate limits restored', 5)
        if self.saved['-CfgSyncSftLim']:
            self.rig.wait(lambda: all(abs(self.rig.get(self.axis, field) - self.saved[key]) < 1e-6
                                     for field, key in (('.LLM', '-CfgDLLM-RB'), ('.HLM', '-CfgDHLM-RB'),
                                                        ('.DLLM', '-CfgDLLM-RB'), ('.DHLM', '-CfgDHLM-RB'))),
                          'motor user/dial limits acknowledge restored native limits', 5)

        self.restore_independent_motor_limits()
        for field in ('-HomProc', '-HomPos', '-VelToHom', '-VelFrmHom', '-AccHom', '-HomUseHVEL'):
            self.rig.put(self.axis, field, self.saved[field])
        self.rig.put(self.axis, '-HomProc.OMSL', self.saved['-HomProc.OMSL'])
        self.rig.put(self.axis, '-MtnCmd_.DISA', self.saved['-MtnCmd_.DISA'])
        self.rig.put(self.axis, '-MtnCmd_.DISV', self.saved['-MtnCmd_.DISV'])

    def restore_independent_motor_limits(self):
        self.rig.put(self.axis, '-CfgSyncSftLim', self.saved['-CfgSyncSftLim'])
        if not self.saved['-CfgSyncSftLim']:
            # These writes must happen with sync off, otherwise the saved motor
            # pair (including 0/0 = no motor limits) would overwrite ECMC limits.
            self.rig.put(self.axis, '.DLLM', self.saved['.DLLM'])
            self.rig.put(self.axis, '.DHLM', self.saved['.DHLM'])
            self.rig.wait(lambda: all(abs(self.rig.get(self.axis, field) - self.saved[field]) < 1e-6
                                     for field in ('.LLM', '.HLM', '.DLLM', '.DHLM')),
                          'independent motor limit pair restored with synchronization disabled', 5)
            self.rig.wait(lambda: all(abs(self.rig.get(self.axis, field) - self.saved[field]) < 1e-6
                                     for field in ('-CfgDLLM-RB', '-CfgDHLM-RB',
                                                   '-CfgDLLM-En-RB', '-CfgDHLM-En-RB')),
                          'restoring independent motor limits leaves controller limits unchanged', 5)

    def test_ignore_disabled_motion_commands(self):
        """Rejected move requests must neither fault nor cancel a running home."""
        self.configure_sensors(0)
        rig = self.rig
        axis_id = rig.profile['axes'][self.axis]
        for suffix, parameter in (('-IlockTxt', 'RTLOG_AXIS_ILOCK_TEXT'),
                                  ('-IlockShrtTxt', 'RTLOG_AXIS_ILOCK_SHORT_TEXT'),
                                  ('-MsgTxt', 'RTLOG_AXIS_MESSAGE_TEXT')):
            # CA DBR_STRING truncates links at 39 characters. The long-string
            # field modifier returns the complete link as a character array.
            link = rig.client.pv(rig.name(self.axis, suffix) + '.INP$').get(
                as_string=True, use_monitor=False, timeout=rig.client.timeout)
            self.assertIn(parameter, link, 'restart IOC with migrated diagnostic PVs')
            self.assertIn(',' + str(axis_id), link, 'diagnostic PV must address its own axis')
        for suffix, field, parameter in (
                ('-CfgDLLM', '.OUT$', 'RTLOG_AXIS_CFG_DLLM'),
                ('-CfgDHLM', '.OUT$', 'RTLOG_AXIS_CFG_DHLM'),
                ('-CfgDLLM-RB', '.INP$', 'RTLOG_AXIS_CFG_DLLM'),
                ('-CfgDHLM-RB', '.INP$', 'RTLOG_AXIS_CFG_DHLM')):
            link = rig.client.pv(rig.name(self.axis, suffix) + field).get(
                as_string=True, use_monitor=False, timeout=rig.client.timeout)
            self.assertIn(parameter, link, 'restart IOC with migrated soft-limit PVs')
            self.assertIn(',' + str(axis_id), link, 'soft-limit PV must address its own axis')
        saved = rig.open_text_commands()
        self.addCleanup(rig.close_text_commands, saved)

        def command(text):
            # AOUT is only 40 bytes. BOUT/NOWT carries the full ASCII parser
            # command with Binary output; the reply still uses ASCII input.
            name = rig.prefix + 'MCU-Cmd'
            old_format = rig.client.get(name + '.OFMT')
            old_count = rig.client.get(name + '.NOWT')
            try:
                rig.client.put(name + '.OFMT', 'Binary')
                rig.client.put(name + '.NOWT', len(text.encode('ascii')))
                rig.client.put(name + '.BOUT', list(text.encode('ascii')))
                reply = rig.client.pv(name + '.AINP').get(
                    as_string=True, use_monitor=False, timeout=rig.client.timeout)
                self.assertEqual(rig.client.get(name + '.SEVR'), 0)
                self.assertIsNotNone(reply)
                self.assertEqual(reply.strip(' ;\r\n\x00'), 'OK', text)
            finally:
                rig.client.put(name + '.NOWT', old_count)
                rig.client.put(name + '.OFMT', old_format)

        def restore_permissions():
            try:
                command(f'StopMotion({axis_id},1)')
            finally:
                try:
                    command(f'Cfg.SetAxisEnableMotionFunctions({axis_id},1,1,1)')
                finally:
                    command(f'Cfg.SetAxisIgnoreDisabledMotionCommands({axis_id},0)')

        self.addCleanup(restore_permissions)
        command(f'Cfg.SetAxisIgnoreDisabledMotionCommands({axis_id},1)')
        command(f'Cfg.SetAxisEnableMotionFunctions({axis_id},0,0,1)')
        self.start_home(1, 'native')
        for request in (f'MoveAbsolutePosition({axis_id},.1,.2,1,1)',
                        f'MoveRelativePosition({axis_id},.1,.2,1,1)',
                        f'MoveVelocity({axis_id},.2,1,1)'):
            self.assertTrue(self.moving_flags(), 'home must still be active before injection')
            command(request)
            rig.check_native_error(self.axis)
            self.assertEqual(rig.get(self.axis, '-MtnCmd'), 10)
            self.assertEqual(rig.get(self.axis, '-Busy'), 1)
        self.finish_home()
        for kill in (0, 1):
            # Sequence 1 finishes at the backward switch. A repeat from there
            # may complete before moving flags can be sampled. Reposition with
            # moves allowed, then restore the policy being tested before home.
            command(f'Cfg.SetAxisEnableMotionFunctions({axis_id},1,1,1)')
            rig.move(self.axis, .2)
            rig.move(self.axis, .15)
            command(f'Cfg.SetAxisEnableMotionFunctions({axis_id},0,0,1)')
            self.start_home(1, 'native')
            command(f'StopMotion({axis_id},{kill})')
            rig.wait_native_stopped(self.axis)
            rig.check_native_error(self.axis)
            if kill:
                rig.wait(lambda: rig.get(self.axis, '-EnaAct') == 0,
                         'kill remains effective with disabled moves ignored', 6)

    def test_motor_sequence_01(self):
        self.success(1, "motor")

    def test_motor_sequence_02(self):
        self.success(2, "motor")

    def test_motor_sequence_03(self):
        self.success(3, "motor")

    def test_motor_sequence_04(self):
        self.success(4, "motor")

    def test_motor_sequence_05(self):
        self.success(5, "motor")

    def test_motor_sequence_06(self):
        self.success(6, "motor")

    def test_motor_sequence_07(self):
        self.success(7, "motor")

    def test_motor_sequence_08(self):
        self.success(8, "motor")

    def test_motor_sequence_09(self):
        self.success(9, "motor")

    def test_motor_sequence_10(self):
        self.success(10, "motor")

    def test_motor_sequence_14(self):
        self.success(14, "motor")

    def test_motor_sequence_25(self):
        self.success(25, "motor")

    def test_motor_sequence_21(self):
        self.success(21, "motor")

    def test_motor_sequence_22(self):
        self.success(22, "motor")

    def test_motor_abort_stop(self):
        self.abort("stop", "motor", sequence=1)

    def test_motor_abort_reverse_stop(self):
        self.abort("reverse_stop", "motor", sequence=3)

    def test_motor_abort_cam_stop(self):
        self.abort("cam_stop", "motor", sequence=9)

    def test_motor_abort_disable(self):
        self.abort("disable", "motor", sequence=7)

    def test_motor_abort_drive(self):
        self.abort("drive", "motor", sequence=7)

    def test_motor_abort_encoder(self):
        self.abort("encoder", "motor", sequence=7)

    def test_motor_abort_missing_cam(self):
        self.abort("missing_cam", "motor", sequence=7)

    def test_native_sequence_01(self):
        self.success(1, "native")

    def test_native_sequence_02(self):
        self.success(2, "native")

    def test_native_sequence_03(self):
        self.success(3, "native")

    def test_native_sequence_04(self):
        self.success(4, "native")

    def test_native_sequence_05(self):
        self.success(5, "native")

    def test_native_sequence_06(self):
        self.success(6, "native")

    def test_native_sequence_07(self):
        self.success(7, "native")

    def test_native_sequence_08(self):
        self.success(8, "native")

    def test_native_sequence_09(self):
        self.success(9, "native")

    def test_native_sequence_10(self):
        self.success(10, "native")

    def test_native_sequence_14(self):
        self.success(14, "native")

    def test_native_sequence_15(self):
        self.success(15, "native")

    def test_native_sequence_21(self):
        self.success(21, "native")

    def test_native_sequence_22(self):
        self.success(22, "native")

    def test_native_abort_stop(self):
        self.abort("stop", "native", sequence=1)

    def test_native_abort_reverse_stop(self):
        self.abort("reverse_stop", "native", sequence=3)

    def test_native_abort_cam_stop(self):
        self.abort("cam_stop", "native", sequence=9)

    def test_native_abort_disable(self):
        self.abort("disable", "native", sequence=7)

    def test_native_abort_drive(self):
        self.abort("drive", "native", sequence=7)

    def test_native_abort_encoder(self):
        self.abort("encoder", "native", sequence=7)

    def test_native_abort_missing_cam(self):
        self.abort("missing_cam", "native", sequence=7)
