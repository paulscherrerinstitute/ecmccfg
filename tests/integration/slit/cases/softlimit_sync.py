"""Observe both sides of live motor/ECMC limit synchronization, allowing polls."""
from .base import SlitCase


class SoftLimitSyncTests(SlitCase):
    def original(self, axis):
        sync = int(self.rig.get(axis, '-CfgSyncSftLim'))
        self.assertGreater(self.rig.get(axis, '.MRES'), 0,
                           'these fixture tests require positive motor resolution')
        low, high = self.rig.get(axis, '.LLM'), self.rig.get(axis, '.HLM')
        # Require coherent original pairs before enabling sync so the test
        # does not silently overwrite a deliberately different motor limit.
        self.synchronized(axis, low, high)
        self.addCleanup(self.restore_sync, axis, sync)
        self.rig.put(axis, '-CfgSyncSftLim', 1)
        self.rig.wait(lambda: self.rig.get(axis, '-CfgSyncSftLim') == 1,
                      axis + ' soft-limit sync enabled for test', 5)
        flags = tuple(int(self.rig.get(axis, suffix)) for suffix in ('-SftLimBwdEna-RB', '-SftLimFwdEna-RB'))
        self.assertEqual(flags, (1, 1), 'dedicated physical-axis limits must initially be enabled')
        return low, high, flags

    def restore_sync(self, axis, enabled):
        self.rig.put(axis, '-CfgSyncSftLim', enabled)
        self.rig.wait(lambda: self.rig.get(axis, '-CfgSyncSftLim') == enabled,
                      axis + ' original soft-limit sync setting restored', 5)

    def synchronized(self, axis, low, high):
        def matches():
            self.assertEqual(self.rig.get(axis, '-ErrId'), 0)
            return all(abs(self.rig.get(axis, suffix) - value) < 1e-6 for suffix, value in (
                ('.LLM', low), ('.DLLM', low), ('-CfgDLLM-RB', low),
                ('.HLM', high), ('.DHLM', high), ('-CfgDHLM-RB', high)))
        self.rig.wait(matches, axis + ' motor/dial/ECMC soft-limit values synchronize', 5)

    def restore(self, axis, original):
        low, high, flags = original
        self.rig.put(axis, '-CfgDLLM', low)
        self.rig.put(axis, '-CfgDHLM', high)
        self.rig.put(axis, '-CfgDLLM-En', flags[0])
        self.rig.put(axis, '-CfgDHLM-En', flags[1])
        self.synchronized(axis, low, high)
        self.flags_match(axis, *flags)

    def flags_match(self, axis, low, high):
        self.rig.wait(lambda: all(self.rig.get(axis, suffix) == value for suffix, value in (
            ('-SftLimBwdEna-RB', low), ('-CfgDLLM-En-RB', low),
            ('-SftLimFwdEna-RB', high), ('-CfgDHLM-En-RB', high))),
            axis + ' native and motor-driver limit enable flags synchronize', 5)

    def test_motor_limit_changes_reach_ecmc(self):
        for axis in self.rig.profile['physical']:
            original = self.original(axis)
            try:
                self.rig.put(axis, '.LLM', -.45)
                self.rig.put(axis, '.HLM', .55)
                self.synchronized(axis, -.45, .55)
                self.flags_match(axis, 1, 1)
                # Limit synchronization is under test, not following-error
                # performance. Leave margin for the externally sampled plant
                # when Channel Access briefly stalls under a full-suite run.
                self.rig.native_move(axis, .2, velocity=.2)
                self.rig.native_move(axis, 0, velocity=.2)
            finally:
                self.restore(axis, original)

    def test_ecmc_config_limit_changes_reach_motor(self):
        # CfgDLLM/DHLM configure the ECMC monitor through the motor driver's
        # existing config interface; poll readbacks must update motor limits.
        for axis in self.rig.profile['physical']:
            original = self.original(axis)
            velocity = self.rig.get(axis, '.VELO')
            try:
                # This test verifies limit propagation, not maximum tracking
                # speed. A slower motor move tolerates occasional CA plant
                # stalls without weakening ECMC's following-error monitor.
                self.rig.put(axis, '.VELO', .2)
                self.rig.put(axis, '-CfgDLLM', -.35)
                self.rig.put(axis, '-CfgDHLM', .45)
                self.synchronized(axis, -.35, .45)
                self.flags_match(axis, 1, 1)
                self.rig.move(axis, -.2)
                self.rig.move(axis, 0)
            finally:
                self.rig.put(axis, '.VELO', velocity)
                self.restore(axis, original)

    def test_soft_limit_enable_flags_sync_both_interfaces(self):
        for axis in self.rig.profile['physical']:
            original = self.original(axis)
            try:
                for direction, native, config in ((0, '-SftLimBwdEna', '-CfgDLLM-En'),
                                                  (1, '-SftLimFwdEna', '-CfgDHLM-En')):
                    for source in (native, config):
                        for enabled in (0, 1):
                            self.rig.put(axis, source, enabled)
                            flags = [1, 1]
                            flags[direction] = enabled
                            self.flags_match(axis, *flags)
                            # Keep the other direction enabled; never test an
                            # unbounded move with both controller limits off.
                            self.synchronized(axis, original[0], original[1])
            finally:
                self.restore(axis, original)
