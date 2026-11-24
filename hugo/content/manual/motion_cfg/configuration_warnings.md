+++
title = "Configuration warnings"
weight = 22
chapter = false
+++

## Configuration Warnings

When an axis is validated before runtime, ecmc can write warnings to the
configuration log buffer. These warnings are intended to catch configurations
that are legal but likely to behave badly. They do not block startup by
themselves, but they should be reviewed before the IOC is put into service.

Examples include:

- enabled monitors with a zero limit or tolerance, such as at-target,
  position-lag, max-velocity, velocity-difference, or controller-output
  monitoring
- controller `Kp` equal to zero when the ecmc position controller is used
- controller settings configured in pure CSP, where the drive closes the
  position loop and ecmc controller parameters are not used
- controller deadband larger than the at-target tolerance
- requested target, maximum, or homing velocities that exceed the integer CSV
  velocity-setpoint range after scaling

For CSV axes with an integer velocity setpoint, a small at-target tolerance
combined with a low `Kp` can also cause a warning. Close to the target, the
position controller output is converted to the drive velocity setpoint. If
`Kp * monitoring.target.tolerance * abs(drive.denominator / drive.numerator)`
is below about `0.5` raw counts, the velocity setpoint may round to zero. The
axis can then stop near the target because the remaining error no longer
produces an effective velocity command. If stall monitoring is enabled, this
can also result in `ERROR_MON_STALL`.

Mitigate this by increasing `monitoring.target.tolerance`, increasing the
active `Kp`, or using suitable inner controller parameters for final
positioning. This specific rounding warning applies to CSV axes with integer
velocity setpoints. See also [tuning]({{< relref "/manual/knowledgebase/tuning.md#axis-stops-close-to-target" >}})
and [RT logger diagnostics]({{< relref "/manual/general_cfg/utilities/rt_logger_diagnostics.md" >}}).
