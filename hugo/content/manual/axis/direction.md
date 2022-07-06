+++  
title = "direction of motion"
weight = 21
chapter = false  
+++

The direction of motion can be affected by multiple means.
Namely, on the [slave level](#ethercat-slave), in the [axis scaling](#ecmc-scaling) or in the [motorRecord](#epics-motorrecord).

{{% notice tip %}}
The best option is to change the direction of motion on the slave level. The alternatives lead to unintuitive scaling factors or mismatch between ECMC and EPICS.
{{% /notice %}}

## EtherCAT slave

ecmccfg allows SDOs to set individual SDOs in the startup-script of the IOC or in dedicated config files for slaves.
As most slaves have a SDOs to invert the direction of motion or counting, it's only natural to make use of this feature.
The benefit of changing the direction on the slave is obvious.
All axes move in there natural direction, as given by the machine coordinate system.
Limit switches - consequently - are always where they belong, even non-experts can diagnose the device or system.
Examples for encoder and drive are given below.

{{% notice info %}}
Consult the respective slave manual for the correct SDO.
{{% /notice %}}

### encoder direction
```shell
# slave 7 {ecmcEL5042}
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}configureSlave.cmd, "HW_DESC=EL5042, CONFIG=-Encoder-ch12-Renishaw_RL26BUT001B30V"
# Reverse encoder direction of ch1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x1,1,1)"
# Reverse encoder direction of ch2
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8018,0x1,1,1)"
```

### drive direction
```shell
# slave 18 {ecmcEL7041}
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}configureSlave.cmd, "HW_DESC=EL7041, CONFIG=-Motor-Phytron-VSS-42.200.2.5"
# Reverse motor direction:
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x9,1,1)"
```

## ECMC scaling

A negative numerator can be used to change the direction of motion.
Refer to the [scaling](../scaling) section for details.

{{% notice info %}}
This will result in negative values for `MRES` of the motorRecord.
{{% /notice %}}

## EPICS motorRecord

The `epics` key of the [axis config](../axisyaml) allows for motorRecord fields to be initialized.
By initalizing the `DIR` field to `Neg`, the motorRecord will start inverted.

```yaml
epics:
  name: reveredAxis
  precision: 1
  unit: deg
  motorRecord:
    enable: yes
    description: "inverted"
    fieldInit: "DIR=Neg"
```

{{% notice warning %}}
This will affect the motorRecord only, thus ECMC internally is still moving in the _wrong_ direction. You have been warned!
{{% /notice %}}