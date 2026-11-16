"""Real IOC configuration checks; never request motion or widen travel limits."""
import unittest
from slit.limit_modes import LimitModeChecks


class SoftLimitModeTests(LimitModeChecks, unittest.TestCase):
    pass


SOFT_LIMIT_NAMES = (
    'test_motor_only_limits_without_sync',
    'test_controller_only_limits_without_sync',
    'test_nested_independent_limits_without_sync',
    'test_native_limits_bound_unsynced_motor_limits',
    'test_motor_soft_limit_callback_rate_is_bounded',
    'test_synced_limits_in_both_directions',
    'test_offsets_and_direction_preserve_dial_and_native_limits',
    'test_user_limit_edits_with_offsets_and_sync',
)
