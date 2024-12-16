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

In many cases inversion of the encoder value is possible in the ethercat slave. 
By using INV_DIR macro to applyComponent.cmd, the direction can be changed.

{{% notice info %}}
For EL5042, example below, the inversion leads to a very high number since the data size is 64bit. Therefore, it's advisable to switch sign in the axis configuration instead.
{{% /notice %}}

```shell
# slave 7 {ecmcEL5042}
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccomp_DIR}applyComponent.cmd "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=1, MACROS='INV_DIR=1'"
${SCRIPTEXEC} ${ecmccomp_DIR}applyComponent.cmd "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=2, MACROS='INV_DIR=1'"
```

### drive direction
```shell
# slave 18 {ecmcEL7041}
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL7041"
${SCRIPTEXEC} ${ecmccomp_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, MACROS='I_MAX_MA=1000, I_STDBY_MA=500, U_NOM_MV=48000, R_COIL_MOHM=1230,INV_DIR=1'"
```

## ecmc scaling

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