"""Observe reduced-torque control bit 2; never write the drive control word."""
from .base import SlitCase


class TorqueTests(SlitCase):
    def reduced(self, axis):
        return bool(self.rig.drive_control(axis) & (1 << 2))

    def healthy(self):
        for axis in self.rig.profile['physical']:
            self.assertEqual(self.rig.get(axis, '-ErrId'), 0)

    def settled(self):
        def ready():
            self.healthy()
            return all(self.rig.get(axis, '-AtTarget') == 1 and self.reduced(axis)
                       for axis in self.rig.profile['physical'])
        self.rig.wait(ready, 'both blades at target with reduced torque', 5)

    def test_physical_motion_restores_full_torque_then_reduces(self):
        self.settled()
        for axis in self.rig.profile['physical']:
            self.rig.start_move(axis, .3)
            def moving():
                self.healthy()
                return self.rig.get(axis, '-Busy') == 1 and not self.reduced(axis)
            self.rig.wait(moving, axis + ' moving with reduced-torque bit cleared', 3)
            self.rig.wait(lambda: self.rig.get(axis, '-Busy') == 0
                          and abs(self.rig.get(axis, '-PosAct') - .3) < .015,
                          axis + ' reaches target', 5)
            self.settled()

    def test_coordinated_motion_restores_full_torque_then_reduces(self):
        self.settled()
        self.rig.start_move('CENTERY', .3)
        def moving():
            self.healthy()
            return (self.rig.get('CENTERY', '-Busy') == 1
                    and all(self.rig.get(axis, '-TrjSrcTyp-RB') == 1 and not self.reduced(axis)
                            for axis in self.rig.profile['physical']))
        self.rig.wait(moving, 'external slave trajectories move with full torque', 3)
        self.rig.wait(lambda: self.rig.get('CENTERY', '-Busy') == 0
                      and abs(self.rig.get('CENTERY', '-PosAct') - .3) < .02,
                      'coordinated move reaches target', 8)
        self.settled()

    def test_master_slave_control_deadband_has_independent_dwell(self):
        """Master AtTarget precedes its deliberately longer slave-control dwell."""
        self.settled()
        self.rig.start_move('CENTERY', -.3)
        self.rig.wait(lambda: self.rig.get('CENTERY', '-Busy') == 1
                      and all(not self.reduced(axis) for axis in self.rig.profile['physical']),
                      'coordinated motion restores full torque', 3)
        self.rig.wait(lambda: self.rig.get('CENTERY', '-AtTarget') == 1
                      and all(not self.reduced(axis) for axis in self.rig.profile['physical']),
                      'master AtTarget precedes slave-control deadband dwell', 8)
        # CA can publish the AtTarget edge late relative to the RT-cycle dwell,
        # so do not require a fixed wall-clock interval after this observation.
        # Seeing this state at all proves the two qualification bands differ;
        # settled() then proves the forwarded slave-control state eventually
        # enables reduced torque.
        self.settled()

    def test_encoder_disturbance_removes_reduced_torque_and_recovers(self):
        if self.loop != 'closed':
            self.skipTest('requires primary EL5042 feedback')
        self.settled()
        axis = 'TR_HI'
        self.rig.plant.inject(axis, encoder_noise_mm=.014)
        try:
            def disturbed():
                self.healthy()
                error = abs(self.rig.get(axis, '-PosAct') - self.rig.get(axis, '-PosSet'))
                return error > .011 and not self.reduced(axis) and self.rig.get(axis, '-AtTarget') == 0
            self.rig.wait(disturbed, 'encoder disturbance clears reduced-torque bit', 3)
        finally:
            self.rig.plant.inject(axis, encoder_noise_mm=0)
        self.settled()
