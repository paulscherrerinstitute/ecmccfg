# EL7411 Test

MAXON EC-40 MAX 311733 2239929 312315 2307522
BLDC motor with incremental encoder and hall sensors.
Hard to know what compinets based on those numbers. 
Some searching resulted in that 312315 is a combination numer for these components:

## Motor 
EC-Max 40 brushless 120W with hallsensors
Motor Partnumber 283870
Nominal torque: 170mNm
Nominal voltage: 48V
Max continious current: 4.06A
No load speed 10100 rpm

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

## Encoders
MR-type L 1000pts 3 channels with line driver
Encoder partnumber: 228456
Supply voltage 5V
TTL compatible

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

