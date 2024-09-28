+++  
title = "motion"   
weight = 14
chapter = false  
+++

## Topics
1. [both_limits error](#both_limits-error)
2. [position lag error, (following error), tuning](#position-lag-error)
3. [latency issues](#latency-issues)
4. [drive refuse to enable](#drive-refuse-to-enable)
5. [force manual motion](#force-manual-motion)

---

## both_limits error
The "BOTH_LIMITS" error can be related to that limits switches are not powered with 24V. As standard at PSI, limits are feed from 24V outputs, normally an EL2819 terminal. Basically the outputs needs then to be set to 1 in order to power the switches. Check the schematics in order to find out which output that powers the switches for a certain axis and then use one the following approaches to set it to 1:

Define the output in axis yaml file:
```
axis:
  id: 1                                               # Axis id
  ...
  feedSwitchesOutput: ec0.s5.binaryOutput02           # Ethercat entry for feed switches
  ...
```

By using the command Cfg.WriteEcEntryEcPath(ec\<master\_id\>.s\<slave\_id\>.binaryOutput\<id\>,\<value\>):
```
ecmcConfigOrDie "Cfg.WriteEcEntryEcPath(ec0.s5>.binaryOutput02,1)"
```

## position lag error
A position lag error (following error) can be generated in the following situations:
1. The motor torque is too low, making it hard for the motor to keep up with the setpoint.
2. The scaling factors are wrong resulting in that the feed forward part of the controller is not working well.
3. The velocity setpoint is too high resulting in motor stall (common for stepper motors).
4. The velocity setpoint is higher than what the drive can achieve (saturated velocity setpoint).

### 1. motor torque to low

1. First ensure that the mechanics are i good condition and not blocked (over the entire working range). If possible, measure needed torque with a torque meter.
2. Check motor data, can the motor deliver the required torque at the required speed. If not, then a motor with higher torque is needed.
3. Check the current setting of the motor. If possible increase the current setting to get a higher torque.

{{% notice warning %}}
Before increase current to the motor, make sure that both motor and drive can handle the higher current. Extra care needs to be taken for vacuum applications.
{{% /notice %}}

### 2. scaling factors are wrong
Check the scaling documentation [here](https://paulscherrerinstitute.github.io/ecmccfg/manual/axis/scaling/).
One way to test if the scaling is correct is to set all controller parameters (except Kff) to 0 and then initiate a move. Basically the actual position of the axis should follow the setpoint closely with teh same slope. If the slope differs, then the scaling factors are wrong.

### 3. the velocity setpoint is too high resulting in stall
If a stepper motor stalls because of too high velocity there's a few thing that can be done in order to improve the ability to reach higher velocities:
1. Add a damper: This is normally very efficient but not always possible.
2. Tune controller parameters (both position loop in ecmc and the controller loops in the drive), see hardware/tuning
3. If possible, test to increase or reduce current (make sure you do not burn the motor if increasing).

{{% notice warning %}}
Before increase current to the motor, make sure that both motor and drive can handle the higher current. Extra care needs to be taken for vacuum applications.
{{% /notice %}}

### 4. velocity higher than allowed by driver
For EL704x stepper drives are default setup to maximum velocity range of +-2000 full-steps/s. The 16bit velocity setpoint that are sent to the drive corresponds to this range. Basically trying to write a higher value than that will saturate the velocity setpoint resulting in that the required speed is not achieved, resulting in position lag error. The speed range for the EL704x can however be changed by setting SDO 8012:05:
```
0 for 1000 full-steps/second
1 for 2000 full-steps/second (default)
2 for 4000 full-steps/second
3 for 8000 full-steps/second
4 for 16000 full-steps/second
5 for 32000 full-steps/second
```
After changing this value you also need to change the drive scaling in the axis yaml file.

## drive refuse to enable
First check the dedicated hardware drive panel for diagnostics. If the drive is in warning or error state the diagnose the problem with the tool described in [hardware](hardware).

Possible reasons:
1. For systems with safety, tripp off STO or power to the drive removed by contactor. Check status of safety system.
2. Over current protection of 48V tripped.
3. No 48V connected.
4. ecmc PLC disabling axis, check PLC sources.
5. Motion axis in error state. Some errors prevent the axis from being enabled. Check axis error state
6. Drive hardware enable input not set high (valid for EP7211-0034, EL70xx if special cfgs).
7. Axis object configured with external interlock (yaml->input.interlock).

## force manual motion
{{% notice warning %}}
This procedure is for experts only. You run the risk of destroying expansive devices! Limit switches are _not_ obeyed! YOU HAVE BEEN WARNED! 
{{% /notice %}}
In case the hardware is fine, the cables are checked, human error is mostly excluded, or the system used to work but doesn't work any longer, directly writing to the drive is possible.

For this however, the IOC needs to be reconfigured to _not_ link the hardware to an axis!
1. Edit the startup script and comment out the axis, just leave the slave configuration.
2. restart the IOC
3. check the PVs for the drive in question (slave 7 in this case)
4. `dbgrep "*s007*"`
5. There should be two PVs ending with, `-Drv01-Cmd` and `-Drv01-Spd`
6. Set `-Drv01-Cmd` to `1` and check the amplifier did enable, if you don't know how to check for an enabled amplifier, you should not use this command!
7. After the amplifier is engaged, write a small number to `-Drv01-Spd`. Depending on the scaling, the number might be in the range of 1..1000.
8. Observe the encoder, or in case of open-loop, the device itself.
