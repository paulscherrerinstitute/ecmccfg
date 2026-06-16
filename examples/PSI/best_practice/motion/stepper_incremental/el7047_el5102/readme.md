# Homing on index with EL7047 and EL5102

This example shows a simple closed-loop stepper setup with:
- EL7047 stepper drive
- EL5102 incremental encoder interface
- one external incremental encoder with index
- the EL7047 internal microstep counter as a secondary encoder

The primary encoder is the EL5102 incremental input.
The EL7047 open-loop counter is added as encoder 2 so it can be aligned to the external encoder at startup and after homing.

No extra PLC workaround is used in this example.
The old EL5102 re-arm PLC from the test area is intentionally not part of this best-practice configuration.

## Startup configuration

```cmd
require ecmccfg "ENG_MODE=1"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=3,HW_DESC=EL5102"
epicsEnvSet(ENC_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=2,HW_DESC=EL7047"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper, MACROS='I_MAX_MA=1000, I_STDBY_MA=200, U_NOM_MV=48000, R_COIL_MOHM=1230,L_COIL_UH=2000'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis.yaml, DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${ENC_SID}, ENC_CH=01"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_open_loop.yaml, DEV=${IOC}, DRV_SID=${DRV_SID}"
```

## Encoder roles

### Encoder 1: EL5102 incremental encoder

The EL5102 encoder is configured as the primary axis encoder in `cfg/axis.yaml`.
This is the encoder used for control and for index-based homing.

Important settings:
- `position: ec0.s$(ENC_SID).positionActual01`
- `control: ec0.s$(ENC_SID).encoderControl01`
- `status: ec0.s$(ENC_SID).encoderStatus01`
- `latch.position: ec0.s$(ENC_SID).encoderLatchPosition01`
- `latch.control: 0`
- `latch.status: 0`

That matches the EL5102 PDO layout in `ecmcEL5102.cmd`, where bit `0` in the control word arms the latch and bit `0` in the status word reports a new latched value.

### Encoder 2: EL7047 open-loop counter

The EL7047 internal microstep counter is loaded from `cfg/enc_open_loop.yaml`.
It is not the primary encoder. It is used as a secondary encoder that is referenced to encoder 1:
- at startup with `refToEncIDAtStartup: 1`
- after a successful homing cycle with `refAtHome: 1`

## Homing on index

This example uses homing sequence `11` (`ECMC_SEQ_HOME_LOW_LIM_INDEX`):
1. Move toward the backward limit.
2. Reverse direction.
3. Arm the EL5102 latch.
4. Home on the first encoder index after the limit transition.

If your mechanics are arranged the other way around, switch to sequence `12` and swap the search direction.

## Scaling used in the example

The example assumes:
- stage travel of `1 mm/rev`
- EL5102 encoder resolution of `4096 counts/mm`
- EL7047 internal counter resolution of `12800 microsteps/mm`

If your mechanics or encoder resolution differ, update the `numerator` and `denominator` values in both YAML files.

## Switch mapping

The limit switch inputs are mapped from the EL7047 drive status bits:
- forward limit: `driveStatus01.12`
- backward limit: `driveStatus01.11`

The `home` and `interlock` entries in `cfg/axis.yaml` are placeholders and should be replaced with the actual signals for the target installation.

## Related documentation

- [Hugo homing manual](../../../../../../hugo/content/manual/motion_cfg/homing.md)
- [Post move after homing](../../../../../../hugo/content/manual/motion_cfg/homing.md#post-move-after-homing)
- [EL7062/EX7062 CSP incremental best-practice example](../ex7062_CSP/readme.md)

The sequence descriptions for `ECMC_SEQ_HOME_LOW_LIM_INDEX = 11` and `ECMC_SEQ_HOME_HIGH_LIM_INDEX = 12` are in the same homing manual.
