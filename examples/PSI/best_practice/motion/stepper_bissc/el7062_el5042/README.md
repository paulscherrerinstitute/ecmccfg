# Closed loop stepper EL7062, EL5042

NOTE: The EL7062 has a firmware bug when running in CSV mode, at each disable the open-loop counter jumps to closest full turn.
Therefore, EL7062 must run in **CSP** mode and in order to still use the centralized position control loop also the open loop counter needs to be configured as a CSP encoder.
Beckhoff has confirmed the bug and it will be fixed, but earliest sometime in 2026.


# Configuration for EL7062 and EL5042
* Lab test stage (1mm/rev)
* EL7062 stepper drive
* EL5042 BISS-C reader
* RLS BISS-C linear encoder (absolute)
* Open loop encoder (incremental)

## Startup script
A minimal startup script:
`#- Example config for closed loop CSP with position control
require ecmccfg "ENG_MODE=1"
require ecmccomp

#- DO to feed limit switches
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=2,HW_DESC=EL2819"
epicsEnvSet(BO_SID,${ECMC_EC_SLAVE_NUM})

#- Stepper drive
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL7062_CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000,L_COIL_UH=3050,R_COIL_MOHM=2630'"
#- Use autotune to get the controller parameter, resistance and inductance (trigger in hw expert panel)
#- Then copy the MACROS field from panel and apply it with "Drive-Generic-Ctrl-Params" like below
#- Note: "Motor-Generic-2Phase-Stepper" also require to define R and L (put any value).
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Drive-Generic-Ctrl-Params,    CH_ID=1, MACROS='L_COIL_UH=3100,R_COIL_MOHM=2620,I_TI=12,I_KP=59,V_TI=150,V_KP=176,P_KP=10'"

#- Must tell ecmc that channel is not used since otherwise monitoring of SDO settings will prevent IOC from start
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Generic-Ch-Not-Used,          CH_ID=2'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

#- BISS-C
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=1"
epicsEnvSet(ENC_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis.yaml,              DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${ENC_SID}, ENC_CH=01, BO_SID=${BO_SID}"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/enc_open_loop.yaml,     DEV=${IOC}, ENC_SID=${DRV_SID}"

```
A few things to note:
1. applyComponent.cmd with motor parameters
2. when IOC is running an auto-tune can be performed from the expert panel. The auto-tune will return controller params, R and L in the format required by MACROS for "Drive-Generic-Ctrl-Params".
3. if only one channel is used, then the second channel needs to be applied with the "Generic-Ch-Not-Used" component, otherwise IOC will not start. ecmc "checks" that all drives that are linked to motion axes have a SDO download via applyComponent.cmd, configureSlave.cmd or applySlaveSettings.cmd.
4. In order to activate the centralized position controller in ecmc when running CSP mode the drive encoder, open loop, needs to be configured with "encoder.useAsCSPDrvEnc: 1", see below for details.

## Scalings
Config for scaling in mm, mm/s, mm/s2

### Encoder scalings
Two encoders are configured:
1. Closed loop: BISS-C. This is used as the default encoder for control
2. Open loop: EL7062 Step counter (used as CSP encoder)

Both these encoders (and drive) should be scaled to the same unit (mm).

####  RLS BISS-C (encoder 1)

RLS BISS-C:
* encoder.numerator: Travels 1 mm/rev (linear encoder)
* encoder.denominator: Resolution: 4096 counts per = 1mm
* encoder.absBits: 26 bits
* encoder.type: Absolute (type 1)
* ecnoder.absOffset: Offset to 0 position of linear stage (-1408.794 in this example)

```
encoder:
  desc: BISS-C
  numerator: 1                                         # Scaling numerator example 1 mm/rev
  denominator: 4096                                    # Scaling denominator example 4096 ticks per 360 degree
  type: 1                                              # Type: 0=Incremental, 1=Absolute
  bits: 26                                             # Total bit count of encoder raw data
  absBits: 26                                          # Absolute bit count (for absolute encoders) always least significant part of 'bits'
  absOffset: -1408.794                                 # Encoder offset in eng units (for absolute encoders)
  position: ec0.s$(ENC_SID).positionActual${ENC_CH=01} # Ethercat entry for actual position input (encoder)
  status: ec0.s$(ENC_SID).encoderStatus${ENC_CH=01}    # mandatory only if 'warning' or 'error' are used
  ready: 2                                             # Bit in encoder status word for encoder ready
  warning: 0                                           # Warning (optional)
  error:                                               # max 3 (optional)
    - 1                                                # Error 0
```

#### Open loop (encoder 2)
The EL7062 drive has a build in micro step counter (64 microsteps/fullstep):
* encoder.numerator: Travels 1 mm/rev
* encoder.denominator: Resolution: 1048576 microsteps/rev
* encoder.bits: The counter is 32bit (default)
* encoder.type: Incremental (type 0)
* encoder.useAsCSPDrvEnc: Must be set to enable centralized position control loop. (This since the BISS-C and the open-loop counter can be in different coordinate systems.)

```
encoder:
  desc: Openloop
  unit: mm
  numerator: 1                                         # Scaling numerator example 1 mm/rev
  denominator: 1048576                                 # Scaling denominator example 4096 ticks per 360 degree
  type: 0                                              # Type: 0=Incremental, 1=Absolute
  bits: 32                                             # Total bit count of encoder raw data
  position: ec0.s$(ENC_SID).positionActual${ENC_CH=01} # Ethercat entry for actual position input (encoder)
  status: ec0.s$(ENC_SID).encoderStatus${ENC_CH=01}    # mandatory only if 'warning' or 'error' are used
  homing:
    refToEncIDAtStartup: 1                             # Ref encoder at startup (to BISS value)
  useAsCSPDrvEnc: 1                                    # This is the open loop encoder used for CSP
```
### Drive scalings

The EL7062 must be configured to run in CSP mode, for CSP mode the following settings should be applied (different scaling apply for CSV):
* drive.numerator: 1
* drive.denominator: 1048576
* drive.type: DS402 drive, set to 1

```
  numerator: 1                                        # Fastest speed in eng. units (360*8000Hz)
  denominator: 1048576                                # Scaling denominator example 4096 ticks per 360 degree
  type: 1                                             # Stepper: 0. DS402: 1 (DS402 = servos and advanced stepper drives)
  setpoint: ec0.s$(DRV_SID).positionSetpoint01        # Velocity setpoint if CSV. Position setpoint if CSP
  control: ec0.s$(DRV_SID).driveControl01             # Control word ethercat entry
  status: ec0.s$(DRV_SID).driveStatus01               # Status word ethercat entry
```

## Switches
In standard setup switches are feed from 24V output, for the lab 4ax motion crate this is not the case.
However, the configuration for feeding switches (axis.feedSwitchesOutput) have been added anyway:
```
axis:
  id: 1                                               # Axis id
  feedSwitchesOutput: ec0.s5.binaryOutput01           # Ethercat entry for feed switches

```

## Tuning
When tuning a CSP system with enabled position loop, CSP_PC mode, normally at least PID-gain and PID-integrator needs to be tuned. For CSV normally PID-gain is enough.

