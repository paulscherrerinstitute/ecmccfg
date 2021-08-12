# EL7411 Test

## EL7411 Config

### HW enable:
The HW-enable input needs to be linked to to 24V (or interlock signal). If not wired the DS402 statemachine will just timout.
Orange led on right side of terminal should not be lit.
For test purpose the HW-enable can be wired to the Fan out terminal on the EL7411

## Maxon motor Encoder combo 312315 used for test
MAXON EC-40 MAX 311733 2239929 312315 2307522
BLDC motor with incremental encoder and hall sensors.
Hard to know what components based on those numbers. 
Some searching resulted in that 312315 is a combination numer for these components:

## Motor 
* EC-Max 40 brushless 120W with hallsensors
* Motor Partnumber 283870
* Nominal torque: 170mNm
* Nominal voltage: 48V
* Max continious current: 4.06A
* No load speed 10100 rpm

```
Pinout:
pin 1 red    : L1
pin 2 black  : L2
pin 3 white  : L3
pin 4        : NC

pinout hall:
pin 1 Yellow : hall 1
pin 2 brown  : hall 2
pin 3 grey   : hall 3
pin 4 blue   : gnd
pin 5 green  : 3..24V
pin 6        : NC
```

## Encoders
* MR-type L 1000pts (4000counts/rev) 3 channels with line driver
* Encoder partnumber: 228456
* Supply voltage 5V
* TTL compatible

```
Pin allocation (connector DIN 41651):
Looking into the female connector with the red wire to the left. Pin 1 is the upper left, pin two lower left:
1 3 5 7 9
2 4 6 8 10

1    : NC
2    : Vcc
3    : Gnd
4    : NC
5    : A neg
6    : A
7    : B neg
8    : B
9    : Z neg
10   : Z
```
## Drive scale in CSV mode
Reverse engineering of the velocity scaling resulted in that the unit for the velo is in deg/s (a bit strange, not like other terminals).
Method to find out.
1. Link the axis velocity setpoint to the sim entry "ZERO"
2. Start ioc
3. Enable axis: caput IOC_TEST:Axis1.CNEN 1
4. Set raw velocity setpoint from epics pv: caput  IOC_TEST:ec0-s10-EL7411-Drv-Spd 1000
5. Log movement: camonitor IOC_TEST:ec0-s10-EL7411-Enc-PosAct | tee pos.log
6. Calculate the velocity from logged data and compare to the  velo setpoint.

## Drive in CSP mode
CSP mode works OK.
Use same DRV scale ENC scale.
