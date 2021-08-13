+++  
title = "axes yaml configuration"
weight = 15
chapter = false  
+++  

## instruction
The config is processed by `jinja2`, the processor will set complain if mandatory kyes are missing. Likewise, missing optional keys are populated with default values.
A [minmal example](#minimal-example) is give at the end of this file.

{{% notice warning %}}
`yaml` is indentation sensitive!
{{% /notice %}}

Below each of the mandatory keys will be explained.

### axis
Basic definition of the axis.
#### id
Unique, numerical identifier.
#### type
Type of axis, options are `joint` and `endeffector`
#### mode
Control mode, options are `CSV`, cyclic synchronize velocity and `CSP` cyclic synchronize position.
{{% notice note %}}
`CSV` is the defautl for ECMC, `CSP` is only supported for a limit number of drives and motors
{{% /notice %}}
```yaml
axis:
  id: 1
  type: joint   # this is for future selection of axis type
  mode: CSV     # supported mode, CSV and CSP
```

### motorRecord
Definitions for the EPICS integration via motorRecord.
#### name
Name of the axis in EPICS, string. The PV will be named `${IOC}:name`.
#### description
DESC field of the motorRecord, string.
#### precision
PREC field of the motorRecord, unisigned integer.
#### unit
EGU field of the motorRecord, string.
```yaml
motorRecord:
  name: M1
  description: AM8111 CSV
  precision: 3
  unit: deg
```

### drive
Drive specific parameters, most important scaling and links to the EtherCAT process image
#### numerator
Speed of the motor at max output (theoretical)
#### denominator
Value range of output. Typically 15-bit for stepper and 31-bit for servo drives.
#### type
Drive type, options are `0` for stepper drive and `1` for servo drive.
#### control
EtherCAT control word.
#### status
EtherCAT status word.
#### setpoint
EtherCAT setpoint. Both, velocity as well as position. Internal mapping in ECMC is handled by the processor.
```yaml
drive:
  numerator: 2880000                                  # Fastest speed in engineering units
  denominator:  2147483648                            # I/O range for ECMC_EC_ALIAS_DRV_VELO_SET
  type: 1                                             # Stepper: 0. DS402: 1 (DS402 = servos and advanced stepper drives)
  control: ec0.s$(DRV_SLAVE).driveControl01
  status: ec0.s$(DRV_SLAVE).driveStatus01
  setpoint: ec0.s$(DRV_SLAVE).velocitySetpoint01
```

### encoder
Similar to the drive, the encoder needs mainly the scaling and I/O to be configured
#### numerator
n engineering units.
#### denominator
m ticks on the encoder.
In the example below, one revolution (360 degree) cause the encoder to count 20-bit.
#### type
Encoder type: `0` for incremental, `1` for absolute.
#### bits
Total bit count of the encoder raw data.
#### absBits
Absolute bit count (for absolute encoders) always least significant part of 'bits'.
#### absOffset
Physical offset from Zero in engineering units.
#### position
EtherCAT position.
```
encoder:
  numerator: 360
  denominator: 1048576
  type: 1         # Type: 0=Incremental, 1=Absolute
  bits: 32        # Total bit count of encoder raw data
  absBits: 25     # Absolute bit count (for absolute encoders) always least significant part of 'bits'
  absOffset: 0    # Encoder offset in eng units (for absolute encoders)
  position: ec0.s$(DRV_SLAVE).positionActual01  # Ethercat entry for actual position input (encoder)
```


### controller
PID controller parameters
#### Kp
Proportional gain.
#### Ki
Integral gain.
```yaml
controller:
  Kp:  90
  Ki:  0.1
```

### trajectory
Trajectory related parameters.
#### axis
##### velocity
Startup velocity of the the axis.
##### acceleration
Acceleration time in seconds

```yaml
trajectory:
  axis:
    velocity: 180
    acceleration: 0.1
```

### input
All the inputs, i.e limit switches
#### limit
##### forward
Positive limit switch.
##### backward
Negtive limit switch.
#### home
Home refernce switch.
#### interlock
Input for external inhibition of the axis.

```yaml
input:
  limit:
    forward: ec0.s$(DRV_SLAVE).ONE.0    #  Ethercat entry for low limit switch input
    backward: ec0.s$(DRV_SLAVE).ONE.0   #  Ethercat entry for high limit switch input
  home: ec0.s$(DRV_SLAVE).ONE.0         #  Ethercat entry for home switch input
  interlock: ec0.s$(ENC_SLAVE).ONE.0    #  Ethercat entry for interlock switch input
```
---

### minimal example
```yaml
axis:
  id: 1
  type: joint   # this is for future selection of axis type
  mode: CSV     # supported mode, CSV and CSP

motorRecord:
  name: M1
  precision: 3
  description: AM8111 CSV
  unit: deg

drive:
  numerator: 2880000                                  # Fastest speed in engineering units
  denominator:  2147483648                            # I/O range for ECMC_EC_ALIAS_DRV_VELO_SET
  type: 1                                             # Stepper: 0. DS402: 1 (DS402 = servos and advanced stepper drives)
  control: ec0.s$(DRV_SLAVE).driveControl01
  status: ec0.s$(DRV_SLAVE).driveStatus01
  setpoint: ec0.s$(DRV_SLAVE).velocitySetpoint01

encoder:
  numerator: 360
  denominator: 1048576
  type: 1         # Type: 0=Incremental, 1=Absolute
  bits: 32        # Total bit count of encoder raw data
  absBits: 25     # Absolute bit count (for absolute encoders) always least significant part of 'bits'
  absOffset: 0    # Encoder offset in eng units (for absolute encoders)
  position: ec0.s$(DRV_SLAVE).positionActual01  # Ethercat entry for actual position input (encoder)

controller:
  Kp:  90
  Ki:  0.1

trajectory:
  axis:
    velocity: 180
    acceleration: 0.1

input:
  limit:
    forward: ec0.s$(DRV_SLAVE).ONE.0    #  Ethercat entry for low limit switch input
    backward: ec0.s$(DRV_SLAVE).ONE.0   #  Ethercat entry for high limit switch input
  home: ec0.s$(DRV_SLAVE).ONE.0         #  Ethercat entry for home switch input
  interlock: ec0.s$(ENC_SLAVE).ONE.0    #  Ethercat entry for interlock switch input
```
