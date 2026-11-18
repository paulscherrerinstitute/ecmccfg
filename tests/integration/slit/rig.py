"""Checked PV access, bounded waits and reusable motion assertions."""
import json
import math
import threading
import time
from slit_motion_checks import observe_motion


class Client:
    def __init__(self, factory, timeout=1):
        self.factory, self.timeout, self.pvs = factory, timeout, {}

    def pv(self, name):
        if name not in self.pvs:
            pv = self.factory(name, auto_monitor=False)
            self.pvs[name] = pv
            if not pv.wait_for_connection(timeout=self.timeout):
                raise RuntimeError('cannot connect: ' + name)
        return self.pvs[name]

    def get(self, name):
        value = self.pv(name).get(use_monitor=False, timeout=self.timeout)
        if value is None or not math.isfinite(value):
            raise RuntimeError('cannot read numeric PV: ' + name)
        return value

    def put(self, name, value, *, wait=True, notify=True):
        pv = self.pv(name)
        if not pv.connected or not pv.write_access:
            raise RuntimeError(f'write refused: {name}, connected={pv.connected}, write_access={pv.write_access}')
        complete = threading.Event() if not wait and notify else None
        extra = {'use_complete': True, 'callback': lambda **_kwargs: complete.set()} if complete is not None else {}
        status = pv.put(value, wait=wait, timeout=self.timeout, **extra)
        if status != 1:
            raise RuntimeError(f'write failed: {name}, value={value!r}, result={status!r}, '
                               f'wait={wait}, timeout={self.timeout}s')
        return complete

    def close(self):
        for pv in self.pvs.values():
            pv.disconnect()


class Rig:
    def __init__(self, profile, prefix, client, plant):
        self.profile, self.prefix, self.client, self.plant = profile, prefix, client, plant
        self.names = list(profile['axes'])
        self.trace = []
        self.motion_expectation = None

    def name(self, axis, suffix): return self.prefix + axis + suffix
    def get(self, axis, suffix): return self.client.get(self.name(axis, suffix))
    def put(self, axis, suffix, value):
        # Interrupt/resume fields must be ordinary puts: a second put-notify
        # on the same motor queues behind the active VAL request until it ends.
        if suffix in ('.STOP', '.SPMG', '.JOGF', '.JOGR'):
            return self.client.put(self.name(axis, suffix), value, wait=False, notify=False)
        return self.client.put(self.name(axis, suffix), value, wait=suffix != '.VAL')

    def brake(self, axis):
        brake = self.profile['physical'][axis]['brake']
        return self.client.get(self.prefix + f'SIM:ec0:s{brake["slave"]}:binaryOutput{brake["channel"]}')

    def drive_control(self, axis):
        slave = self.profile['physical'][axis]['drive_slave']
        return int(self.client.get(self.prefix + f'SIM:ec0:s{slave}:driveControl01'))

    def drive_status(self, axis):
        slave = self.profile['physical'][axis]['drive_slave']
        return int(self.client.get(self.prefix + f'SIM:ec0:s{slave}:driveStatus01'))

    def internal_counter(self, axis):
        slave = self.profile['physical'][axis]['drive_slave']
        return int(self.client.get(self.prefix + f'SIM:ec0:s{slave}:positionActual01-RB')) & 0xffff

    def encoder_status(self, axis):
        config = self.profile['physical'][axis]
        return int(self.client.get(self.prefix + f'SIM:ec0:s{config["encoder_slave"]}:'
                                   f'encoderStatus{config["encoder_channel"]}-RB'))

    def guard(self):
        if self.client.get(self.prefix + 'MCU-Cfg-Sim-Mode') != 1:
            raise RuntimeError('refusing test writes: IOC does not report SIM=1')
        expected = self.profile.get('schema', 1)
        actual = self.client.get(self.prefix + 'SIM:SlitTest:Schema')
        if actual != expected:
            raise RuntimeError(f'refusing test writes: slit configuration schema {actual:g}, expected {expected}; '
                               'restart the dedicated IOC with the matching updated tests/integration/slit/ioc configuration')
        for axis, number in self.profile['axes'].items():
            if self.get(axis, '-Id') != number:
                raise RuntimeError('axis identity mismatch: ' + axis)
            if self.get(axis, '.DIR') != 0 or self.get(axis, '.OFF') != 0:
                raise RuntimeError(axis + ': tests require motor DIR=0 and OFF=0')

        probe = self.profile.get('probe_axis')
        if probe and self.get(probe['name'], '-Id') != probe['id']:
            raise RuntimeError('DS402 probe axis identity mismatch')

    def wait(self, predicate, description, timeout=15):
        end = time.monotonic() + timeout
        while time.monotonic() < end:
            self.plant.check()
            if self.motion_expectation is not None: self.motion_expectation.check()
            if predicate(): return
            # Keep command-side CA polling below the load of the independent
            # plant's synchronous feedback circuit, especially on loaded IOCs.
            time.sleep(.05)
        raise AssertionError('timeout: ' + description + '\n' + json.dumps(self.snapshot(), indent=2))

    def snapshot(self):
        result = {}
        for axis in self.names:
            result[axis] = {}
            for suffix in ('-PosAct', '-PosSet', '-EnaAct', '-EnaCmd', '-EnaCmd-RB', '-ExeCmd-RB',
                           '-Busy', '-AtTarget', '-Homed', '-HomeSwitch', '-SeqState', '-ErrId', '-LimFwd', '-LimBwd', '-TrjSrcTyp-RB',
                           '-LastIlock', '-SumIlockFwd', '-SumIlockBwd',
                           '-WrnId', '-SftLimFwdIlock', '-SftLimBwdIlock', '-SftLimFwdEna-RB', '-SftLimBwdEna-RB',
                           '-TgtPosCmd', '-TgtVelCmd', '-MtnCmd', '-MtnCmdData',
                           '-CfgDLLM-RB', '-CfgDHLM-RB', '-CfgDLLM-En-RB', '-CfgDHLM-En-RB',
                           '-CfgSyncSftLim', '.DLLM', '.DHLM', '.LLM', '.HLM', '.VAL', '.RBV', '.DVAL',
                           '.SPDB', '.MRES', '.RDBD', '.BDST',
                           '-Blocked', '-InStartup', '-StartupHeld', '-StartupMotorReady', '-StartupLimitsReady',
                           '.DMOV', '.MOVN', '.MSTA', '.MFLG', '.LVIO', '.STAT', '.SEVR', '.PACT', '.MIP', '.SYNC'):
                try: result[axis][suffix] = float(self.get(axis, suffix))
                except Exception as error: result[axis][suffix] = str(error)
            if 'brake' in self.profile['physical'].get(axis, {}):
                try: result[axis]['brake_output'] = int(self.brake(axis))
                except Exception as error: result[axis]['brake_output'] = str(error)
            if 'encoder_power' in self.profile['physical'].get(axis, {}):
                for suffix in ('-Enc02-PwrState', '-Enc02-PosAct'):
                    try: result[axis][suffix] = self.get(axis, suffix)
                    except Exception as error: result[axis][suffix] = str(error)
            if axis in self.profile['physical']:
                slave = self.profile['physical'][axis]['drive_slave']
                for field in ('driveControl01', 'driveStatus01', 'velocitySetpoint01'):
                    try: result[axis][field] = int(self.client.get(self.prefix + f'SIM:ec0:s{slave}:' + field))
                    except Exception as error: result[axis][field] = str(error)
        result['state_machine'] = {}
        for suffix in ('-Stat', '-StateCmd'):
            try: result['state_machine'][suffix] = int(self.client.get(self.prefix + 'SM00' + suffix))
            except Exception as error: result['state_machine'][suffix] = str(error)
        if hasattr(self.plant, 'snapshot'):
            result['plant'] = self.plant.snapshot()
        return result

    def assert_stays(self, predicate, description, seconds=1):
        deadline = time.monotonic() + seconds
        def observed():
            if not predicate():
                raise AssertionError(description + '\n' + json.dumps(self.snapshot(), indent=2))
            return time.monotonic() >= deadline
        # Negative-duration assertions usually read several CA PVs per sample.
        # A 50 ms cadence still detects state changes promptly without starving
        # the independent SIM plant's synchronous feedback traffic.
        self.wait(observed, description, seconds + 2)

    def stop_all(self):
        errors = []
        probe = self.profile.get('probe_axis')
        if probe:
            axis = probe['name']
            try:
                self.put(axis, '-PC-CancelCmd', 1)
                self.put(axis, '-Enc01-TP-ArmCmd', 0)
                self.put(axis, '-Enc01-TP-EnableCmd', 0)
                self.put(axis, '-StpCmd', 1)
                self.wait(lambda: self.get(axis, '-Busy') == 0,
                          'DS402 probe axis cleanup ramp-down', 5)
            except Exception as error:
                errors.append(str(error))
            finally:
                try: self.put(axis, '-EnaCmd', 0)
                except Exception as error: errors.append(str(error))
        for axis in self.names:
            for suffix in ('.STOP', '-StpCmd'):
                try: self.put(axis, suffix, 1)
                except Exception as error: errors.append(str(error))
        # Keep the plant and drive enable alive during deceleration. Disabling
        # immediately after requesting STOP can itself introduce following error.
        try:
            self.wait(lambda: all(self.get(axis, '-Busy') == 0 for axis in self.names)
                      and all(self._drive_stationary(axis) for axis in self.profile['physical']),
                      'cleanup ramp-down before disabling drives', 5)
        except Exception as error:
            errors.append(str(error))
        finally:
            # Also attempt disable if the plant/IOC failed; preserve the failure.
            for axis in self.names:
                try: self.put(axis, '-EnaCmd', 0)
                except Exception as error: errors.append(str(error))
        return errors

    def wait_drive_disabled(self, axis, timeout=5):
        # Missing acknowledgement is a fresh enable test. Removing feedback
        # from a drive left enabled by preparation instead tests enabled loss.
        def disabled():
            error = int(self.get(axis, '-ErrId'))
            if error:
                raise AssertionError(f'{axis}: fault while establishing disabled state: 0x{error:x}\n'
                                     + json.dumps(self.snapshot(), indent=2))
            return (self.get(axis, '-EnaCmd-RB') == 0 and self.get(axis, '-EnaAct') == 0
                    and not self.drive_control(axis) & 1 and not self.drive_status(axis) & 2
                    and ('brake' not in self.profile['physical'][axis] or self.brake(axis) == 0))
        self.wait(disabled, axis + ' disabled command, feedback and brake before fault injection', timeout)

    def _drive_stationary(self, axis):
        slave = self.profile['physical'][axis]['drive_slave']
        raw = int(self.client.get(self.prefix + f'SIM:ec0:s{slave}:velocitySetpoint01'))
        if raw >= 32768:
            raw -= 65536
        # Dedicated profile: Q15 = 10 mm/s. Allow <0.01 mm/s holding correction
        # from quantized closed-loop feedback, after trajectory Busy is clear.
        return abs(raw) <= 32

    def stop_motion(self, axis, timeout=5):
        try:
            self.put(axis, '.STOP', 1)
            self.trace.append({'action': 'motor STOP requested', 'axis': axis, 'snapshot': self.snapshot()})
            def stopped():
                error = int(self.get(axis, '-ErrId'))
                if error:
                    raise RuntimeError(f'{axis}: error during STOP: 0x{error:x}')
                return (self.get(axis, '.DMOV') == 1
                        and self.get(axis, '-Busy') == 0 and abs(self.get(axis, '-VelAct')) < .01)
            self.wait(stopped, axis + ' decelerates and completes motor STOP', timeout)
            if self.get(axis, '.SEVR'):
                raise RuntimeError(axis + ': motor alarm after STOP')
            self.trace.append({'action': 'motor STOP completed', 'axis': axis, 'snapshot': self.snapshot()})
        except Exception as error:
            snapshot = self.snapshot()
            self.trace.append({'action': 'motor STOP failed', 'axis': axis, 'error': str(error), 'snapshot': snapshot})
            raise RuntimeError(str(error) + '\nSTOP diagnostics (before cleanup):\n'
                               + json.dumps(snapshot, indent=2)) from error

    def reset(self):
        for axis in self.names:
            self.put(axis, '-RstCmd', 1)
        self.client.put(self.prefix + 'SM00-StateCmd', 3)
        self.wait(lambda: self.client.get(self.prefix + 'SM00-StateCmd') == 0
                  and all(self.get(axis, '-ErrId') == 0 for axis in self.names),
                  'axis fault reset and state-machine RESET completion', 5)

    def sync_motor_record(self, axis):
        # Fault recovery and axis-PV commands can leave the motor target stale.
        # Synchronize record targets to fresh readback before setup's zero move;
        # SYNC does not redefine the physical position or command a move.
        self.wait(lambda: self.get(axis, '-ErrId') == 0
                  and not int(self.get(axis, '.MSTA')) & (1 << 9)
                  and self.get(axis, '.DMOV') == 1 and self.get(axis, '-Busy') == 0
                  and abs(self.get(axis, '.RBV') - self.get(axis, '-PosAct')) < .001,
                  axis + ' fresh idle motor readback and cleared problem bit before setup synchronization', 5)
        self.put(axis, '.SYNC', 1)
        self.wait(lambda: self.get(axis, '.SYNC') == 0
                  and abs(self.get(axis, '.VAL') - self.get(axis, '.RBV')) < .001,
                  axis + ' motor target synchronized to readback', 5)

    def prepare(self, mode):
        self.plant.clear_faults()
        self.wait(lambda: all(self.encoder_status(axis) & 4 and not self.drive_status(axis) & 8
                              for axis in self.profile['physical']),
                  'plant publishes restored encoder readiness and cleared drive faults', 5)
        errors = self.stop_all()
        if errors:
            raise RuntimeError('preparation stop failed: ' + '; '.join(errors))
        self.wait(lambda: all(self.get(axis, '-Busy') == 0 for axis in self.names), 'stopped axes', 5)
        self.client.put(self.prefix + 'SM00-EnaCmd', 1)
        self.reset()
        for axis in self.profile['physical']:
            self.put(axis, '-SetEncIdCmd-RB', 1 if mode == 'open' else 2)
            self.put(axis, '-Ctrl-Kp', 0 if mode == 'open' else 2)
            self.put(axis, '-Ctrl-Ki', 0)
            self.put(axis, '-Ctrl-Kd', 0)
            self.put(axis, '-Ctrl-Kff', 1)
        for axis in self.names:
            self.put(axis, '.VELO', .4)
            self.put(axis, '.ACCL', .4)
        self.reset()
        for axis in self.profile['physical']:
            self.wait_drive_disabled(axis)
            self.sync_motor_record(axis)
            self.move(axis, 0)
        self.kinematics()

    def stage_native(self, axis, command, position=0, velocity=.4):
        """Stage an ECMC command with execute low; never write motor VAL."""
        if command not in (1, 2, 3) or not all(math.isfinite(v) for v in (position, velocity)):
            raise ValueError('native motion requires VEL=1, REL=2 or ABS=3 and finite targets')
        if velocity == 0 or (command != 1 and velocity < 0):
            raise ValueError('position moves require positive speed; velocity moves require nonzero speed')
        self.wait_native_stopped(axis)
        # Clear the command trigger before staging. ExeCmd-RB is sequencer
        # state, not an acknowledgement of this auto-reset command bit; it may
        # remain high after a completed move. Zero is not a stop request.
        self.put(axis, '-ExeCmd', 0)
        for suffix, value in (('-MtnCmd', command), ('-MtnCmdData', 0),
                              ('-TgtPosCmd', position), ('-TgtVelCmd', velocity)):
            self.put(axis, suffix, value)
        self.wait(lambda: self.get(axis, '-MtnCmd') == command and self.get(axis, '-MtnCmdData') == 0
                  and abs(self.get(axis, '-TgtPosCmd') - position) < 1e-7
                  and abs(self.get(axis, '-TgtVelCmd') - velocity) < 1e-7,
                  axis + ' native command and targets staged', 3)
        self.put(axis, '-EnaCmd', 1)
        self.wait(lambda: self.get(axis, '-EnaAct') == 1, axis + ' enabled for native command', 6)
        self.trace.append({'action': 'native command staged', 'axis': axis, 'command': command,
                           'position': position, 'velocity': velocity, 'snapshot': self.snapshot()})

    def execute_native(self, axis):
        self.put(axis, '-ExeCmd', 1)
        def active():
            self.check_native_error(axis)
            return self.get(axis, '-Busy') == 1
        self.wait(active, axis + ' native execute starts motion', 5)

    def check_native_error(self, axis):
        error = int(self.get(axis, '-ErrId'))
        if error:
            snapshot = self.snapshot()
            self.trace.append({'action': 'native motion failed', 'axis': axis,
                               'error': error, 'snapshot': snapshot})
            raise AssertionError(f'{axis}: native motion fault 0x{error:x}\n'
                                 + json.dumps(snapshot, indent=2))

    def wait_native_stopped(self, axis, target=None, timeout=10):
        def stopped():
            self.check_native_error(axis)
            return (self.get(axis, '-Busy') == 0 and abs(self.get(axis, '-VelAct')) < .01
                    and (target is None or abs(self.get(axis, '-PosAct') - target) < .015))
        self.wait(stopped, axis + ' native motion stopped' + ('' if target is None else f' at {target}'), timeout)

    def native_move(self, axis, position, command=3, velocity=.4, expected=None):
        if command not in (2, 3) or (command == 2 and expected is None):
            raise ValueError('relative moves require an independently specified expected position')
        with observe_motion(self, axis, position if expected is None else expected):
            self.stage_native(axis, command, position, velocity)
            self.execute_native(axis)
            self.wait_native_stopped(axis, position if expected is None else expected)
            self.put(axis, '-ExeCmd', 0)
            self.trace.append({'action': 'native move completed', 'axis': axis, 'command': command,
                               'position': position, 'snapshot': self.snapshot()})

    def start_move(self, axis, target):
        try:
            self.wait(lambda: self.get(axis, '.DMOV') == 1 and self.get(axis, '-Busy') == 0,
                      axis + ' idle before next motion request', 5)
            if not self.get(axis, '-EnaAct'):
                self.put(axis, '-EnaCmd', 1)
                self.wait(lambda: self.get(axis, '-EnaAct') == 1, axis + ' enabled', 6)
            complete = self.put(axis, '.VAL', target)
            def accepted():
                error = int(self.get(axis, '-ErrId'))
                if error:
                    raise RuntimeError(f'{axis}: motion request raised axis error 0x{error:x}')
                if complete.is_set() and self.get(axis, '.LVIO'):
                    raise RuntimeError(axis + ': motor rejected target at a limit (LVIO=1)')
                return (self.get(axis, '-Busy') == 1 or self.get(axis, '.DMOV') == 0
                        or (complete.is_set() and abs(self.get(axis, '-PosAct') - target) < .015))
            self.wait(accepted, axis + ' accepts motion request', 5)
            return complete
        except Exception as error:
            snapshot = self.snapshot()
            self.trace.append({'action': 'motion request failed', 'axis': axis, 'target': target,
                               'error': str(error), 'snapshot': snapshot})
            raise RuntimeError(str(error) + '\nMotion-request diagnostics (before cleanup):\n'
                               + json.dumps(snapshot, indent=2)) from error

    def move(self, axis, target, timeout=15):
        with observe_motion(self, axis, target):
            complete = self.start_move(axis, target)
            def arrived():
                error = int(self.get(axis, '-ErrId'))
                if error:
                    snapshot = self.snapshot()
                    self.trace.append({'action': 'move failed', 'axis': axis, 'target': target,
                                       'error': error, 'snapshot': snapshot})
                    raise AssertionError(f'{axis}: axis fault during motion 0x{error:x}\n'
                                         'Motion diagnostics (before cleanup):\n' + json.dumps(snapshot, indent=2))
                return (complete.is_set() and self.get(axis, '.DMOV') == 1 and self.get(axis, '-Busy') == 0
                        and abs(self.get(axis, '-PosAct') - target) < .015)
            self.wait(arrived, f'{axis} reaches {target}', timeout)
            error = self.get(axis, '-ErrId')
            if error: raise AssertionError(f'{axis}: unexpected error 0x{int(error):x}')
            # Retain the values that triggered the verdict: independent CA reads
            # and the later full snapshot can observe different motor polls.
            verdict = {suffix: self.get(axis, suffix) for suffix in ('.LVIO', '.SEVR')}
            if verdict['.LVIO'] or verdict['.SEVR']:
                verdict.update({suffix: self.get(axis, suffix) for suffix in ('.STAT', '.MSTA')})
                snapshot = self.snapshot()
                self.trace.append({'action': 'motor completion rejected', 'axis': axis, 'target': target,
                                   'verdict': verdict, 'snapshot': snapshot})
                raise AssertionError(axis + ': motor completed with a limit violation/alarm\n'
                                     + 'Triggering reads (before diagnostic snapshot):\n'
                                     + json.dumps(verdict, indent=2) + '\n'
                                     + json.dumps(snapshot, indent=2))
            self.trace.append({'action': 'move', 'axis': axis, 'target': target, 'snapshot': self.snapshot()})

    def kinematics(self):
        lo, hi = (self.get(axis, '-PosAct') for axis in ('TR_LO', 'TR_HI'))
        self.wait(lambda: abs(self.get('CENTERY', '-PosAct') - (lo + hi) / 2) < .02
                  and abs(self.get('GAPY', '-PosAct') - (hi - lo)) < .02, 'forward slit kinematics', 3)

    def open_text_commands(self):
        """Configure the existing MCU-Cmd asyn record; caller restores fields."""
        name = self.prefix + 'MCU-Cmd'
        saved = {field: self.client.get(name + field) for field in ('.TMOD', '.IFMT', '.OFMT')}
        try:
            for field, value in (('.TMOD', 'Write/Read'), ('.IFMT', 'ASCII'), ('.OFMT', 'ASCII')):
                self.client.put(name + field, value)
        except Exception:
            self.close_text_commands(saved)
            raise
        return saved

    def close_text_commands(self, saved):
        for field, value in saved.items():
            self.client.put(self.prefix + 'MCU-Cmd' + field, value)

    def text_command(self, command, query=False):
        """One synchronous command/reply; never accept parser errors as success."""
        if len(command.encode('utf-8')) >= 40:
            raise ValueError('MCU-Cmd.AOUT accepts at most 39 bytes; use a shorter command: ' + command)
        name = self.prefix + 'MCU-Cmd'
        self.client.put(name + '.AOUT', command)
        reply = self.client.pv(name + '.AINP').get(as_string=True, use_monitor=False,
                                                 timeout=self.client.timeout)
        if reply is None or self.client.get(name + '.SEVR'):
            raise AssertionError('MCU-Cmd transport failed: ' + command)
        reply = reply.strip(' ;\r\n\x00')
        if query:
            value = float(reply)
            if not math.isfinite(value): raise AssertionError('nonfinite MCU-Cmd reply: ' + reply)
            return value
        if reply != 'OK':
            raise AssertionError(f'MCU-Cmd rejected {command!r}: {reply!r}')

    def fault_stopped(self, axis, code=None, timeout=8):
        self.wait(lambda: self.get(axis, '-ErrId') != 0 and self.get(axis, '-EnaAct') == 0,
                  axis + ' faults and disables', timeout)
        if code is not None and self.get(axis, '-ErrId') != code:
            raise AssertionError(f'{axis}: expected 0x{code:x}, got 0x{int(self.get(axis,"-ErrId")):x}')
        config = self.profile['physical'][axis]
        base = self.prefix + f'SIM:ec0:s{config["drive_slave"]}:'
        # An invalid/frozen encoder may retain its last velocity; it cannot
        # establish stopping. Check the controller's outgoing drive commands.
        self.wait(lambda: self.client.get(base + 'velocitySetpoint01') == 0
                  and int(self.client.get(base + 'driveControl01')) & 1 == 0,
                  axis + ' drive commands settle to disabled/zero', 5)
        if 'brake' in config:
            self.wait(lambda: self.brake(axis) == 0, axis + ' brake applied after fault', 3)
