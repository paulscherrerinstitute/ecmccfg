# Support for multiple encoders

The ecmc axis object have support for multiple encoders. Currently, a maximum of 8 encoders can be configured for each axis.
When creating an axis, encoder with index 0 will be created automatically. If more encoders are needed then the addEncoder.cmd command can be used.
The encoder with index 0 is as default chosen as the primary encoder and also to be the encoder used for any homing sequence (however these can be changed).

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

# Use cases


## Linear and rotational encoder


## Open loop and resolver (poro accuracy)


