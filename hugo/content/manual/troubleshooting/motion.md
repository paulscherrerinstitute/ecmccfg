+++  
title = "motion"   
weight = 12
chapter = false  
+++


## BOTH_LIMITS error
The "BOTH_LIMITS" error can be related to that limits switches are not powered with 24V. As standard at PSI, limts are feed from 24V outputs, normally an EL2819 terminal. Basically the ouptputs needs then to be set to 1 in order to power the switches. Check the schematics in order to find out which output that powers the switches for a certain axis and then use one the following approaches to set it to 1:

Define the output in axis yaml file:
```
axis:
  id: 1                                               # Axis id
  ...
  feedSwitchesOutput: ec0.s5.binaryOutput02           # Ethercat entry for feed switches
  ...
```

By using the commad Cfg.WriteEcEntryEcPath(ec\<master\_id\>.s\<slave\_id\>.binaryOutput\<id\>,\<value\>):
```
ecmcConfigOrDie "Cfg.WriteEcEntryEcPath(ec0.s5>.binaryOutput02,1)"
```

## Position Lag Error:
A position lag error is normally genereated in the following situations:
1. The motor torque is too low, making it hard for the motor to keep up with the setpoint.
2. The scaling factors are wrong resulting in that the feed forward part of the controller is not working well.
3. The velocity setpoint is too high resulting in motor stall (common for stepper motors).
4. The velocity setpoint is higher than what the drive can achive (saturated velocity setpoint).

### 1. Motor torque to low

If possible, increase current to the motor.
{{% notice warning %}}
Before increase current to the motor, make sure that both motor and drive can handle the higher current. Extra care needs to be taken for vaccum applications.
{{% /notice %}}

### 2. Scaling factors are wrong
Check the scaling documentation [here](https://paulscherrerinstitute.github.io/ecmccfg/manual/axis/scaling/).
One way to test if the scaling is correct is to set all controller parameters (except Kff) to 0 and then initiate a move. Basically the actual position of the axis should follow the setpoint closely with teh same slope. If the slope differs, then the scaling factors are wrong.

### 3. The velocity setpoint is too high resulting in stall
If a stepper motor stalls because of too high velocity there's a few thing that can be done in order to improve the ability to reach higehr velocities:
1. Add a damper: This is nromally very effichient but not always possible.
2. Tune controller parameters (both position loop in ecmc adn the controller loops in teh drive)
3. If possible, test to increase or reduce current setpoint (make sure you do not burn the motor).


## force manual motion
{{% notice warning %}}
This procedure is for experst only. You run the risk of destroying expansive devices! Limit switches are _not_ obeyed! YOU HAVE BEEN WARNED! 
{{% /notice %}}
In case the hardware is fine, the cables are checked, human error is mostly excluded, or the system used to work but doesn't work any longer, directly writing to the drive is possible.

For this however, the IOC needs to be reconfigured to _not_ link the hardware to an axis!
1. Edit the startup script and comment out the axis, just leave the slave configuration.
2. restart the IOC
3. check the PVs for the drive in question (slave 7 in this case)
4. `dbgrep "*s007*"`
5. There should be two PVs ending with, `-Drv01-Cmd` and `-Drv01-Spd`
6. Set `-Drv01-Cmd` to `1` and check the amplifier did enable, if you don't know how to check for an enabled amplifier, you should not use this command!
7. After the amplifier is engaged, write a small number to `-Drv01-Spd`. Dependinf on the scaling, the number might be in the range of 1..1000.
8. Observe the encoder, or in case of open-loop, the device itself.