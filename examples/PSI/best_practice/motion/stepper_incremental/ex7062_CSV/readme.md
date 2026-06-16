# Homing on index with EX7062/ED7062 in CSV

This example shows a closed-loop stepper setup using the secondary incremental
encoder of an EX7062/ED7062 channel while the drive itself runs in CSV mode.

The example uses:

- `ED7062` as the hardware description in `startup_ED7062_chx.cmd`
- the common `EX7062` CSV PDO layout through `hardware/Beckhoff_7XXX/EL/ecmcEX7062.cmd`
- one selected drive channel, configured by `CH_USED`
- the secondary incremental encoder of the selected channel
- touch probe 1 triggered by encoder index
- homing sequence `11` (`ECMC_SEQ_HOME_LOW_LIM_INDEX`)

## Startup configuration

The startup file selects one channel, loads the drive and encoder components,
marks the unused channel as not used, and then loads the axis and extra encoder
YAML files.

Important macros:

- `CH_USED`: selected motor/encoder channel, normally `01` or `02`
- `CH_NOT_USED`: the other channel, disabled with `Generic-Ch-Not-Used`
- `TP1_POS_SRC=SEC`: use the secondary incremental encoder as touch probe 1 source
- `TP1_TRG=INDEX`: trigger touch probe 1 on the encoder index pulse

## Encoder roles

### Encoder 1: secondary incremental encoder

The primary axis encoder is defined in `cfg/axis_chx.yaml` and uses the
secondary incremental encoder PDOs of the selected channel:

- `positionActual${ENC_CH}_2`
- `touchProbeStatus${ENC_CH}`
- `touchProbeControl${ENC_CH}`
- `touchProbePositionPos${ENC_CH}_1`

This encoder is used for closed-loop position control and index-based homing.
The latch settings match the EX7062/ED7062 touch-probe layout:

```yaml
latch:
  position: ec0.s$(ENC_SID).touchProbePositionPos$(ENC_CH=01)_1
  control: 0
  status: 1
  armCmd: 21
  armBits: 5
```

`armCmd: 21` is `0b10101`. It enables touch probe 1, selects the trigger mode,
and arms positive-edge latching.

### Encoder 2: open-loop drive counter

The drive's open-loop counter is loaded from `cfg/enc_openloop.yaml`. It is not
the primary control encoder. It is referenced to encoder 1 at startup and after
homing:

- `refToEncIDAtStartup: 1`
- `refAtHome: 1`

## Homing on index

This example uses homing sequence `11`
(`ECMC_SEQ_HOME_LOW_LIM_INDEX`). The axis moves toward the backward limit,
reverses direction, arms the touch probe, and references on the first encoder
index after the limit transition.

Use sequence `12` (`ECMC_SEQ_HOME_HIGH_LIM_INDEX`) if the mechanics should
search from the opposite direction.

## Scaling used in the example

The example assumes:

- `360` engineering units per revolution
- `1048576` counts per revolution for the incremental encoder
- CSV drive scaling from `2880000 / 2147483648`

Adjust `drive.numerator`, `drive.denominator`, `encoder.numerator`, and
`encoder.denominator` in `cfg/axis_chx.yaml` if the motor, encoder, or required
engineering units differ.

## Soft limits

`cfg/axis_chx.yaml` enables ecmc soft limits and synchronizes them with the
motor record:

```yaml
epics:
  motorRecord:
      syncSoftLimits: true

softlimits:
  enable: true
  forward: 10000
  forwardEnable: true
  backward: -10000
  backwardEnable: true
```

With synchronized soft limits, the ecmc and motor-record limits are kept equal.
For the general soft-limit behavior, see
`hugo/content/manual/motion_cfg/axisYaml.md`.

## Related documentation

- `hugo/content/manual/motion_cfg/homing.md`
- `hugo/content/manual/motion_cfg/axisYaml.md`
- `hugo/content/manual/knowledgebase/hardware/EL7062.md`
- `examples/PSI/best_practice/motion/stepper_incremental/ex7062_CSP/`
