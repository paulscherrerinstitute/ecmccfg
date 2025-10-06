+++  
title = "ecmc versions"   
weight = 10
chapter = false
+++  


### Features
New features are described in the RELEASE.md file of ecmc:
https://github.com/epics-modules/ecmc/blob/master/RELEASE.md

### v11

#### Migration guide v10 to v11

In general v11 is backward compatible with v10 but in order to benefit from new functionalities some updates are recommended:
* Auto enable: Move auto enable from motor record to ecmc
* Sync state  machine: Use ecmc native state machine for sync. of virtual and physical axes instead of state machine implemented in plc code.
* logic on limits: Use plcOverride keyword to allow logic for setting limit switches.
* Minimize risk of burning motors by SDO verification for drive slaves.

##### Auto enable


##### Sync. state machine


##### Logic on limits (plcOverride)
Combining several limits switches into one signal can be achieved by using the 'plcOverride' keyword in the definition of limit switches. Limits can then be calculated based on custom logic in ecmc PLC code.
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
A misspelled macro could in worse case lead to that a current setting for a drive is not downloaded correctly. In order to minimize this risk a SDO verification step has been added in ecmc/cfg/comp. Workflow:
1. "addSlave.cmd" hw-snippet for drive terminals, i.e EX7XXX, executes an ecmc-command that tells ecmc that a SDO configuration is needed for a certain channel.
2. "applyComponent.cmd" with a motor configuration: Executes an ecmc-command that tells ecmc that SDO configuration has been performed for a certain channel.
    If "applySlaveConfig.cmd, or configureSlave.cmd" is used, then independent on which configuration is downloaded to the slave, the command telling ecmc that SDO configuration for channel 1 and 2 is executed. Please try to move to applyComponent.cmd for higher security.


Currently, this is implemented for stepper and servo drives. Pure analog control is not affected by SDO verification, if not specifically added.

In order to minimize the risc of burning motors resulting from missed configuration of currents, could be misspelled macros.



################################## 
Remove below




# 11.0.0_RC1
* Add auto enable for axes at ioc start. Typical usecase, motion axis based on analog input and outputs (i.e. piezos):
  ```
  ecmcConfigOrDie "Cfg.SetAxisEnableAtStartup(<axisId>, <autoenable>)"
  ```
  The functionality is accessed in ecmccfg by the yaml key "axis.autoEnable.atStartup".
* Add commands to verify important SDO settings, like current for drives, have been set. This to minimize risc of burning motors but can also be used for other usecases:
  ```
  ecmcConfigOrDie "Cfg.EcSetSlaveNeedSDOSettings(<SlaveId>,<ChId>,<needSdoCfg>)"
  ecmcConfigOrDie "Cfg.EcSetSlaveSDOSettingsDone(<SlaveId>,<ChId>,<sdoSettingDone>)"
  ecmcConfigOrDie "Cfg.EcSetSlaveEnableSDOCheck(<SlaveId>,<enable>)"
  ```
  Typically, the Cfg.EcSetSlaveNeedSDOSettings() is called in the hardware snippet called by addSlave.cmd. This tells ecmc that the slave must have sdo configuration. In ecmccfg this command is added for most drives by default. The second command is normally executed by applyComponent.cmd after the settings have been written, telling ecmc that SDO cfg have been performed for a certain slave and channel. Validation will occur before going to realtime operation by checking that all calls to "EcSetSlaveNeedSDOSettings()" for a certain slave and channels have a corresponding call to "EcSetSlaveSDOSettingsDone()", if not, the ioc will not start. For two channel slaves, like EL7062, also the second channel needs to be configured even if it is not used, then use component "Generic-Ch-Not-Used" in applyComponent.cmd:
  ```
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "SLAVE_ID=3,HW_DESC=EL7062_CSP"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000,L_COIL_UH=3050,R_COIL_MOHM=2630'"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Generic-Ch-Not-Used,          CH_ID=2"
  ```
  An alternative way of overriding is to use the ecmc commands directly:
  ```
  # Example slave 4, channel 2
  ecmcConfigOrDie "Cfg.EcSetSlaveSDOSettingsDone(4,2,1)"
  ```
  The functionality can also be enabled/disabled by the command "Cfg.EcSetSlaveEnableSDOCheck()".

* Default not reference abs encoder during a successful homing (change in ecmccfg)
* Add support for setting motion control parameters through motor record fields (PCOF, ICOF and DCOF). The values written to the motor record fields are multiplied by a factor of 100.0 (ecmc.kp = 100.0 * PCOF, same for I and D).
* Change moving axis flag to only be high when busy
* Add ecmc native auto enable and disable of axes:
```
 "Cfg.SetAxisAutoEnableTimeout(<axis_id>,<time_s>)"
 "Cfg.SetAxisAutoDisableAfterTime(<axis_id>,<time_s>)"
```
* Add tweak commands in axis control word (target position value will be used as tweak value):
   - bit 11: tweak bwd cmd
   - bit 12: tweak fwd cmd
* Add support for setting homing velocity through motor record HVEL field. The functionality must be enabled by setting PREFIX:MOTOR-HomUseHVEL to 1 (and HVEL field to a resonable velocity). NOTE: This is NOT the preferred way of homing an motor. The prefered way is using the parameters saved in the encoder object. The velocity will be used if the defined homing sequence is not set to 14. If set to 14 the encoder paramteres stored in the encoder object will be used.

## Breaking changes
Removed:
* getAxisStatusStructV2 
* Event*
* ComamndList*
* DataRecorder*
* Cleanup of axis interfaces (remove duplicate infos)
* Update of parameters (sync of ecmc and motor record interface)

## Add plc functions to set vel, acc ,dec, jerk from plc:
```
  1. error = mc_set_traj_vel(
                            <axIndex>,  : Axis index
                            <vel>       : Target velocity
                            );
  Set target velocity.

  2. error = mc_set_traj_acc(
                            <axIndex>,  : Axis index
                            <acc>       : Max acceleration
                            );
  Set max acceleration.

  3. error = mc_set_traj_dec(
                            <axIndex>,  : Axis index
                            <dec>       : Max deceleration
                            );
  Set max deceleration.
  note: mc_set_traj_dec() is only valid for trapez trajectory (trajectory.type=0). For s-curve trajectory mc_set_traj_acc() is used for both acceleration and deceleration.

  4. error = mc_set_traj_jerk(
                            <axIndex>,  : Axis index
                            <jerk>      : Max jerk
                            );
  Set max jerk.
  note: mc_set_traj_jerk() is only valid for s-curve trajectory (ruckig, trajectory.type=1)
```

##  Support to override limit and home switch from plc code.
If multiple limits switches is needed or some logic expression then the limits can be calculated in plc code. These commands were added to override the EtherCAT entries for the limits:
* PLCs: Always load FileIO lib and Vector lib

```
Cfg.SetAxisLimitSwitchBwdPLCOverride(int axis_no, int value);
Cfg.SetAxisLimitSwitchFwdPLCOverride(int axis_no, int value);
Cfg.SetAxisHomeSwitchPLCOverride(int axis_no, int value);
```
Note: Overridden limit switches must be set from plc code.

In ecmccfg the commands have been linked to the yaml configuration by using the 'plcOverride' keyword:
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

## PVT
* Now the first and last points (for acc and dec)
are calculated based on the direction of motion for the nearby point.
* Add auto enable for axes (TODO, move code to axes object so that also normal ecmc axis can benefit).

### Triggering
Added support for profile move triggers as "defined" in the profileMove extension to motor record.
Two new commands added:
```
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(<ethercat entry>,pvtctrl.trigger.output)"
ecmcConfigOrDie "Cfg.SetPVTControllerTrgDurMs(<trigger_duration_ms>)"
```
The commands are wrapped in the ecmccfg command pvtControllerConfig.cmd;
```
${SCRIPTEXEC} ${ecmccfg_DIR}pvtControllerConfig.cmd  "TRG_EC_ENTRY=ec0.s$(ECMC_EC_SLAVE_NUM).ONE.31, TRG_DUR_S=0.15"
```

## Add support for dual position control loop in CSP mode (in ecmc called CSP_PC)

### Description of use-case:
    Normally, in CSP-mode, no centralized position control will be executed,
    instead, the position control loop is moved to the drive. It's however
    possible to activate the centralized ecmc position loop also if needed.
    A use case could be a rotary servo motor (in CSP-mode) driving a stage equipped with 
    a linear encoder.

### Details:
    CSP normally must be based on the encoder connected to the drive/motor, in this 
    case the position control loop is only performed in the drive and ecmc
    will only send position setpoints. In order to enable (ecmc) position control
    on the linear encoder, then, also the linear encoder needs to be configured.
    In this example, the linear encoder is simulated with the same rotary encoder but 
    with a different scaling (in order for the two encoders to show different 
    values). The simulated linear encoder should be selected as primary (for control).
    The drive object still needs to know the drive actual position in order to send
    accurate position setpoints. This is done by selecting the encoder with 
    "ecmcConfigOrDie "Cfg.SelectAxisEncCSPDrv(<axis id>,<enc_id>)". 
    This encoder needs to have the proper scaling for the drive.
    The system will now also use the centralized ecmc position control loop,
    resulting in 2 position loops are activated, one in ecmc and one in the drive.
    In this case, the ecmc-PID parameters needs to be defined and then also tuned.
    Normally a PI controller is needed. The control output to the drive will be 
    a position setpoint that is controller by the normal ecmc PID controller.
    If the "Cfg.SelectAxisEncCSPDrv(<axis id>,<enc_id>)" is not executed or if the 
    primary encoder is selected, then the drive object will by default use the
    the primary encoder and the position loop in ecmc will be disabled (normal CSP).
    So, in order to use dual loops, the primary encoder and the CSP drive encoder 
    needs to be different.

The encoder connected to the drive needs to be configured with the "useAsCSPDrvEnc" like below:
```
encoder:
  desc: CSP drive encoder
  type: 1
  position: ec0.s$(DRV_ID).positionActual01
  numerator: 360
  denominator: 1048576  # 20bits
  bits: 32
  absBits: 32
  absOffset: -294100
  useAsCSPDrvEnc: 1    # use this encoder as CSP drive encoder
```