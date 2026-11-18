"""Native monitor settings and bounded fault/disable/recovery experiments."""
import time

from .settings import SettingsCase


class MonitoringTests(SettingsCase):
    def test_monitor_parameter_readback(self):
        values = {'MonMaxVel': .3, 'MonEnableMaxVel': 1,
                  'MonMaxVelTrajILDelay': 100, 'MonMaxVelDriveILDelay': 200,
                  'MonAtTargetTol': .005, 'MonAtTargetTime': 200, 'MonEnableAtTargetMon': 1,
                  'MonPosLagTol': .015, 'MonPosLagTime': 100, 'MonEnableLagMon': 1,
                  'MonVelDiffTol': .1, 'MonEnableVelocityDiff': 1,
                  'MonVelDiffTrajILDelay': 30, 'MonVelDiffDriveILDelay': 50}
        for key, value in values.items():
            with self.subTest(setting=key): self.config(key, value)

    def recover(self, code):
        self.allowed[self.axis] = (code,)
        self.rig.fault_stopped(self.axis, code)
        self.rig.plant.clear_faults()
        self.rig.put(self.axis, '-RstCmd', 1)
        self.rig.wait(lambda: self.rig.get(self.axis, '-ErrId') == 0,
                      'native monitor reset', 5)
        self.allowed.clear()
        position = self.rig.plant.physical_position(self.axis)
        self.rig.assert_stays(lambda: self.healthy() and self.rig.get(self.axis, '-Busy') == 0
                              and self.rig.get(self.axis, '-EnaAct') == 0
                              and abs(self.rig.plant.physical_position(self.axis)-position) < .005,
                              'monitor reset must not replay the interrupted move', .3)

    def test_max_velocity_trip_disable_and_fresh_command(self):
        self.config('MonMaxVel', .12)
        self.config('MonEnableMaxVel', 1)
        self.config('MonMaxVelTrajILDelay', 30)
        self.config('MonMaxVelDriveILDelay', 50)
        self.rig.native_move(self.axis, .04, velocity=.08)
        self.rig.stage_native(self.axis, 3, .5, .3)
        self.rig.execute_native(self.axis)
        self.recover(0x14c07)
        self.assertLess(self.rig.plant.physical_position(self.axis), .4)
        self.config('MonEnableMaxVel', 0)
        self.rig.native_move(self.axis, -.1, velocity=.3)
        self.healthy()
        self.config('MonEnableMaxVel', 1)
        self.config('MonMaxVel', .4)
        self.rig.native_move(self.axis, 0, velocity=.3)

    def test_position_lag_trip_and_recovery(self):
        self.closed()
        self.controller()
        self.config('MonPosLagTol', .006)
        self.config('MonPosLagTime', 600)
        self.config('MonEnableLagMon', 1)
        self.enable()
        self.rig.plant.inject(self.axis, encoder_bias_mm=.012)
        self.rig.assert_stays(lambda: self.healthy() and self.rig.get(self.axis, '-ErrId') == 0,
                              'short lag excursion stays below configured lag time', .2)
        self.rig.plant.inject(self.axis, encoder_bias_mm=0)
        self.rig.assert_stays(lambda: self.healthy() and self.rig.get(self.axis, '-ErrId') == 0,
                              'clearing lag resets its qualification timer', .15)
        self.rig.plant.inject(self.axis, encoder_bias_mm=.012)
        self.recover(0x14c08)
        self.controller(kp=2, kff=1)
        self.rig.native_move(self.axis, .1, velocity=.1)

    def test_velocity_difference_detects_frozen_feedback(self):
        self.closed()
        self.config('MonPosLagTol', .6)
        self.config('MonEnableVelocityDiff', 1)
        self.config('MonVelDiffTol', .08)
        # Long enough to tolerate the intentionally sampled CA plant while
        # still tripping well before the end of the bounded test move.
        # MCU-Cmd.AOUT is limited to 39 bytes: the trajectory setter fits a
        # three-digit value, while the longer drive setter fits two digits.
        self.config('MonVelDiffTrajILDelay', 600)
        self.config('MonVelDiffDriveILDelay', 99)
        self.rig.stage_native(self.axis, 3, .5, .15)
        self.rig.execute_native(self.axis)
        self.rig.wait(lambda: self.rig.get(self.axis, '-PosAct') > .03,
                      'measured motion before freezing feedback', 3)
        self.rig.plant.inject(self.axis, frozen=True)
        self.rig.assert_stays(lambda: self.healthy() and self.rig.get(self.axis, '-ErrId') == 0,
                              'short velocity difference stays below drive delay', .025)
        self.rig.plant.inject(self.axis, frozen=False)
        self.rig.assert_stays(lambda: self.healthy() and self.rig.get(self.axis, '-ErrId') == 0,
                              'clearing velocity difference resets its shared timer', .15)
        self.rig.plant.inject(self.axis, frozen=True)
        self.recover(0x14c14)
        self.config('MonEnableVelocityDiff', 0)
        self.rig.native_move(self.axis, 0, velocity=.1)

    def test_at_target_requires_tolerance_and_dwell(self):
        self.closed()
        self.controller()
        self.config('MonAtTargetTol', .006)
        self.config('MonAtTargetTime', 600)
        self.config('MonEnableAtTargetMon', 1)
        self.enable()
        self.rig.plant.inject(self.axis, encoder_bias_mm=.012)
        self.rig.wait(lambda: self.healthy() and self.rig.get(self.axis, '-AtTarget') == 0,
                      'outside tolerance clears at-target', 2)
        self.rig.plant.inject(self.axis, encoder_bias_mm=.003)
        self.rig.assert_stays(lambda: self.healthy() and self.rig.get(self.axis, '-AtTarget') == 0,
                              'within tolerance must complete a dwell before at-target', .2)
        self.rig.wait(lambda: self.healthy() and self.rig.get(self.axis, '-AtTarget') == 1,
                      'settled feedback sets at-target after dwell', 3)

    def test_auto_disable_at_target_latch(self):
        self.closed()
        self.controller(kp=2, kff=1)
        timeout = 1.5
        normal_tolerance = .006
        self.config('AutoDisableAfterTime', timeout)
        self.config('MonEnableAtTargetMon', 1)
        self.config('MonAtTargetTime', 10)

        def establish_at_target(target):
            self.config('MonAtTargetTol', normal_tolerance)
            self.rig.move(self.axis, target)
            self.rig.wait(lambda: self.healthy()
                          and self.rig.get(self.axis, '-AtTarget') == 1
                          and self.rig.get(self.axis, '-EnaAct') == 1,
                          'enabled axis reaches AtTarget before testing auto-disable latch', 3)

        # Without the latch, losing AtTarget must cancel/reset auto-disable
        # timing. Keep the loss longer than the configured timeout.
        self.config('AutoDisableAtTgtLtch', 0)
        establish_at_target(.04)
        self.config('MonAtTargetTol', 1e-9)
        self.rig.wait(lambda: self.healthy() and self.rig.get(self.axis, '-AtTarget') == 0,
                      'tight tolerance clears AtTarget with latch disabled', 2)
        self.rig.assert_stays(lambda: self.healthy()
                              and self.rig.get(self.axis, '-AtTarget') == 0
                              and self.rig.get(self.axis, '-EnaAct') == 1,
                              'lost AtTarget cancels auto-disable timing without latch', timeout + .4)

        # Restore AtTarget and let the ordinary timer disable the axis. This
        # proves auto-disable itself is active before testing latched behavior.
        self.config('MonAtTargetTol', normal_tolerance)
        self.rig.wait(lambda: self.healthy() and self.rig.get(self.axis, '-AtTarget') == 1,
                      'AtTarget recovers before ordinary auto-disable', 2)
        self.rig.wait(lambda: self.healthy() and self.rig.get(self.axis, '-EnaAct') == 0,
                      'continuous AtTarget auto-disables the axis', timeout + 2)

        # New motion resets the previous latch. With latching enabled, the
        # timer starts at the first AtTarget edge and must continue after loss.
        self.config('AutoDisableAtTgtLtch', 1)
        # Keep the target between EL5042 encoder counts so tightening the
        # tolerance deterministically removes AtTarget in the SIM plant.
        establish_at_target(.02)
        edge_time = time.monotonic()
        self.config('MonAtTargetTol', 1e-9)
        self.rig.wait(lambda: self.healthy() and self.rig.get(self.axis, '-AtTarget') == 0,
                      'tight tolerance clears AtTarget with latch enabled', 2)
        self.rig.wait(lambda: self.healthy()
                      and self.rig.get(self.axis, '-AtTarget') == 0
                      and self.rig.get(self.axis, '-EnaAct') == 0,
                      'latched first AtTarget edge completes auto-disable after later loss', timeout + 2)
        self.assertLess(time.monotonic() - edge_time, timeout + 1,
                        'latched auto-disable restarted its timer after AtTarget was lost')
