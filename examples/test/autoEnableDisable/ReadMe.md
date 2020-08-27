# Example: Auto enable disable of axis
# 

In the axis configuration files the parameter "ECMC_AXISCONFIG" string can be used to feed settings separted with ";" to the motor axis:

1. "powerAutoOnOff" : Enable/Disable auto power on/off.

   powerAutoOnOff = 0 : Disable auto power on/off 

   powerAutoOnOff = 1 : Enable auto power on/off 

   powerAutoOnOff = 2 : Enable auto power on/off. Allow to stay enabled if  powerOffDelay < 0.
 
2. powerOnDelay : Time in seconds to wait untill driver is enabled (max time between enable cmd and drive actually enabled, can take a several seconds for certain drives)

3. powerOffDelay : Time in seconds to wait before driver is disabled after completed motion command

Example of config in ecmccfg axis file:
 ```bash
epicsEnvSet("ECMC_AXISCONFIG",            "powerAutoOnOff=2;powerOnDelay=6.0,powerOffDelay=1.0)

 ```

Some additional help can be printed by executing the ecmcMotorRecordCreateAxis without parameters in the iocsh:

 ```bash
mcag-epics4-18633 > ecmcMotorRecordCreateAxis

Iocsh command to create a model 3 asyn motor record driver axis for use with ECMC.
Creates an ecmcMotorRecordAxis object (derived from asynMotorAxis).

ecmcMotorRecordCreateAxis(
    controllerPortName : Asyn port name for the motor controller.                          : "ECMC_ASYN_MOTOR_PORT"
    axisNo             : Maximum number of axes (asyn parameters will be created for all). : "10"
    axisFlags          : Axis options (defaults to 6 in ecmccfg => 0x110):                 : "6"
                             -bit 0 : AMPLIFIER_ON_FLAG_CREATE_AXIS
                             -bit 1 : AMPLIFIER_ON_FLAG_AUTO_ON
                             -bit 2 : AMPLIFIER_ON_FLAG_USING_CNEN
    axisOptionsStr     : Optional options strings:                                         : "" 
                             -HomProc=        : Set homing sequence type (over-rides/writes def in record/param)
                             -HomPos=         : Set homing position (over-rides/writes def in record/param)
                             -axisFlags=      : Set axisFlags (over-rides/writes axisFlags in this call)
                             -powerAutoOnOff= : Set powerAutoOnOff (over-rides/writes def in record/param)
                             -powerOffDelay=  : Set powerOffDelay (over-rides/writes def in record/param)
                             -powerOnDelay=   : Set powerOnDelay (over-rides/writes def in record/param)
)
Example:
ecmcMotorRecordCreateAxis("ECMC_ASYN_MOTOR_PORT",10,6,"")

```

