+++
title = "Verify DC Timing with Position Compare"
weight = 19
chapter = false
+++

## Purpose

This example verifies a timestamp-scheduled output against a hardware
touch-probe latch. It is useful when checking whether Distributed Clock (DC)
timing, terminal phase, wiring and ecmc position-compare prediction are good
enough for position-triggered outputs.

The tested setup is:

```text
ecmc axis position compare
  -> EL2252 timestamp-scheduled output pulse
  -> EL7062/ED7062 touch-probe input
  -> encoder touch-probe latched position + timestamp
  -> optional PLC reconstruction check
```

The EL2252 proves the output timing. The EL7062/ED7062 touch probe proves when
the electrical edge arrived and what encoder position the terminal latched at
that edge.

## Hardware chain

Use one EL2252 output as the generated event and wire it to a touch-probe input
on the EL7062/ED7062. Make sure the input and output reference the same
electrical ground. An unstable or floating signal can look like random software
timing failures.

For the EL7062/ED7062 touch probe, select the encoder source used for the
latched position. For the primary/internal open-loop position, configure the
terminal touch-probe source with the relevant SDOs, for example:

```text
Cfg.EcAddSdo(<EL7062 slave>,0x8001,0x15,0,2)
Cfg.EcAddSdo(<EL7062 slave>,0x8101,0x15,0,2)
```

Use the matching channel objects for the channel under test. Channel 1 uses the
`...01` PDO entries and channel 2 uses the `...02` PDO entries.

## Axis YAML

Configure the encoder touch probe on the encoder that should receive the latch.
This is separate from the homing latch configuration.

```yaml
encoder:
  touchProbe:
    position: ec0.s$(ENC_SLAVE).touchProbePositionPos01_1
    timestamp: ec0.s$(ENC_SLAVE).touchProbeTimestampPos01_1
    control: ec0.s$(ENC_SLAVE).touchProbeControl01
    status: ec0.s$(ENC_SLAVE).touchProbeStatus01
    armCmd: 17
    armBits: 5
```

Configure the axis position compare to drive the EL2252. The EL2252 convention
tested with ecmc is `activateIdle: 3` and `activateSchedule: 0`.

```yaml
positionCompare:
  output: ec0.s$(OUT_SLAVE).binaryOutput01
  activate: ec0.s$(OUT_SLAVE).activate
  startTime: ec0.s$(OUT_SLAVE).startTime
  minLeadMs: 2.0
  maxLeadMs: 4.0
  activateIdle: 3
  activateSchedule: 0
  pulseWidthMs: 10.0
  resetValue: 0
```

At a 1 kHz EtherCAT cycle, the compare normally needs about two cycles of lead
time to predict the crossing, write the EL2252 PDOs, and return the activate
value to idle. A practical starting point is therefore `minLeadMs: 2.0` and
`maxLeadMs: 4.0`. Increase the window if events are reported as too close; keep
it short enough that position prediction error does not dominate.

## Runtime PVs and panels

If `positionCompare` is configured, ecmccfg loads axis PC PVs with names like:

```text
<Axis>-PC-HasPC
<Axis>-PC-State
<Axis>-PC-Reason
<Axis>-PC-Seq
<Axis>-PC-Target
<Axis>-PC-Pos
<Axis>-PC-Vel
<Axis>-PC-Acc
<Axis>-PC-ScheduledTimeNs
<Axis>-PC-LeadTimeNs
<Axis>-PC-ArmCmd
<Axis>-PC-CancelCmd
```

If `encoder.touchProbe` is configured, ecmccfg loads encoder TP PVs with names
like:

```text
<Axis>-Enc01-TP-HasTP
<Axis>-Enc01-TP-Valid
<Axis>-Enc01-TP-Seq
<Axis>-Enc01-TP-Pos
<Axis>-Enc01-TP-TimeRaw
<Axis>-Enc01-TP-EventTimeNs
<Axis>-Enc01-TP-ArmCmd
```

The matching caQtDM panels are `ecmcAxisPositionCompare.ui` and
`ecmcEncTouchProbe.ui`.

## Runtime commands

Arm the touch probe first:

```text
AxisTouchProbeArm(axis,encoder,1)
```

Then arm one position-compare output:

```text
AxisPositionCompareArm(axis,target,direction,outputValue)
```

`direction` is:

| Value | Meaning |
|---:|---|
| `1` | positive crossing |
| `-1` | negative crossing |
| `0` | either direction |

Inspect both sides:

```text
AxisPrintPositionCompare(axis)
AxisPrintTouchProbe(axis,encoder)
```

The position compare is one-shot. Rearm it for the next requested crossing.
The touch probe may also need rearming depending on terminal configuration and
test sequence.

## Optional PLC reconstruction check

The PLC file `touch-probe-position-reconstruction.plc` can be run as a GENERAL
PLC after the axis. It keeps recent normal encoder samples, interpolates the
encoder position at the hardware touch-probe timestamp, and compares that
estimate with the hardware-latched position.

Typical output:

```text
TP seq=  1 latched=5.00013 estimated=5.00012 error=-0.00001 timing_us=-0.57 velocity=10.05
```

This checks whether the touch-probe timestamp and latched position are coherent.
It does not directly report the position-compare output error.

## Interpreting the result

To estimate the position-compare output timing error from the touch-probe latch,
use:

```text
(latched_position - target_position) / velocity
```

A negative value means the output occurred before the axis reached the requested
target position. A positive value means the output occurred after the target.

The `timing_us` value printed by the PLC is different. It is the reconstruction
error between:

- the position latched by the touch-probe hardware, and
- the position reconstructed from ordinary encoder samples at the same
  touch-probe timestamp.

Use the PLC value to validate the touch-probe measurement. Use the
`(latched-target)/velocity` value to evaluate the position-compare output.

## Example findings

In one 1 kHz EL2252-to-EL7062/ED7062 test:

- a large maximum lead made the output error larger because the crossing was
  predicted too far in advance;
- `minLeadMs: 2.0` and `maxLeadMs: 4.0` gave about 13 to 18 microseconds error
  in constant-velocity crossings;
- the same setting gave about 20 microseconds error in acceleration and
  deceleration zones;
- adding many more EtherCAT slaves changed the measured acceleration/deceleration
  result slightly, but the result stayed repeatable rather than random;
- the hardware timestamp path itself was much tighter than the axis prediction
  error;
- a grounding problem originally caused intermittent missing or random-looking
  latch events.

Treat these numbers as one measured setup, not a specification.

## DC/SYNC shift and topology

The DC/SYNC shift of the output and touch-probe terminals changes where the
terminal event lands inside the EtherCAT cycle. Even when the timestamp math is
correct, the shift can affect margin and repeatability. In one EL7062 setup,
moving the DC shift into the approximately 200 us range improved stability.

Adding more EtherCAT slaves can also move host send/receive timing because the
frame length and topology change. A correctly accepted EL2252 DC event should
still execute at the queued DC `startTime`; that hardware event is not expected
to become random just because the frame is longer. What can change is the
software-side margin before the event is queued, and therefore the measured
position result. This is most visible in acceleration/deceleration regions,
where the target crossing depends on the assumed position, velocity and
acceleration at the scheduling cycle.

When results are unstable, check:

- common ground and signal integrity between EL2252 and EL7062/ED7062;
- `EcPrintSlaveConfig(slave)` for resolved endpoint timing;
- `EcPrintControlTiming(inputSlave,outputSlave)` for input/output timing
  relationship;
- the PC state/reason PVs for `TOO_CLOSE`, `TOO_FAR`, or `WAIT_DIRECTION`;
- whether the EL2252 `startTime` is linked through a 64-bit integer entry/PV.

## Related pages

- [EtherCAT Endpoint Timing]({{< relref "/manual/general_cfg/ethercat_timing.md" >}})
- [EL2252]({{< relref "/manual/knowledgebase/hardware/EL2252.md" >}})
- [EL7062]({{< relref "/manual/knowledgebase/hardware/EL7062.md" >}})
- [Axis YAML]({{< relref "/manual/motion_cfg/axisYaml.md" >}})
