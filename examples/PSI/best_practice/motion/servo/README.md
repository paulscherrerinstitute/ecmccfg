# Configuration for Ex72xx-xxxx
* Lab test stage (1mm/rev)
* Motor : AM8111-0F20

## Scalings
Config for scaling in mm, mm/s, mm/s2

## Motor AM8111-XFX0
Data about the motor can be found here:
https://infosys.beckhoff.com/english.php?content=../content/1033/am8100/index.html&id=

Important for scaling factors in axis.yaml is the motor pole count. For the AM8111-XFX0 motor the pole count is 6.

## Encoder scaling
Only the encoder integrated encoder is configured in this example. The specification of the encoder for a AM8111-0F20 motor:

```
One Cable Technology for power and feedback: feedback transmission via motor cable, no feedback cable necessary, electronic nameplate, multi-turn, absolute position within 4096 revolutions, 18 bit resolution.
```
However, when connecting to an Ex72xx drive the single turn count will be 20bits and 12bits multiturn, resulting in a total of 32bits absolute bits.

* encoder.numerator: Travels 1 mm/rev
* encoder.denominator: Resolution: 1048576 counts (20bits) per = 1mm
* encoder.absBits: 32 bits (20bits+12bits)
* encoder.type: Absolute (type 1)
* ecnoder.absOffset: Offset to 0 position of linear stage (-1000 in this example)

```
# The encoder on most motors are 20bit single turn and 12 bit multiturn (4096 turns)
encoder:
  type: 1
  position: ec0.s$(DRV_ID).positionActual01
  numerator: 1
  denominator: 1048576
  bits: 32
  absBits: 32
  absOffset: -1000
```

### Drive scalings

IMPORTNT NOTE:
The below explained scaling might have changed in drive firmware (or differnt for different Ex72XX drives), needs further investigation. Could be that both 6 pole and 8 pole motors should be configured with max speed 8000 revs/s. Check scaling by:
* Enable pos lag monitoring with resonable settings
* Set the ecmc position controller params to 0 
* Execute a small move (always be prepared to kill axes, or E-stop).
* In this "open loop" move, the setpoint and actual should track well. If you see an error corresponding to approx. 25% of the move distance, then the scaling is wrong, then test the other scaling factor.


Max scale for motors depend on the pole count:
* 6 pole: Max scale is 8000revs/s (in this case 8000mm/s)
* 8 pole: Max scale is 6000revs/s

This then converts to the following cfgs:
* drive.numerator: Max velo = 8000 revs/s == 8000mm/s
* drive.denominator: velocity setpoint is 32bit == +-31bit = 2147483648
* drive.type: Servo drive, set to 1

```
drive:
  numerator: 8000  # mm/s, Max speed is 8000 rev/sec for drive (6 pole motor)
  denominator: 2147483648
  type: 1                            # Stepper: 0, DS402: 1 (servos)
  control: ec0.s$(DRV_ID).driveControl01
  status: ec0.s$(DRV_ID).driveStatus01
  setpoint: ec0.s$(DRV_ID).velocitySetpoint01
  reset: 7
```

## Switches
In standard setup switches are feed from 24V output, for the lab 4ax motion crate this is not the case.
However, the configuration for feeding switches (axis.feedSwitchesOutput) have been added anyway:
```
axis:
  id: ${AX_ID=1}
  feedSwitchesOutput: ec0.s$(BO_ID).binaryOutput01.0 # Ethercat entry for feed switches
```
