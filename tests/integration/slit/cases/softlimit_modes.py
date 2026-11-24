"""Live SIM IOC limit modes and OFF/DIR tests, with stationary disabled axes."""
from .base import SlitCase
from ..limit_modes import LimitModeChecks


class SoftLimitModeTests(LimitModeChecks, SlitCase):
    def test_motor_record_plc_variables(self):
        def readback(axis):
            prefix = f'{self.rig.prefix}SIM:SlitTest:{axis}:'
            return (self.rig.client.get(prefix + 'Off'),
                    self.rig.client.get(prefix + 'Dir'),
                    self.rig.client.get(prefix + 'Loaded'))

        def fields(axis):
            return self.rig.get(axis, '.OFF'), self.rig.get(axis, '.DIR')

        axes = self.rig.profile['physical']
        for axis in axes:
            other = next(name for name in axes if name != axis)
            original = fields(axis)
            with self.limit_session(axis) as session:
                other_original = fields(other)
                for offset, direction in ((1.25, 1), (-2.375, 0)):
                    session.write('.DIR', direction)
                    session.write('.OFF', offset)
                    expected = (offset, direction)
                    session.wait(lambda: fields(axis) == expected
                                 and readback(axis) == (*expected, 1)
                                 and readback(other) == (*other_original, 1)
                                 and readback('Probe') == (0, 0, 0),
                                 f'{axis} PLC reads OFF={offset} and DIR={direction}')
            self.rig.wait(lambda: readback(axis) == (*original, 1),
                          f'{axis} PLC reads restored motor record values', 5)
