# Support for multiple encoders

The ecmc axis object have support for multiple encoders. Currently, a maximum of 8 encoders can be configured for each axis.
When creating an axis, encoder with index 0 will be created automatically. If more encoders are needed then the addEncoder.cmd command can be used.
The encoder with index 0 is as default chosen as the primary encoder and also to be the encoder used for any homing sequence (however these can be changed).

```
# Add extra encoder to axis 1 (open loop counter)
$(SCRIPTEXEC) ($(ecmccfg_DIR)addEncoder.cmd, CONFIG=./cfg/encoder_cfg.enc)
```

The file 'encoder_cfg.enc' (example open loop counter of EL7037):
```
# Add open loop counter encoder

epicsEnvSet("ECMC_ENC_SCALE_NUM"               "60")
epicsEnvSet("ECMC_ENC_SCALE_DENOM"             "12800")
epicsEnvSet("ECMC_ENC_TYPE"                    "0")                        # Type: 0=Incremental, 1=Absolute
epicsEnvSet("ECMC_ENC_BITS"                    "16")                       # Total bit count of encoder raw data
epicsEnvSet("ECMC_ENC_ABS_BITS",               "0")                        # Absolute bit count (for absolute encoders) always least significant part of ECMC_ENC_BITS
epicsEnvSet("ECMC_ENC_ABS_OFFSET"              "0")                        # Encoder offset in eng units (for absolute encoders)
epicsEnvSet("ECMC_EC_ENC_ACTPOS",              "ec0.s7.positionActual01")  # Ethercat entry for actual position input (encoder)
epicsEnvSet("ECMC_EC_ENC_RESET",               "")                         # Reset   (if no encoder reset bit then leave empty)
epicsEnvSet("ECMC_EC_ENC_ALARM_0",             "")                         # Error 0 (if no encoder error bit then leave empty)
epicsEnvSet("ECMC_EC_ENC_ALARM_1",             "")                         # Error 1 (if no encoder error bit then leave empty)
epicsEnvSet("ECMC_EC_ENC_ALARM_2",             "")                         # Error 2 (if no encoder error bit then leave empty)
epicsEnvSet("ECMC_EC_ENC_WARNING",             "")                         # Warning (if no encoder warning bit then leave empty)

# This encoder will be refenced to encoder 0 at startup (set to -1 to not change setting)
epicsEnvSet("ECMC_ENC_REF_TO_ENC_AT_STARTUP",  "-1")

# Encoder index for closed loop control (set to -1 to not change setting)
epicsEnvSet("ECMC_ENC_PRIMARY_ID",  "-1")

# Encoder index for homing, the specified homing seq will be executed based on this enc. (set to -1 to not change setting)
epicsEnvSet("ECMC_ENC_HOME_ID",  "1")

# Reference this encoder at homing (set to -1 to not change setting)
epicsEnvSet("ECMC_ENC_REF_AT_HOME",  "0")

# Maximum position diff between this encoder and primary (set to 0 to disable check)
epicsEnvSet("ECMC_ENC_MAX_DIFF_TO_PRIM_ENC",  "0.005")

# For incremental encoders these variables can be added/used (optional):
epicsEnvSet("ECMC_EC_ENC_LATCHPOS",       "")                              # Ethercat entry for latch position (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_CONTROL",  "")                              # Ethercat entry for latch control (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_STATUS",   "")                              # Ethercat entry for latch status (only valid for home seq 11,12)
epicsEnvSet("ECMC_HOME_LATCH_COUNT_OFFSET","0")                            # Number of latch/over/under-flow for home (home seq 11,12,21,22)

```

## Primary encoder

The primary encoder is the encoder that is used in the ecmc-control loop.
Any of the configured encoders can be used as primary encoder (but as default encoder 0 is used).

```
ecmcConfigOrDie "Cfg.SelectAxisEncPrimary($(ECMC_AXIS_NO),${ECMC_ENC_PRIMARY_ID=-1})"

```
NOTE: if a ECMC_ENC_PRIMARY_ID=-1 the current value in ecmc will not be overwritten.

## Homing encoder

The homing encoder is the encoder that will be used for control during homing sequence.
Any of the configured encoders can be used as homing encoder (but as default encoder 0 is used).

If homing encoder is different than primary encoder the following will happen at homing:
1. The homing encoder will be referenced to the primary encoder to avoid any jump in the control.
2. The homing encoder will be used for control (switch encoder).
3. After homing, the primary encoder will be referenced to the value of the encoder used for homing.
4. The primary encoder will again be used for control (switch back to primary encoder).

NOTE: The primaryu encoder will always be referenced to the value of the homing encoder independet if
the ECMC_ENC_REF_AT_HOME=0 (described below).

The following command can be used to select homing encoder index:
```
ecmcConfigOrDie "Cfg.SelectAxisEncHome($(ECMC_AXIS_NO),${ECMC_ENC_HOME_ID=-1})"
```
NOTE: if a ECMC_ENC_HOME_ID=-1 the current value in ecmc will not be overwritten.

## Config encoder

The newest encoder created is autonatically set to be the one that recives configuration commands. 
If configuration of a different encoder is needed then teh follwing command can be used:
```
ecmcConfigOrDie "Cfg.SelectAxisEncConfig($(ECMC_AXIS_NO),${ECMC_ENC_CFG_ID=-1})"

```
NOTE: if a ECMC_ENC_CFG_ID=-1 the current value in ecmc will not be overwritten.

## Ref/sync encoders to other encoder at startup

At staretup encoders could be syncronized (set to same value as another encoder). This could be usefull in order to have same reading on all or some of your encoders at startup.

```
ecmcConfigOrDie "Cfg.SetAxisEncRefToOtherEncAtStartup($(ECMC_AXIS_NO),${ECMC_ENC_REF_TO_ENC_AT_STARTUP=-1})"

```

## Ref/sync encoders at homing

```
ecmcConfigOrDie "Cfg.SetAxisEncEnableRefAtHome($(ECMC_AXIS_NO),${ECMC_ENC_REF_AT_HOME=-1})"

```

## Position diff between encoders interlock

Prevent motion if difference between encoders are higher than the defined value:

```
ecmcConfigOrDie "Cfg.SetAxisEncMaxDiffToPrimEnc($(ECMC_AXIS_NO),${ECMC_ENC_MAX_DIFF_TO_PRIM_ENC=0})"
```

NOTE: check will only be made between encoders that are homed (or absolute, which are set to homed).

# PVs:

Example: Encoder related PVs for 6 encoders:
```
# Actual positions
IOC_TEST:Axis1-PosAct
IOC_TEST:Axis1-PosAct01
IOC_TEST:Axis1-PosAct02
IOC_TEST:Axis1-PosAct03
IOC_TEST:Axis1-PosAct04
IOC_TEST:Axis1-PosAct05

# Actual velocities
IOC_TEST:Axis1-VelAct
IOC_TEST:Axis1-VelAct01
IOC_TEST:Axis1-VelAct02
IOC_TEST:Axis1-VelAct03
IOC_TEST:Axis1-VelAct04
IOC_TEST:Axis1-VelAct05
```

# Use cases

## Linear and rotational encoder


## Open loop and resolver (poro accuracy)


