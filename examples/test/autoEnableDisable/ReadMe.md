# Example: Auto enable disable of axis
# 

In the axis configuration files the parameter "ECMC_AXISCONFIG string" can be used to feed settings separted with ";" to the motor axis:

1. "powerAutoOnOff" : Enable/Disable auto power on/off.

   powerAutoOnOff = 0 : Disable auto power on/off 

   powerAutoOnOff = 1 : Enable auto power on/off 

   powerAutoOnOff = 2 : Enable auto power on/off. Allow to stay enabled if  powerOffDelay < 0.
 
3. powerOnDelay : Time in seconds to wait untill driver is enabled (max time between enable cmd and drive actually enabled)

2. powerOffDelay : Time in seconds to wait before driver is disabled after completed motion command

Example of config in ecmccfg axis file:
´´´
epicsEnvSet("ECMC_AXISCONFIG",            "powerAutoOnOff=2;powerOnDelay=6.0,powerOffDelay=1.0)

´´´
