+++  
title = "motion"   
weight = 14
chapter = false  
+++

## Topics
1. [both_limits error](#both_limits-error)
2. [position lag error, (following error)](#position-lag-error)
4. [drive refuse to enable](#drive-refuse-to-enable)
5. [force manual motion](#force-manual-motion)
6. [double limit switches](#double-limit-switches)

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
Check the scaling documentation [here](../../motion_cfg/scaling/).
One way to test if the scaling is correct is to set all controller parameters (except Kff) to 0 and then initiate a move. Basically the actual position of the axis should follow the setpoint closely with the same slope. If the slope differs, then the scaling factors are wrong.

### 3. the velocity setpoint is too high resulting in stall
If a stepper motor stalls because of too high velocity there's a few thing that can be done in order to improve the ability to reach higher velocities:
1. Add a damper: This is normally very efficient but not always possible.
2. Tune controller parameters (both position loop in ecmc and the controller loops in the drive), see hardware/tuning
3. If possible, test to increase or reduce current (make sure you do not burn the motor if increasing).

{{% notice warning %}}
Before increase current to the motor, make sure that both motor and drive can handle the higher current. Extra care needs to be taken for vacuum applications.
{{% /notice %}}

### 4. velocity higher than allowed by driver
The velocity setpoint of drives covers a certain velocity range:
* EL70xx stepper drives default: 16bit setpoint that corresponds to a velocity range of +-2000full-steps/s.
* EL72xx servo drives default: 32bit setpoint that corresponds to a velocity range of either +-6000Hz or +-8000Hz depending on the motor pole count.

If a velocity outside the velocity range is requested, the velocity setpoint will be saturated and the requested velocity will not be reached resulting in a position lag error.

For EL70xx drives the velocity range can be configured to other values than the default +-2000full-steps/s. See
[el70x1 speed range](../hardware/el70x1#speed-range) for setting other velocity range.

## drive refuse to enable
First check the dedicated hardware drive panel for diagnostics and errors/warnings.
For EL70x1 drive diagnostics, check [el70x1](../hardware/el70x1).

Possible reasons:
1. For systems equipped with motion safety (STO or power to the drive removed by contactor): Check status of safety system. Drives with STO:
  * EL72xx-9xxx
  * EP7211-0034
  * Festo CMMT-S
2. Over current protection of motor power (48V) tripped.
3. No motor power connected (48V or24V).
4. ecmc PLC disabling axis, check PLC sources.
5. Motion axis in error state. Some errors prevent the axis from being enabled. Check axis error state.
6. Drive hardware enable input not set high (valid for EL70xx if special cfgs).
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


## double limit switches
Sometimes two limit switches are needed, but only one can be linked in the yaml configuration. A use case could be if two axes have overlapping ranges and a switch is used to prevent them from colliding.

In order to configurethis a PLC needs to be added where the two limits switches are combined with a "and" (for normally closed switches) into one bit by the use of the simulation entries (ec<mid>.s<sid>.ONE or ec<mid>.s<sid>.ZERO). 

1. Add a plc
2. Choose a non used bit in the simulation emtry ec<mid>.s<sid>.ZERO (dummy 32bit memory area in ecmc initiated to 0). Any slave can be chooses but probbaly makes sense to use the drive slave.
3. Add code to combine the two switches into one bit ("and"). Use ec_wrt_bit to set the value.
4. Use the selected simulation bit in the yaml cfg.

Example (use ec0.s2.ZERO.31 as combined limit switch):
```
# Master 0
# Drive slave  3 (can be any slave)
# Bit 31
# Switch 1: ec0.s5.binaryInput01
# Switch 2: ec0.s5.binaryInput02
ec0.s3.ZERO:=ec_wrt_bit(ec0.s3.ZERO,ec0.s5.binaryInput01 and ec0.s5.binaryInput02,31);
```
Then use as forward or backward bit in yaml:
```
input:
  limit:
    forward: ec0.s2.ZERO.31     # In PLC "ec0.s5.binaryInput01 and ec0.s5.binaryInput02"
    backward: ....
```

## yaml parser installation error

ecmc yaml motion axis configururations depends on python venv with certain libs. The needed venv is installed in the "/tmp" dir when the first axis yaml file is loaded in a startup file. 

If the ecmc-server is not allowed to install with pip, like in the machine networks, then the below error meassge is printed in iocsh and loading of the axis fails:
```
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/9.6.8/R7.0.8/loadYamlAxis.cmd,     "FILE=cfg/servo-linear.yaml, ID=1, NAME=SERVO1, DESC=test, DRV_SLAVE=9"
#==============================================================================
# loadYamlAxis.cmd
on error halt
# Step 1: Get Filename (need to check if filename contains other macros also). Bascally run the filename in this iocsh
ecmcFileExist("cfg/servo-linear.yaml",1)
epicsEnvSet(FILE_TEMP_BASE,/tmp/X01DD-CPCL-FEMOT02/EcMaster_2/cfg/servo-linear.yaml)
epicsEnvSet(FILE_TEMP_1,/tmp/X01DD-CPCL-FEMOT02/EcMaster_2/cfg/servo-linear.yaml_1)
system ". /gfa/.mounts/sls_ioc/modules/ecmccfg/9.6.8/R7.0.8/pythonVenv.sh -d /tmp/X01DD-CPCL-FEMOT02/EcMaster_2/; python /gfa/.mounts/sls_ioc/modules/ecmccfg/9.6.8/R7.0.8/ecmcPlcGetFileName.py cfg/servo-linear.yaml /tmp/X01DD-CPCL-FEMOT02/EcMaster_2/cfg/servo-linear.yaml_1"
Collecting wheel
  Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/wheel/
  Retrying (Retry(total=3, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/wheel/
  Retrying (Retry(total=2, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/wheel/
  ```

PSI specific: The solution is to use the ecmc_server_cfg repo as described in it's readme.md. This repo enures that the correct python venv is copied after each boot and therefore the install is not needed at ioc startup.

{{% notice info %}}
In future release of ecmc/ecmccfg the yaml parser will be moved into ecmc (c++), making the python venv obsolete and not needed. This is WIP.
{{% /notice %}}
