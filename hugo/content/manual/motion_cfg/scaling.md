+++  
title = "scaling"
weight = 20
chapter = false  
+++

By popular demand, the topic scaling will be discusses in closer detail.

ecmc has to scaling factors for each joint, firstly the [drive](#drive-scaling) scaling, secondly the [encoder](#encoder-scaling) scaling.

{{% notice warning %}}
Changes to the scaling have direct effects on the `Kp` of the PID-loop.
If the drive scaling is changes, make sure to adjust the PID parameters accordingly.
{{% /notice %}}

## drive scaling
Drive scaling deals with the relation of the drive output (typically a 16- or 32-bit register) to axis velocity.
Scaling is similar, but slighlty different for [stepper drives](#stepper-motor-drives) and [servo drives](#servo-motor-drives)

### stepper motor drives
The scaling for the Ex70xx slaves will be explained based on two very common examples.

#### simple linear axis
Assumptions:
* 200 fullsteps/rev motor
* lead screw pitch: 5 mm/rev
* Register `0x8012:05` is set to `1` --> 2000 fullsteps max step rate (default for ECMC, check for other slaves!)
* `velocitySetpoint` is in 16-bits.

```yaml
drive:
  numerator: 50        # Fastest speed in engineering units (2000 full steps / s --> 10 rev/s * 5 mm/rev --> 50 mm/s)
  denominator:  32768  # I/O range 2^15, because 16-bit register, half is forward, the other half is backward
```

##### explanation
The `denominator` is `32768` because the `velocitySetpoint` is a 16-register for the Beckhoff stepper drives.
Thus, half of the full range is reserved for positive (forward) motion, the remaining half for negative (backward) motion.
This means that at full output the motor would receive 2000 fullsteps per second.
It is irrelevant whether the motor can actually spin this fast as this a purely theoretical value!
Since we have established that the motor spins at 10 rev/s at full output, the conversion to engineering units is trivial and yields 50 mm/s, based on the lead screw pitch.

#### rotational axis
Assumptions:
* 400 fullsteps/rev motor
* drive train ratio: 36 deg/rev
* Register `0x8012:05` is set to `1` --> 2000 fullsteps max step rate (default for ECMC, check for other slaves!)
* `velocitySetpoint` is in 16-bits.

```yaml
drive:
  numerator: 180       # Fastest speed in engineering units (2000 full steps / s --> 5 rev/s * 36 deg/rev --> 180 deg/s)
  denominator:  32768  # I/O range 2^15, because 16-bit register, half is forward, the other half is backward
```

##### explanation
At full output, the motor receives 2000 fullsteps/s, which results in 5 rev/s
due to the higher fullstep count of the motor. The drive train ratio is specified
as 10 motor revolutions per 360 degree on the output or 36 deg/rev. Therefore,
the resulting velocity of the motor in EGUs is 180 deg/s. Please note that
this is _not_ the actual maximum velocity, but rather a theoretical scaling
factor for the PID-loop.

### servo motor drives
This section is based on the Beckhoff servo motor drives (Ex72xx), AX-drives or drives from other vendors might differ.
The Ex72xx servo motor drives from Beckhoff use a 32-bit register for the velocity setpoint.
Therefore, the `denominator` takes on a value of `2^31 = 2147483648`.

As for the `numerator`, the situation is a bit more complicated.
The `AM81xx` synchronous motors come with different pole counts, most have 3 pole pairs, but some have 4.
 Naturally, this results in a different scaling for either type.
At full output a 3 pole pair motor would spin at 8000 revolutions per second!
Respectively, the 4 pole pair motor will assume 6000 rev/s.
Since no servo motor will ever reach such speeds and the value is only used for the PID-loop scaling, no difference is noticeable in real life applications.
Except when a motor is replaced by a different model with deviating pole pair count.

The following example shows a 3 pole pair motor scaled for operation in `degrees`.
Therefore, the numerator equals 8000 rev/s * 360 deg/rev = 2880000 deg/s.
```yaml
drive:
  numerator: 2880000         # Fastest speed in engineering units (8000 rev/s * 360 deg/rev)
  denominator:  2147483648   # I/O range 2^31, because 32-bit register, half is forward, the other half is backward
```

## encoder scaling
This scaling ratio describes the relation of encoder counts and engineering units of the axis.

Unlike the drive scaling, the encoder scaling is much simpler.
It represents merely the realtion between the observed counts on the encoder and the displacement of the load.

### closed-loop

Scaling absolute encoders is simple.
This example shows a 32-bit encoder with 4096 ticks/mm, for an axis operated in mm.
```yaml
encoder:
  numerator: 1
  denominator: 4096
  type: 1         # Type: 0=Incremental, 1=Absolute
  bits: 32        # Total bit count of encoder raw data
```

#### explanation
none, this should be simple enough!

### open-loop

Obviously, for open-loop operation there is no encoder.
In this case the internal step counter of the stepper motor drive is used as "encoder".
In the example below such a case is presented, with an explanation.

```yaml
encoder:
  numerator: 0.125    # 0.125 mm/rev lead screw
  denominator: 12800  # 200 fullsteps/rev with 64 microsteps/fullstep
  type: 0         # Type: 0=Incremental, 1=Absolute
  bits: 16        # Total bit count of encoder raw data
```

#### explanation
The internal step counter operates in microsteps.
For most drives this value assumes 64, if uncertain consult the respective manual of the drive.
In case of a 200 fullsteps/rev motor, the `denominator` therefore will be set to `200*64=12800`.
As for the `numerator`, this is simply the displacement observed for one full motor revolution.
As the step counter is incremental, the `type: 0` has to be set.
The step counter is of type `uint16`, thus the `bits: 16` setting, which is important to handle the over-/underflow.
