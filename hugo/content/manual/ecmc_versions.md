+++  
title = "ecmc versions"   
weight = 10
chapter = false
+++  

### Features
New features are described in the RELEASE.md file of ecmc:
https://github.com/epics-modules/ecmc/blob/master/RELEASE.md

### v11
Some new features that might be useful in ecmc v11:
* Position Velocity Timne motion (profile move)
* CSP-PC mode (CSP Position Control). Enable ecmc centralized position loop also in CSP mode. Typical use cases:
  * A drive (El7062 or Ex72xx) in CSP that also needs to close the loop on a linear encoder. 
  * Motion based on analog I/O, analog output corresponds to a position. In order to close the loop in ecmc layer "CSP-PC" must be used.
* PID parameters can be set from motor record fields but should be a factor 100 smaller (this because the fields are limited to teh range 0..1.0).

{{% notice warning %}}
Please be careful when using the motor record PID parameter fields. The settings via motor record should be a **factor 100 smaller** than the ecmc setting. Also note that these MR-fields are not synced with the ecmc fields if they are changed.
Example: ecmc kp = 1, same setting through MR.PCOF = 0.01.
{{% /notice %}}

#### Migration guide v10 to v11
In general v11 is backward compatible with v10 but in order to benefit from new functionalities some updates are recommended:
* Auto enable: Move auto enable from motor record to ecmc
* Master/Slave sync. state  machine: Use ecmc native state machine for sync. of virtual and physical axes instead of state machine implemented in plc code.
* Logic on limits: Use plcOverride keyword to allow logic for setting limit switches.
* Minimize risk of burning motors by SDO verification for drive slaves.

##### Auto-enable
Auto-enable, previously handled by the motor record model 3 driver has now been implemented also in ecmc layer. It's highly recommended to switch to use the auto-enable features in ecmc instead since the motor record implementation is blocking and therefore other axes cannot take commands while auto enable is for one axis is executing.
In ecmc auto-enable feature is configured with 3 settings:

```
axis:
  autoEnable:
    enableTimeout: 1.0  # Timeout for going to enabled state
    disableTimeout: 5.0 # Axis disable after this time when non busy.
    atStartup: False    # Auto enable axis at ioc start
```
##### Master/Slave sync. state machine
For master slave axes systems where the virtual-physical axes state machine is loaded from plc-code should be updated to use the native ecmc state machine instead. This gives a higher level of diagnostics and also adds a few new features like improved error handling and controlling standby current on slaved axes.

The following configurations needs to be updated:
* Remove including/loading of axis_sm.plc_inc code in plc files
* Add an ecmc state machine for each master slave system by the ecmccfg-cmd "addMasterSlaveSM.cmd":
```
#- Add state machine to sync the virtual and physical axes (the groups are defined in the yaml axis-cfg files) 
${SCRIPTEXEC} ${ecmccfg_DIR}addMasterSlaveSM.cmd "NAME=Slit_SM, MST_GRP_NAME=virtualAxes, SLV_GRP_NAME=realAxes"
```
MACROS used in "addMasterSlaveSM.cmd":
* NAME: needs to be unique for each master slave system
* MST_GRP_NAME:  The group name for the virtual axes (defined in axis yaml definitions)
* SLV_GRP_NAME:  The group name for the physical axes (defined in axis yaml definitions)

Note: if several master slave systems are configured then the NAME, MST_GRP_NAME and SLV_GRP_NAME needs to be unique for that system.

Example 2 slit systems with unique names:
```
#- State machine for slit system in Y direction (slitVirtY and slitRealY defined in axes yaml configurations for the axes)
${SCRIPTEXEC} ${ecmccfg_DIR}addMasterSlaveSM.cmd "NAME=SlitY, MST_GRP_NAME=slitVirtY, SLV_GRP_NAME=slitRealY"

#- State machine for slit system in X direction (slitVirtX and slitRealX defined in axes yaml configurations for the axes)
${SCRIPTEXEC} ${ecmccfg_DIR}addMasterSlaveSM.cmd "NAME=SlitX, MST_GRP_NAME=slitVirtX, SLV_GRP_NAME=slitRealX"
```

##### Logic on limits (plcOverride)
Functionality to write to limit switches has been added. Combining several limits switches into one signal can be achieved by using the 'plcOverride' keyword in the definition of limit switches. Limits can then be calculated based on custom logic in ecmc PLC code.
Note: Motion are allowed when the value of the limit switches are '1' (0 means limit is engaged).
Example:
```
...
input:
  limit:
    forward: 'plcOverride'                            # Overridden, see plc code below
    backward: 'plcOverride'                           # Overridden, see plc code below
...
plc:
  enable: true                                        # Enable axis plc
  externalCommands: true                              # Allow axis to inputs from PLC  
  code:                                               # Sync code (appended after code in plc.file)
    - ax${AX_ID=1}.mon.lowlim:=ec_chk_bit(ec0.s$(DRV_SID).binaryInputs01,0) and ec_chk_bit(ec0.s$(DRV_SID).ONE,0);
    - ax${AX_ID=1}.mon.highlim:=ec_chk_bit(ec0.s$(DRV_SID).binaryInputs01,1) and ec_chk_bit(ec0.s$(DRV_SID).ONE,1);
  ..
```

##### SDO verification for drive slaves
A misspelled macro could in worse case lead to that a current setting for a drive is not downloaded correctly. In order to minimize this risk a SDO verification step has been added in v11 of ecmc/cfg/comp. Workflow:
1. the hw-snippet called by "addSlave.cmd" for drive terminals, i.e EX7XXX, executes an ecmc-command that tells ecmc that a SDO configuration is needed for a certain channel.
2. "applyComponent.cmd" with a motor configuration: Executes an ecmc-command that tells ecmc that SDO configuration has been performed for a certain channel.
    If "applySlaveConfig.cmd, or configureSlave.cmd" is used, then independent on which configuration is downloaded to the slave, the command telling ecmc that SDO configuration for channel 1 and 2 is executed. This is of course not optimal but safer than without check. Please try to move to applyComponent.cmd for higher security. If the drive has more than 2 channels, like EL7062, and one channel is unused then also this channel needs a configuration. "applyComponent.cmd  "COMP=Generic-Ch-Not-Used,          CH_ID=2'"
 
3. If the SDO cfgs have not been downloaded for a channel, the IOC will stop at validation just before iocInit.
4. If all the needed channels have been configured with SDOs then the IOC will start.

Note: If manual configuration is made, not using applyComponent.cmd, configureSlave.cmd, or applySlaveConfig.cmd, then the SDO verification functionality can be overridden by:
```
#- Use of apply component:
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Generic-Ch-Not-Used,          CH_ID=2'"

#- Ecmc native command
ecmcConfig "Cfg.EcSetSlaveSDOSettingsDone(<SlaveID>,<ChID>,1)"

```
Currently, this is implemented for stepper and servo drives. Analog or step direction control is not affected by SDO verification, if not manually added.
