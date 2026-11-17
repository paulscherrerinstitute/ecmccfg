"""Reproducible conflicting motor targets and STOPs, followed by recovery."""
import random
import time
import unittest

from slit_recovery import wait_checked, motor_idle, stationary_dwell, reset_known_errors


class CommandBurstTests(unittest.TestCase):
    def test_all_axes_command_burst_recovers(self):
        rig = self.rig
        axes = tuple(rig.profile['axes'])
        self.assertEqual(rig.client.get(rig.prefix+'SM00-EnaCmd'), 1)
        # Conflicting requests may latch ERROR_AXIS_BUSY at controller level;
        # reset_known_errors() below clears it through MCU-ErrRst and verifies
        # that every axis and the controller return to zero. Hardware, encoder
        # and bus faults must fail before reset, never become an allowlist.
        allowed = {a: (0x1431c, 0x1432b, 0x1432e, 0x14331) for a in axes}
        previous = rig.motion_expectation
        rig.touched.update(axes)
        try:
            for axis in axes:
                if axis not in rig.saved_velocity:
                    rig.saved_velocity[axis] = rig.get(axis, '.VELO')
                rig.put(axis, '.VELO', rig.profile['velocity'])
            for seed in (17, 43, 101):
                rng = random.Random(seed)
                # Prove movement before injecting conflicts; do not count a
                # burst of rejected requests on an already-faulted rig as motion.
                master = 'CENTERY'
                target = rig.get(master, '-PosAct')+rig.profile['step']/4
                rig.validate_target(master, target)
                rig.start(master, target)
                rig.motion_expectation = None
                wait_checked(rig, lambda: any(abs(rig.get(a, '-VelAct')) > .005
                             for a in rig.profile['physical']), 'motion before burst', 10)
                started = time.monotonic()
                for index in range(40):
                    axis = axes[index % len(axes)] if index < len(axes) else rng.choice(axes)
                    field = '.VAL' if index < len(axes) or rng.random() < .75 else rng.choice(('.STOP', '-StpCmd'))
                    value = 1
                    if field == '.VAL':
                        target = rig.origins[axis]+rng.choice((-1, 1))*rig.profile['step']/4
                        rig.validate_target(axis, target)
                        value = rig.user_position(axis, target)
                    rig.trace.append({'action': 'command burst', 'seed': seed, 'index': index,
                                      'elapsed': time.monotonic()-started, 'axis': axis,
                                      'field': field, 'value': value})
                    rig.client.put(rig.prefix+axis+field, value, wait=False, notify=False)
                    wait_checked(rig, lambda: True, 'burst health and envelope', 5, allowed)
                    time.sleep(rng.choice((0, .01, .03)))
                for axis in axes:
                    rig.client.put(rig.prefix+axis+'.STOP', 1, wait=False, notify=False)
                wait_checked(rig, lambda: motor_idle(rig, axes),
                             'all motor records terminate after burst', rig.profile['timeout'], allowed)
                rig.trace.append({'action': 'burst before reset', 'seed': seed, 'snapshot': rig.snapshot()})
                positions = {a: rig.get(a, '-PosAct') for a in rig.profile['physical']}
                stationary_dwell(rig, positions, allowed)
                reset_known_errors(rig, allowed)
                # Clearing the controller latch can release a motor-record
                # retry that was pending while the controller was faulted.
                # Cancel it explicitly before requiring stable standstill.
                for axis in axes:
                    rig.client.put(rig.prefix+axis+'.STOP', 1, wait=False, notify=False)
                wait_checked(rig, lambda: motor_idle(rig, axes),
                             'all motor records terminate after error reset',
                             rig.profile['timeout'])
                stationary_dwell(rig, positions)
                for axis in axes:
                    origin = rig.get(axis, '-PosAct')
                    rig.move(axis, origin+rig.profile['step']/10)
                    rig.move(axis, origin)
                rig.motion_expectation = None
                rig.trace.append({'action': 'burst fresh moves completed', 'seed': seed})
        except Exception:
            rig.trace.append({'action': 'burst failure before cleanup', 'snapshot': rig.snapshot()})
            raise
        finally:
            rig.motion_expectation = previous
