# Directory EL72XX drives

# Reduction of torque
If the max torque of the motor needs to be reduced then the SDO entry 0x8011:0x11 can be used.


## Example: Apply max 50% torque

The rated current for the terminal is configured in  0x8011 0x12.

In this case the rated current for the motor is 2710mA which then corresponds to the rated torque. From motor config file:

```
...
#- 0x8011 0x12 Rated current (mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x12,2710,4)"
...
```
In order to limit the motor to max 50% of rated torque the maximum current of the motor needs to be reduced to 50% of the nominal current, in this case 0.5*2710=1355mA. This value needs to be set in 0x8011:0x11

Simplest alternative, add macro direct in slave config:
```
${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "SLAVE_ID=$(ECMC_EC_SLAVE_NUM_DRIVE), HW_DESC=EP7211-0034_ALL, CONFIG=-Motor-Beckhoff-AM8111-0F20-0000,CFG_MACROS='I_MAX_MA=1355'"
```

Or by setting SDO:
```
#- 0x8011 0x11 Max current (mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,1355,4)"
```
Now the motor torque output is limited to a maximum of 50% of the motor rated torque.

IMPORTANT: Do not change the setting for rated current since that will make the scaling between current and torque wrong.


# Digital inputs on E72XX-9014

The limits can be accessed in the infoData fields.
The configuration EL72xx_ALL_INPUTS maps configures the limits to be exposed in ecX.sX.infoData02.0
* BI01: ecX.sX.infoData02.0
* BI02: ecX.sX.infoData02.1
* STO:  ecX.sX.infoData02.8

The inputs might also be accessible in the touchProbe entries.

# Trouble shooting

## trying to enable but nothing happends (eventually goes into error state with DS402 timeout)

### HWE, STO 
* Make sure the drive STO and/or HWE inputs are wired with 24V signals.
* Check E-Stop or safty circuits

### Power supply
Make sure the EL72XX have dc power, both for motor and 24v logic (the power contacts on the sides). The two bottom leds should light green.
If 24V logic voltage is missing the terminal will look OK (no red leds) and No error seems to be possible to detect over ethercat. However, an enable command will result in a DS402 timeout after some seconds. In order to ensure that the motor have 24V dc, it needs to be placed beside a terminal that feeds it with this voltage (some terminals do not feed power in the side contacts, then a el9410 can be installed).

# Tuning velo and current loop
Normally teh default settings are fine but sometimes they need some tweaking.

## Case  X01DA-CPCL-OPSL1
Drive: EL7221-9014_ALL
Motor: AM8121-1FH1

### default in ecmccomp:
```
#- Velocity loop proportianal gain [mA/(rad/s)]
epicsEnvSet(MOT_VELO_KP,95)

#- Velocity loop integral time [0.1ms]
epicsEnvSet(MOT_VELO_TI,150)
```

### default in ecmccfg
```
#- Velocity loop integral time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x14,146,4)"
#- Velocity loop proportianal gain
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x15,95,4)"

```

### needed cfg
```
#- Velocity loop integral time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x14,150,4)"
#- Velocity loop proportianal gain
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x15,146,4)"
```

### Default in twincat
Same as "needed cfg".

Seems at some time the default settimngs for this motor changed.

Need to consider if an the values in ecmccfg and ecmccomp should be updated.

