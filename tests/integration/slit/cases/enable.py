from .base import SlitCase, DRIVE_ENABLE_FAILURE_WAIT


class EnableTests(SlitCase):
    def test_missing_enable_acknowledgement(self):
        axis = 'TR_LO'
        self.assertEqual(self.rig.stop_all(), [], 'disable before missing-enable injection')
        self.rig.wait_drive_disabled(axis)
        self.rig.plant.inject(axis, acknowledge_enable=False)
        try:
            self.rig.put(axis, '-EnaCmd', 1)
        except RuntimeError:
            pass  # A synchronous enable timeout may also surface as a failed put.
        self.rig.fault_stopped(axis, 0x14613, timeout=DRIVE_ENABLE_FAILURE_WAIT)

    def test_lost_enable_during_motion(self):
        axis = 'TR_LO'
        self.rig.start_move(axis, .7)
        self.rig.wait(lambda: self.rig.get(axis, '-PosAct') > .06, 'motion before enable loss', 4)
        self.rig.plant.inject(axis, acknowledge_enable=False)
        self.rig.fault_stopped(axis, 0x14317)  # ERROR_AXIS_AMPLIFIER_ENABLED_LOST
        self.assertLess(self.rig.get(axis, '-PosAct'), .65)

    def test_drive_fault(self):
        axis = 'TR_HI'
        self.rig.start_move(axis, .7)
        self.rig.wait(lambda: self.rig.get(axis, '-PosAct') > .06, 'motion before drive fault', 4)
        self.rig.plant.inject(axis, drive_fault=True)
        self.rig.wait(lambda: self.rig.drive_status(axis) & 8, 'injected drive fault bit published', 3)
        self.rig.fault_stopped(axis, 0x1460E)  # ERROR_DRV_HW_ALARM_0: linked status bit 3.

    def test_disable_on_reset_enabled_and_disabled(self):
        axis = 'TR_LO'
        number = self.rig.profile['axes'][axis]
        state_machine = self.rig.client.get(self.rig.prefix + 'SM00-EnaCmd')
        self.addCleanup(self.rig.client.put,
                        self.rig.prefix + 'SM00-EnaCmd', state_machine)
        self.assertEqual(self.rig.stop_all(), [])
        self.rig.client.put(self.rig.prefix + 'SM00-EnaCmd', 0)
        self.rig.wait(lambda: self.rig.client.get(self.rig.prefix + 'SM00-EnaCmd') == 0
                      and all(self.rig.get(name, '-TrjSrcTyp-RB') == 0
                              for name in self.rig.profile['physical']),
                      'independent physical axes before reset-policy test', 5)
        transport = self.rig.open_text_commands()
        self.addCleanup(self.rig.close_text_commands, transport)
        self.addCleanup(self.rig.text_command,
                        f'Cfg.SetAxisDisableAtErrorReset({number},0)')

        monitor = ('MonMaxVel', 'MonEnableMaxVel',
                   'MonMaxVelTrajILDelay', 'MonMaxVelDriveILDelay')
        saved = {key: self.rig.text_command(
            f'GetAxis{key}({number})', query=True) for key in monitor}
        def restore_monitor():
            for key in reversed(monitor):
                self.rig.text_command(
                    f'Cfg.SetAxis{key}({number},{saved[key]:.12g})')
        self.addCleanup(restore_monitor)
        for key, value in (('MonMaxVel', .01), ('MonEnableMaxVel', 1),
                           ('MonMaxVelTrajILDelay', 10),
                           ('MonMaxVelDriveILDelay', 999)):
            self.rig.text_command(f'Cfg.SetAxis{key}({number},{value})')

        for disable, expected_enabled in ((0, 1), (1, 0)):
            with self.subTest(disableOnReset=bool(disable)):
                self.rig.text_command(
                    f'Cfg.SetAxisDisableAtErrorReset({number},{disable})')
                self.rig.put(axis, '-EnaCmd', 1)
                self.rig.wait(lambda: self.rig.get(axis, '-EnaAct') == 1,
                              'axis enabled before reset-policy fault', 5)
                self.rig.stage_native(axis, 3, .4, .2)
                self.rig.execute_native(axis)
                self.rig.wait(lambda: self.rig.get(axis, '-ErrId') == 0x14c07
                              and self.rig.get(axis, '-EnaAct') == 1
                              and self.rig.get(axis, '-EnaCmd-RB') == 1,
                              'trajectory interlock faults before drive-disable delay', 3)
                self.rig.put(axis, '-RstCmd', 1)
                self.rig.wait(lambda: self.rig.get(axis, '-ErrId') == 0
                              and self.rig.get(axis, '-EnaAct') == expected_enabled
                              and self.rig.get(axis, '-EnaCmd-RB') == expected_enabled,
                              'reset policy leaves axis '
                              + ('enabled' if expected_enabled else 'disabled'), 6)
                self.rig.put(axis, '-ExeCmd', 0)
