"""Hardware motion, controlled stall recovery and opt-in limit homing checks."""
import time
import unittest
from .command_burst import CommandBurstTests
from .homing import HomingTests, HOMING_NAMES
from .softlimits import SoftLimitModeTests, SOFT_LIMIT_NAMES
from slit_recovery import concurrent_physical_moves
from slit_recovery import StallCases, CoupledStopCases, STALL_NAMES, COUPLED_STOP_NAMES, stall_alarm, stop_blade_during_virtual
from slit_pvt import PVTInterruptions, PVT_INTERRUPTION_NAMES, run_interrupted_profile


class StatusTests(unittest.TestCase):
    def test_idle_status_and_kinematics(self):
        self.assertTrue(self.rig.healthy())
        self.assertTrue(self.rig.idle())
        self.rig.kinematics()


class MotionTests(unittest.TestCase):
    def round_trip(self, axis):
        origin, step = self.rig.origins[axis], self.rig.profile['step']
        for target in (origin+step, origin-step, origin):
            self.rig.move(axis, target)

    def test_physical_lo_both_directions(self): self.round_trip('TR_LO')
    def test_physical_hi_both_directions(self): self.round_trip('TR_HI')

    def test_repeated_motor_targets(self):
        axis = 'TR_LO'
        origin, step = self.rig.origins[axis], self.rig.profile['step']
        complete = self.rig.start(axis, origin+step)
        # Keep the original completion request. Extra put-notify requests on
        # an active motor can queue behind it; the burst must use ordinary puts.
        for _ in range(3): self.rig.put(axis, '.VAL', origin+step, notify=False)
        self.rig.finish(axis, origin+step, complete)
        self.rig.move(axis, origin)

    def test_motor_stop_during_move(self):
        axis = 'TR_LO'
        origin, step = self.rig.origins[axis], self.rig.profile['step']
        self.rig.start(axis, origin+step)
        self.rig.wait(lambda: self.rig.get(axis, '-EnaAct') == 1
                      and abs(self.rig.get(axis, '-VelAct')) > min(.005, self.rig.profile['velocity']/10)
                      and abs(self.rig.get(axis, '-PosAct')-origin) > self.rig.profile['tolerance']/2,
                      'physical movement before STOP')
        self.rig.put(axis, '.STOP', 1)
        self.rig.wait(self.rig.idle, 'STOP completes')
        stopped = self.rig.get(axis, '-PosAct')
        self.assertGreater(abs(stopped-origin-step), self.rig.profile['tolerance'],
                           'STOP must halt the move before its destination')
        deadline = time.monotonic()+.5
        while time.monotonic() < deadline:
            self.rig.healthy()
            self.assertTrue(self.rig.idle())
            self.assertAlmostEqual(self.rig.get(axis, '-PosAct'), stopped,
                                   delta=self.rig.profile['tolerance'])
            time.sleep(.02)
        self.rig.move(axis, origin)


class DmovLifecycleTests(unittest.TestCase):
    """Require the complete motor Done/Moving transition on real motion."""

    def motor_lifecycle(self, axis):
        rig = self.rig
        origin, target = rig.origins[axis], rig.origins[axis] + rig.profile['step']
        complete = rig.start(axis, target)
        rig.wait(lambda: rig.get(axis, '-Busy') == 1
                 and rig.get(axis, '.DMOV') == 0
                 and rig.get(axis, '.MOVN') == 1,
                 axis+' motor move exposes Busy=1, DMOV=0 and MOVN=1')
        if complete is not None and complete.is_set():
            raise AssertionError(axis+': put-notify completed while DMOV was still low')
        rig.finish(axis, target, complete)
        rig.move(axis, origin)

    def test_motor_and_native_dmov_lifecycle(self):
        # Motor-record commands cover one physical and one virtual axis.
        self.motor_lifecycle('TR_LO')
        self.motor_lifecycle('CENTERY')

        # Native writes remain restricted to physical axes by Operations.
        axis = 'TR_HI'
        origin, target = self.rig.origins[axis], self.rig.origins[axis] + self.rig.profile['step']
        with self.rig.native_configuration(axis):
            self.rig.native_move(axis, target, target, require_motor_flags=True)
            self.rig.native_move(axis, origin, origin, require_motor_flags=True)


class VirtualTests(MotionTests):
    # Load only the two virtual cases through the explicit runner group below.
    def test_center_both_directions(self): self.round_trip('CENTERY')
    def test_gap_both_directions(self): self.round_trip('GAPY')


class EncoderPowerTests(unittest.TestCase):
    def test_real_encoder_sleep_wake_and_backup(self):
        rig = self.rig
        cfg = rig.profile['encoder_power']
        axis, enc = cfg['axis'], cfg['encoder']
        stem = f'-Enc0{enc}'
        self.assertEqual(rig.get(axis, '-EncMode-RB'), 0, 'select Auto power before this group')
        self.assertEqual(rig.get(axis, rig.encoder_force_suffix(True)), 0, 'release Force ON before this group')
        self.assertEqual(rig.get(axis, stem+'-PwrEnable-RB'), 1)
        self.assertEqual(rig.get(axis, stem+'-Absolute'), 1)
        self.assertEqual(rig.get(axis, '-Enc01-Absolute'), 0)
        origin, step = rig.origins[axis], rig.profile['step']
        rig.move(axis, origin+step)
        rig.wait(lambda: rig.get(axis, stem+'-PwrState') == 1
                 and rig.get(axis, '-SetEncIdCmd-RB') == cfg['backup']
                 and rig.get(axis, '-Enc01-Ready') == 1
                 and rig.get(axis, stem+'-PwrOn') == 0,
                 'settled move powers down BiSS and selects tracking encoder', cfg['timeout'])
        complete = rig.start(axis, origin)
        rig.wait(lambda: rig.get(axis, stem+'-PwrState') == 3
                 and rig.get(axis, stem+'-Ready') == 1
                 and rig.get(axis, '-SetEncIdCmd-RB') == enc,
                 'real encoder powers up, becomes ready and is selected', cfg['timeout'])
        rig.finish(axis, origin, complete)


class NativeTests(unittest.TestCase):
    def exercise(self, axis, on_write=False, auto_enable=False):
        rig, origin, step = self.rig, self.rig.origins[axis], self.rig.profile['step']
        with rig.native_configuration(axis):
            if on_write:
                rig.native_put(axis, '-MtnCmd', 3)
                rig.native_put(axis, '-MtnCmdData', 0)
                rig.native_put(axis, '-TgtVelCmd', rig.profile['velocity'])
                before = rig.get(axis, '-PosAct')
                rig.native_put(axis, '-TgtPosCmd', origin+step)
                rig.holds_position(axis, before)
                rig.set_auto_execute(axis, 1)
                rig.holds_position(axis, before)
            if auto_enable:
                number = rig.profile['axes'][axis]
                self.assertEqual(rig.text_command(f'GetAxisEnableAutoEnable({number})', query=True), 1)
                rig.disable_axis(axis)
            rig.native_move(axis, origin+step, origin+step, on_write=on_write)
            if auto_enable: self.assertEqual(rig.get(axis, '-EnaAct'), 1)
            rig.native_move(axis, origin-step, origin-step, on_write=on_write)
            # Identical relative target writes must each execute a fresh move.
            rig.native_move(axis, step, origin, command=2, on_write=on_write)
            rig.native_move(axis, step, origin+step, command=2, on_write=on_write)
            rig.native_move(axis, origin, origin, on_write=on_write)

    def test_native_lo_absolute_and_relative(self): self.exercise('TR_LO')
    def test_native_hi_absolute_and_relative(self): self.exercise('TR_HI')
    def test_target_write_lo_absolute_and_repeated_relative(self): self.exercise('TR_LO', on_write=True)
    def test_target_write_hi_absolute_and_repeated_relative(self): self.exercise('TR_HI', on_write=True)
    def test_target_write_lo_auto_enable(self): self.exercise('TR_LO', on_write=True, auto_enable=True)
    def test_target_write_hi_auto_enable(self): self.exercise('TR_HI', on_write=True, auto_enable=True)


class MotorCoordinateTests(unittest.TestCase):
    def exercise(self, axis):
        rig, origin, step = self.rig, self.rig.origins[axis], self.rig.profile['step']
        with rig.motor_coordinates(axis) as saved:
            for direction, offset in ((0, step/2), (1, -step/2)):
                rig.select_motor_coordinates(axis, direction, offset)
                for dial in (origin+step, origin-step, origin):
                    rig.move(axis, dial)
                    self.assertAlmostEqual(rig.get(axis, '.DVAL'), dial, delta=rig.profile['tolerance'])
                    self.assertAlmostEqual(rig.get(axis, '.RBV'), offset+(-1 if direction else 1)*dial,
                                           delta=rig.profile['tolerance'])
                    for field in ('-CfgDLLM-RB', '-CfgDHLM-RB'):
                        self.assertAlmostEqual(rig.get(axis, field), saved[field], delta=1e-6)

    def test_motor_lo_offset_and_direction(self): self.exercise('TR_LO')
    def test_motor_hi_offset_and_direction(self): self.exercise('TR_HI')


class PVTTests(PVTInterruptions, unittest.TestCase):
    def exercise(self, axis, triggers=False):
        from slit_pvt import run_profile
        self.rig.touched.add(axis)
        run_profile(self.rig, axis, self.rig.profile['step']/2,
                    self.rig.profile['velocity'], self.rig.validate_target, triggers=triggers)

    def interrupt_profile(self, axis, method, phase):
        self.rig.touched.add(axis)
        run_interrupted_profile(self.rig, axis, self.rig.profile['step']/2,
                                self.rig.profile['velocity'], self.rig.validate_target, method, phase)

    def test_pvt_lo_round_trip(self): self.exercise('TR_LO')
    def test_pvt_hi_round_trip(self): self.exercise('TR_HI')
    def test_pvt_lo_triggers(self): self.exercise('TR_LO', triggers=True)
    def test_pvt_hi_triggers(self): self.exercise('TR_HI', triggers=True)


class BrakeTests(unittest.TestCase):
    def applied(self, axis):
        self.rig.wait(lambda: self.rig.brake(axis) == 0
                      and not self.rig.drive_control(axis) & 1
                      and self.rig.get(axis, '-EnaAct') == 0,
                      axis+' brake applied and amplifier disabled')

    def release_and_apply(self, axis):
        rig = self.rig
        with rig.native_configuration(axis):
            self.applied(axis)
            before = rig.get(axis, '-PosAct')
            rig.client.put(rig.prefix+axis+'-EnaCmd', 1, wait=False, notify=False)
            rig.wait(lambda: rig.drive_control(axis) & 1 and rig.brake(axis) == 0,
                     axis+' amplifier on before delayed brake release')
            self.assertAlmostEqual(rig.get(axis, '-PosAct'), before, delta=rig.profile['tolerance'])
            rig.trace.append({'action': 'brake opening phase', 'axis': axis})
            rig.wait(lambda: rig.brake(axis) == 1 and rig.get(axis, '-EnaAct') == 1,
                     axis+' brake released after opening delay')
            rig.holds_position(axis, before)
            rig.client.put(rig.prefix+axis+'-EnaCmd', 0, wait=False, notify=False)
            rig.wait(lambda: rig.brake(axis) == 0 and rig.drive_control(axis) & 1,
                     axis+' brake applied before amplifier disable')
            rig.trace.append({'action': 'brake closing phase', 'axis': axis})
            self.applied(axis)
            rig.holds_position(axis, before)

    def motion(self, axis, stop=False):
        rig, origin = self.rig, self.rig.origins[axis]
        with rig.native_configuration(axis):
            self.applied(axis)
            target = origin+rig.profile['step']
            complete = rig.start(axis, target)
            def moving():
                velocity = abs(rig.get(axis, '-VelAct'))
                if velocity > .005:
                    self.assertEqual(rig.brake(axis), 1, axis+': brake applied during movement')
                return (rig.get(axis, '-Busy') == 1 and velocity > .005
                        and abs(rig.get(axis, '-PosAct')-origin) > rig.profile['tolerance'])
            rig.wait(moving, axis+' actual movement with brake released')
            if stop: rig.put(axis, '.STOP', 1)
            def stopped():
                # Busy includes encoder/drive power-up, so test the brake while
                # the axis actually moves, including STOP deceleration.
                if abs(rig.get(axis, '-VelAct')) > .005:
                    self.assertEqual(rig.brake(axis), 1, axis+': brake applied during movement')
                    self.assertEqual(rig.drive_control(axis) & 1, 1)
                return rig.idle()
            rig.wait(stopped, axis+' movement stops with brake released')
            if stop:
                position = rig.get(axis, '-PosAct')
                self.assertGreater(abs(position-target), rig.profile['tolerance'])
                rig.settle_after_stop(axis, position)
                rig.holds_position(axis, position, context='post-STOP hold')
            else:
                rig.finish(axis, target, complete)
            self.applied(axis)  # Normal drive auto-disable must apply the brake.
            rig.trace.append({'action': 'brake applied after STOP' if stop else 'brake applied after move',
                              'axis': axis, 'snapshot': rig.snapshot()})
            # Return normally, also checking release throughout the return move.
            complete = rig.start(axis, origin)
            rig.wait(stopped, axis+' return movement stops with brake released')
            rig.finish(axis, origin, complete)
            self.applied(axis)

    def test_brake_lo_release_and_application(self): self.release_and_apply('TR_LO')
    def test_brake_hi_release_and_application(self): self.release_and_apply('TR_HI')
    def test_brake_lo_motion_and_auto_disable(self): self.motion('TR_LO')
    def test_brake_hi_motion_and_auto_disable(self): self.motion('TR_HI')
    def test_brake_lo_stop_and_auto_disable(self): self.motion('TR_LO', stop=True)
    def test_brake_hi_stop_and_auto_disable(self): self.motion('TR_HI', stop=True)


class StallTests(StallCases, unittest.TestCase):
    def exercise_stall(self, axis, trigger):
        with self.rig.native_configuration(axis):
            stall_alarm(self.rig, axis, trigger, self.rig.profile['step'],
                        self.rig.profile['velocity'], self.rig.validate_target)


class CoupledStopTests(CoupledStopCases, unittest.TestCase):
    def exercise_coupled_stop(self, master, blade, interface):
        stop_blade_during_virtual(self.rig, master, blade, interface,
                                  self.rig.profile['step'], self.rig.validate_target)


class ConcurrentTests(unittest.TestCase):
    def exercise(self, primary, secondary):
        concurrent_physical_moves(self.rig, primary, secondary, self.rig.profile['step'],
                                  self.rig.profile['velocity'], self.rig.validate_target)

    def test_lo_moves_while_hi_is_nudged(self): self.exercise('TR_LO', 'TR_HI')
    def test_hi_moves_while_lo_is_nudged(self): self.exercise('TR_HI', 'TR_LO')


GROUPS = {
    'command_burst': (CommandBurstTests, ('test_all_axes_command_burst_recovers',)),
    'softlimits': (SoftLimitModeTests, SOFT_LIMIT_NAMES),
    'homing': (HomingTests, HOMING_NAMES),
    'status': (StatusTests, ('test_idle_status_and_kinematics',)),
    'motion': (MotionTests, ('test_physical_lo_both_directions', 'test_physical_hi_both_directions',
                            'test_repeated_motor_targets', 'test_motor_stop_during_move')),
    'dmov': (DmovLifecycleTests, ('test_motor_and_native_dmov_lifecycle',)),
    'stall': (StallTests, STALL_NAMES),
    'coupled_stop': (CoupledStopTests, COUPLED_STOP_NAMES),
    'concurrent': (ConcurrentTests, ('test_lo_moves_while_hi_is_nudged', 'test_hi_moves_while_lo_is_nudged')),
    'virtual': (VirtualTests, ('test_center_both_directions', 'test_gap_both_directions')),
    'encoder_power': (EncoderPowerTests, ('test_real_encoder_sleep_wake_and_backup',)),
    'native': (NativeTests, ('test_native_lo_absolute_and_relative', 'test_native_hi_absolute_and_relative')),
    'target_write': (NativeTests, ('test_target_write_lo_absolute_and_repeated_relative',
                                  'test_target_write_hi_absolute_and_repeated_relative',
                                  'test_target_write_lo_auto_enable', 'test_target_write_hi_auto_enable')),
    'motor': (MotorCoordinateTests, ('test_motor_lo_offset_and_direction', 'test_motor_hi_offset_and_direction')),
    'brake': (BrakeTests, ('test_brake_lo_release_and_application', 'test_brake_hi_release_and_application',
                           'test_brake_lo_motion_and_auto_disable', 'test_brake_hi_motion_and_auto_disable',
                           'test_brake_lo_stop_and_auto_disable', 'test_brake_hi_stop_and_auto_disable')),
    'pvt': (PVTTests, ('test_pvt_lo_round_trip', 'test_pvt_hi_round_trip',
                       'test_pvt_lo_triggers', 'test_pvt_hi_triggers')+PVT_INTERRUPTION_NAMES),
}


class NoMasterSlaveTests(unittest.TestCase):
    """Physical-only repeats with state-machine management explicitly disabled."""


def standalone_method(cls, original):
    def exercise(self):
        with self.rig.without_state_machine(self.motion_axes[0]):
            # Reuse the same assertions and motion sequence in both modes.
            case = cls(original)
            case.rig = self.rig
            getattr(case, original)()
    exercise.__name__ = 'test_no_sm_'+original[len('test_'):]
    return exercise


standalone_names = []
for group in ('motion', 'native', 'target_write', 'motor', 'encoder_power', 'brake', 'pvt', 'stall'):
    cls, names = GROUPS[group]
    for original in names:
        method = standalone_method(cls, original)
        setattr(NoMasterSlaveTests, method.__name__, method)
        standalone_names.append(method.__name__)
GROUPS['no_sm'] = (NoMasterSlaveTests, tuple(standalone_names))


def make_suite(rig, groups, patterns=()):
    tests = []
    for group in groups:
        cls, names = GROUPS[group]
        for name in names:
            test = cls(name)
            if patterns and not any(pattern in test.id() for pattern in patterns): continue
            original = name.replace('test_no_sm_', 'test_', 1) if group == 'no_sm' else name
            test.motion_axes = {
                'test_physical_lo_both_directions': ('TR_LO',),
                'test_physical_hi_both_directions': ('TR_HI',),
                'test_repeated_motor_targets': ('TR_LO',),
                'test_motor_stop_during_move': ('TR_LO',),
                'test_center_both_directions': ('CENTERY',),
                'test_gap_both_directions': ('GAPY',),
                'test_real_encoder_sleep_wake_and_backup': ((rig.profile['encoder_power']['axis'],) if rig else ('TR_LO', 'TR_HI')),
            }.get(original, ('TR_LO',) if '_lo_' in name else ('TR_HI',) if '_hi_' in name else ())
            if group == 'concurrent': test.motion_axes = ('TR_LO', 'TR_HI')
            if group == 'command_burst': test.motion_axes = ('TR_LO', 'TR_HI', 'CENTERY', 'GAPY')
            if group == 'dmov': test.motion_axes = ('TR_LO', 'TR_HI', 'CENTERY')
            if group == 'homing': test.motion_axes = ('TR_HI',)
            if group == 'coupled_stop':
                test.motion_axes = ('CENTERY',) if original.startswith('test_center') else ('GAPY',)
            test.rig = rig
            tests.append(test)
    return unittest.TestSuite(tests)
