+++  
title = "stepper and biss-c (EL7041, EL5042)"
weight = 15
chapter = false  
+++

* Lab test stage (1mm/rev)
* Lab 4 axis motion control box
* RLS BISS-C linear encoder (absolute)
* Open loop encoder (incremental)

## Scalings
Config for scaling in mm, mm/s, mm/s2

### Encoder scalings
Two encoders are configured:
1. Closed loop: BISS-C. This is used as the default encoder for control
2. Open loop: EL7041 Step counter

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
The EL7041 drive has a build in micro step counter (64 microsteps/fullstep):
* encoder.numerator: Travels 1 mm/rev
* encoder.denominator: Resolution: 200*64=12800 microsteps/rev = 12800 microsteps/mm
* encoder.bits: The counter is 16bit (default)
* encoder.type: Incremental (type 0)

```
encoder:
  desc: 'Open loop'
  unit: mm
  numerator: 1                                # Scaling numerator
  denominator: 12800                          # Scaling denominator
  type: 0                                     # Type: 0=Incremental, 1=Absolute
  bits: 16                                    # Total bit count of encoder raw data
  absBits: 0                                  # Absolute bit count (for absolute encoders)
  absOffset: 0                                # Encoder offset in eng units (for absolute encoders)
  position: ec0.s$(DRV_SID).positionActual01  # Ethercat entry for actual position input (encoder)
  homing:
    refToEncIDAtStartup: 1                    # Ref encoder at startup (to BISS value)

```
### Drive scalings

The EL7041 is default setup to operate in a velocity range of +-2000 full steps/s which then corresponds to the 16bit drive.setpoint parameter (ec0.s$(DRV_SID).velocitySetpoint01):
* drive.numerator: Max velo = 2000 fullsteps/s == 10mm/s
* drive.denominator: velocity setpoint is 16bit == +-15bit = 32768
* drive.type: Stepper drive, set to 0

```
drive:
  numerator: 10                                 # Fastest speed in eng. units (2000 Fullsteps/s==10mm/s)
  denominator: 32768                            # I/O range for ECMC_EC_ALIAS_DRV_VELO_SET (normally +-16bit)
  type: 0                                       # Stepper: 0. DS402: 1 (DS402 = servos and advanced stepper drives)
  setpoint: ec0.s$(DRV_SID).velocitySetpoint01  # Velocity setpoint if CSV. Position setpoint if CSP
  control: ec0.s$(DRV_SID).driveControl01       # Control word ethercat entry
  enable: 0                                     # Enable bit index in control word (not used if DS402)
  reset: 1                                      # Reset bit in control word (if no drive reset bit then leave empty)
  reduceTorque: 2                               # Reduce torque bit in drive control word
  reduceTorqueEnable: True                      # Enable reduce torque functionality
  status: ec0.s$(DRV_SID).driveStatus01         # Status word ethercat entry
  enabled: 1                                    # Enabled bit index in status word (not used if DS402)  
  warning: 2                                    # Warning bit in status word (if no drive warning bit then leave empty)
  error:                                        # max 3 error bits in status word
    - 3                                         # Error 0 (if no drive error bit then leave empty)
    - 7                                         # Error 1 (if no drive error bit then leave empty)
    - 14                                        # Error 2 (if no drive error bit then leave empty)
```

## Switches
In standard setup switches are feed from 24V output, for the lab 4ax motion crate this is not the case.
However, the configuration for feeding switches (axis.feedSwitchesOutput) have been added anyway:
```
axis:
  id: 1                                               # Axis id
  feedSwitchesOutput: ec0.s5.binaryOutput01           # Ethercat entry for feed switches

```
