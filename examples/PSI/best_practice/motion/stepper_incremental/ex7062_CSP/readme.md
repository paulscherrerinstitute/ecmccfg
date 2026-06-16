# Homing on index with EL7062/EX7062 in CSP

The EL7062/EX7062 family works differently from EL51xx for index-based homing.
For these drives, the touch probe objects must be configured and used as the
latch source.

This example uses:
- EL7062 in CSP mode
- drive channel 1
- the secondary incremental encoder of that channel
- touch probe 1 triggered by encoder index
- homing sequence `12` (`ECMC_SEQ_HOME_HIGH_LIM_INDEX`)

## Startup configuration

The startup file configures the EL7062 and enables touch probe index latching through `Encoder-Generic-INC`:

```bash
require ecmccfg "ENG_MODE=1"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "SLAVE_ID=3,HW_DESC=EL7062_CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000,L_COIL_UH=3050,R_COIL_MOHM=2630'"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Drive-Generic-Ctrl-Params, CH_ID=1, MACROS='I_TI=12,I_KP=58,V_TI=150,V_KP=176,P_KP=10'"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC, CH_ID=1, MACROS='ST_ENC_RES=4000,TP1_POS_SRC=SEC,TP1_TRG=INDEX'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd, "FILE=./cfg/axis.yaml, DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,  "FILE=./cfg/enc_inc.yaml, DEV=${IOC}, ENC_SID=${DRV_SID}, ENC_CH=01"
```

Important macros:
- `TP1_POS_SRC=SEC`: use the secondary encoder as touch probe 1 source
- `TP1_TRG=INDEX`: trigger touch probe 1 on encoder index

## Encoder configuration used for homing

The homing-specific encoder configuration is in `cfg/enc_inc.yaml`.
This file is loaded after `cfg/axis.yaml`, so its homing parameters become the active axis homing setup.

```yaml
encoder:
  desc: Inc RS422
  numerator: 360
  denominator: 1048576
  type: 0
  bits: 32
  absBits: 0
  position: ec0.s$(ENC_SID).positionActual${ENC_CH=01}_2
  status: ec0.s$(ENC_SID).touchProbeStatus${ENC_CH=01}
  control: ec0.s$(ENC_SID).touchProbeControl${ENC_CH=01}
  primary: True
  latch:
    position: ec0.s$(ENC_SID).touchProbePositionPos$(ENC_CH=01)_1
    control: 0
    status: 1
    armCmd: 21
    armBits: 5
  homing:
    type: 12
    position: 0
    velocity:
      to: 30
      from: 20
    acceleration: 20
    deceleration: 100
    latchCount: 1
```

## Meaning of the EL7062 latch settings

The EL7062 uses a touch probe control word instead of the simpler EL51xx latch arm bit.

The relevant YAML settings are:
- `encoder.control`: touch probe control word
- `encoder.status`: touch probe status word
- `encoder.latch.position`: latched touch probe position
- `encoder.latch.control`: start bit where the arm command is written
- `encoder.latch.status`: bit in the touch probe status word that indicates a new latch event
- `encoder.latch.armCmd`: arm command value
- `encoder.latch.armBits`: number of bits written from `armCmd`

For this example:
- `armCmd: 21` means `0b10101`
- this sets touch probe 1 enable, trigger mode B1, and positive-edge latching
- `armBits: 5` means those 5 bits are written starting at bit `0`

## Notes about channel numbering

This example uses drive channel 1.
The secondary incremental encoder of that channel is exposed through PDO names ending in `_2`, for example:
- `positionActual01_2`
- `touchProbePositionPos01_1`

So although the incremental encoder is the secondary encoder, it still belongs to channel `01` in the YAML macros used here.

## SDO-based view of the same setup

If you want to understand the underlying slave settings, the equivalent setup is:

1. Configure touch probe 1 to trigger on encoder index.
2. Select the secondary encoder as touch probe source.

The `Encoder-Generic-INC` component does this through the `TP1_POS_SRC=SEC` and `TP1_TRG=INDEX` macros, so manual SDO configuration is not needed in this example.

## Relation to homing sequences

For EL7062 index homing, use the same ecmc homing sequences as for other index-capable encoders:
- sequence `11`: `ECMC_SEQ_HOME_LOW_LIM_INDEX`
- sequence `12`: `ECMC_SEQ_HOME_HIGH_LIM_INDEX`

This example uses sequence `12`.

## Related documentation

- `hugo/content/manual/motion_cfg/homing.md`
- `hugo/content/manual/knowledgebase/hardware/EL7062.md`
- `examples/PSI/best_practice/motion/stepper_incremental/ex7062_CSV/`
