"""Mechanical lost motion on HI, with independent internal and EL5042 feedback."""
from .base import SlitCase
from slit_recovery import wait_checked, motor_idle, stationary_dwell, reset_known_errors, slave_fault_errors


class BacklashTests(SlitCase):
    axis = 'TR_HI'

    def configure_lag_monitor(self, tolerance):
        """Temporarily select the lag threshold required by a fault case."""
        transport = self.rig.open_text_commands()
        self.addCleanup(self.rig.close_text_commands, transport)
        number = self.rig.profile['axes'][self.axis]
        command = self.rig.text_command
        saved = command(f'GetAxisMonPosLagTol({number})', query=True)
        self.addCleanup(command, f'Cfg.SetAxisMonPosLagTol({number},{saved:.12g})')
        command(f'Cfg.SetAxisMonPosLagTol({number},{tolerance:.12g})')
        actual = command(f'GetAxisMonPosLagTol({number})', query=True)
        self.assertAlmostEqual(actual, tolerance, delta=1e-7)

    def enable_backlash(self, width):
        def restore():
            errors = self.rig.stop_all()
            if errors: raise RuntimeError('stop before removing backlash: '+str(errors))
            self.rig.plant.configure_backlash(self.axis, 0)
        self.addCleanup(restore)
        self.rig.plant.configure_backlash(self.axis, width)

    def assert_terminal(self, axis):
        self.rig.wait(lambda: motor_idle(self.rig, (axis,)), 'backlash move clears motor/native processing', 5)
        self.assertEqual(self.rig.get(axis, '-ErrId'), 0)
        self.assertEqual(self.rig.get(axis, '.SEVR'), 0)

    def test_physical_reversals_with_small_backlash(self):
        self.configure_lag_monitor(.04)
        self.enable_backlash(.024)
        for target in (.2, -.2, .2, 0):
            self.rig.move(self.axis, target)
            self.assert_terminal(self.axis)
            actual = self.rig.plant.physical_position(self.axis)
            if self.loop == 'closed': self.assertAlmostEqual(actual, target, delta=.015)
            else: self.assertLessEqual(abs(actual-target), .013)
            self.rig.kinematics()
            self.rig.trace.append({'action': 'physical backlash step', 'loop': self.loop, 'target': target,
                                   'native': self.rig.get(self.axis, '-PosAct'), 'mechanical': actual,
                                   'backlash': self.rig.plant.backlash_state(self.axis)})
        state = self.rig.plant.backlash_state(self.axis)
        self.assertGreater(state['peak_gap_mm'], .006, 'mechanical backlash must actually be exercised')
        self.rig.trace.append({'action': 'physical backlash reversals completed', 'loop': self.loop, 'backlash': state})

    def test_virtual_center_and_gap_with_small_backlash(self):
        self.configure_lag_monitor(.04)
        self.enable_backlash(.024)
        for axis, target in (('CENTERY', .15), ('GAPY', .2), ('CENTERY', -.15), ('GAPY', 0), ('CENTERY', 0)):
            self.rig.move(axis, target)
            self.assert_terminal(axis)
            self.rig.kinematics()
            lo, hi = (self.rig.plant.physical_position(a) for a in ('TR_LO', 'TR_HI'))
            self.rig.trace.append({'action': 'virtual backlash step', 'loop': self.loop, 'axis': axis,
                                   'target': target, 'native_center': self.rig.get('CENTERY', '-PosAct'),
                                   'native_gap': self.rig.get('GAPY', '-PosAct'),
                                   'mechanical_center': (lo+hi)/2, 'mechanical_gap': hi-lo})
            if self.loop == 'closed':
                physical = (lo+hi)/2 if axis == 'CENTERY' else hi-lo
                self.assertAlmostEqual(physical, target, delta=.03)
        self.assertGreater(self.rig.plant.backlash_state(self.axis)['peak_gap_mm'], .006)
        self.rig.trace.append({'action': 'virtual backlash moves completed', 'loop': self.loop,
                              'backlash': self.rig.plant.backlash_state(self.axis)})

    def test_large_physical_backlash_alarms_or_exposes_open_loop_error(self):
        if self.loop == 'closed': self.configure_lag_monitor(.02)
        self.enable_backlash(.1)
        if self.loop == 'open':
            self.rig.move(self.axis, .25)
            self.assert_terminal(self.axis)
            self.assertGreater(abs(self.rig.plant.physical_position(self.axis)-.25), .03,
                               'open-loop counter must not be mistaken for mechanical feedback')
            self.rig.trace.append({'action': 'open-loop backlash remains mechanically unobserved by controller',
                                  'backlash': self.rig.plant.backlash_state(self.axis)})
            return
        complete = self.rig.start_move(self.axis, .4)
        # The enabled state machine propagates a slave fault to its virtual
        # masters even when this request moved only the physical axis.
        allowed = slave_fault_errors(self.rig, self.axis, 0x14c08)
        wait_checked(self.rig, lambda: self.rig.get(self.axis, '-ErrId') == 0x14c08
                     and motor_idle(self.rig, self.rig.names) and complete.is_set()
                     and int(self.rig.get(self.axis, '.MSTA')) & (1 << 9)
                     and self.rig.get(self.axis, '.SEVR') > 0,
                     'large mechanical backlash trips lag and completes motor record', 12, allowed)
        positions = {a: self.rig.get(a, '-PosAct') for a in self.rig.profile['physical']}
        stationary_dwell(self.rig, positions, allowed)
        self.rig.trace.append({'action': 'large physical backlash caused lag alarm',
                              'backlash': self.rig.plant.backlash_state(self.axis), 'snapshot': self.rig.snapshot()})
        self.recover_after_fault(allowed)

    def recover_after_fault(self, allowed):
        self.assertEqual(self.rig.stop_all(), [])
        self.rig.plant.configure_backlash(self.axis, 0)
        self.rig.plant.clear_faults()
        self.rig.wait(lambda: abs(self.rig.get(self.axis, '-PosAct')-self.rig.plant.physical_position(self.axis)) < .003,
                      'restored backlash-free feedback published', 3)
        reset_known_errors(self.rig, allowed)
        # Slave motion can change CENTERY feedback while its record target
        # stays at zero. Synchronize first so returning to zero is a new move.
        self.rig.sync_motor_record('CENTERY')
        self.rig.move('CENTERY', 0)
        # A coordinated fault can leave GAPY.VAL at zero while feedback is
        # outside its deadband. Use an unambiguously new request before zero.
        self.rig.move('GAPY', .1)
        self.rig.move('GAPY', 0)
        self.rig.move(self.axis, .1)
        self.rig.move(self.axis, 0)

    def test_large_slave_backlash_stops_virtual_group(self):
        if self.loop != 'closed': self.skipTest('requires external primary encoder to detect lost motion')
        self.configure_lag_monitor(.02)
        self.enable_backlash(.1)
        complete = self.rig.start_move('CENTERY', .4)
        allowed = slave_fault_errors(self.rig, self.axis, 0x14c08)
        wait_checked(self.rig, lambda: self.rig.get(self.axis, '-ErrId') == 0x14c08
                     and motor_idle(self.rig, self.rig.names) and complete.is_set(),
                     'backlash in one slave stops virtual group without stuck records', 12, allowed)
        self.assertGreater(abs(self.rig.get('CENTERY', '-PosAct')-.4), .015)
        self.rig.trace.append({'action': 'large slave backlash stopped virtual group',
                              'backlash': self.rig.plant.backlash_state(self.axis), 'snapshot': self.rig.snapshot()})
        self.recover_after_fault(allowed)
