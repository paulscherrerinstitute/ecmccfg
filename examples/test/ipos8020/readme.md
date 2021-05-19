# Test dir for ipos8020
Two example setups are available:

1. Open loop

2. Closed loop (resolver connected to EL7201)


# Notes on drive scaling for IPOS8020

A raw setpoint of 2^16 corresponds to 1000microsteps/second (for ESS generic stepper configuration).

So scaling for degrees would then be:
```
2^16/1000.0*51200/360 = 9320.6755. (corresponds to 1 deg/s)

```

## Open loop

### Scaling (degrees)

Example of scaling of encoder for unit motor deg:

```
epicsEnvSet("ECMC_ENC_SCALE_NUM"          "360")    # One rev is 360deg
epicsEnvSet("ECMC_ENC_SCALE_DENOM"        "51200")  # Open loop counter scaled in micro steps (256levels per fullstep, 256*200=51200 counts/rev)  
```

Example of scaling of drive for unit motor deg:

```
epicsEnvSet("ECMC_DRV_SCALE_NUM"          "1")
epicsEnvSet("ECMC_DRV_SCALE_DENOM"        "9320.7")   # 9320.7 raw velocity setpoint corresponds to 1deg/s (based on the generic setup of the drive)
```

### Scaling (mm)

Example of scaling of encoder for unit mm (10mm/rev):

```
epicsEnvSet("ECMC_ENC_SCALE_NUM"          "10")       # One rev is 10 mm
epicsEnvSet("ECMC_ENC_SCALE_DENOM"        "51200")    # Open loop counter scaled in micro steps (256levels per fullstep, 256*200=51200)
```

Example of scaling of drive for unit deg:

```
epicsEnvSet("ECMC_DRV_SCALE_NUM"          "1")
epicsEnvSet("ECMC_DRV_SCALE_DENOM"        "335544.3")   # 9320.7*360/10=335544.3 (335544.3 raw velocity setpoint to the drive corresponds to 1mm/s)  
```

## Closed loop

Closed loop example. Encoder is a resolver connected to an EL7201 (single turn resolution is 2^20).

### Scaling (degrees)

Example of scaling of encoder for unit motor deg:

```
epicsEnvSet("ECMC_ENC_SCALE_NUM"          "-360")     # 360deg/rev (- sign just because the combination of resolver and EL7201 have different positive direction than IPOS8020)
epicsEnvSet("ECMC_ENC_SCALE_DENOM"        "1048576")  # Single turn resolution of EL7201 (2^20) 
```

Example of scaling of drive for unit motor deg:

```
epicsEnvSet("ECMC_DRV_SCALE_NUM"          "1")
epicsEnvSet("ECMC_DRV_SCALE_DENOM"        "9320.7")   # 9320.7 raw velocity setpoint corresponds to 1deg/s (based on the generic setup of the drive)
```

### Scaling (mm)

Example of scaling of encoder for unit mm (10mm/rev):

```
epicsEnvSet("ECMC_ENC_SCALE_NUM"          "-10")     # 10mm/rev (- sign just because the combination of resolver and EL7201 have different positive direction than IPOS8020)
epicsEnvSet("ECMC_ENC_SCALE_DENOM"        "1048576")  # Single turn resolution of EL7201 (2^20) 
```

Example of scaling of drive for unit deg:

```
epicsEnvSet("ECMC_DRV_SCALE_NUM"          "1")
epicsEnvSet("ECMC_DRV_SCALE_DENOM"        "335544.3")   # 9320.7*360/10=335544.3 (335544.3 raw velocity setpoint to the drive corresponds to 1mm/s)  

```