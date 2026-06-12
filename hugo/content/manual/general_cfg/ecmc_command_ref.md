+++
title = "ecmc command reference"
weight = 30
chapter = false
+++

## ecmc command reference

* ethercat: [https://epics-modules.github.io/ecmc/ecmcEthercat_8h.html](https://epics-modules.github.io/ecmc/ecmcEthercat_8h.html)
* motion: [https://epics-modules.github.io/ecmc/ecmcMotion_8h.html](https://epics-modules.github.io/ecmc/ecmcMotion_8h.html)
* general: [https://epics-modules.github.io/ecmc/ecmcGeneral_8h.html](https://epics-modules.github.io/ecmc/ecmcGeneral_8h.html)
* misc: [https://epics-modules.github.io/ecmc/ecmcMisc_8h.html](https://epics-modules.github.io/ecmc/ecmcMisc_8h.html)
* plc: [https://epics-modules.github.io/ecmc/ecmcPLC_8h.html](https://epics-modules.github.io/ecmc/ecmcPLC_8h.html)
* plugin: [https://epics-modules.github.io/ecmc/ecmcPlugin_8h.html](https://epics-modules.github.io/ecmc/ecmcPlugin_8h.html)
* com: [https://epics-modules.github.io/ecmc/ecmcCom_8h.html](https://epics-modules.github.io/ecmc/ecmcCom_8h.html)

### General

| Command syntax | Description |
|---|---|
| `GetBlockCfgCmdsInRuntime()` | Get whether `Cfg.` parser commands are blocked while ecmc is in runtime. |
| `Cfg.LinkEcEntryToObject(<str>,<str>)` | Links an EtherCAT entry to an object. |
| `Cfg.LoadCppLogic(<int>,<str>)` | Load one additive C++ logic shared library. |
| `Cfg.LoadCppLogic(<int>,<str>,<str>)` | Load one additive C++ logic shared library with config string (`asyn_port=...;sample_rate_ms=...;update_rate_ms=...`). |
| `Cfg.ReportCppLogic(<int>)` | Print a report for one loaded C++ logic object. |
| `Cfg.SetBlockCfgCmdsInRuntime(<int>)` | Enable or disable blocking of most `Cfg.` parser commands during runtime. Must be set before entering runtime. |
| `Cfg.SetEnableFuncCallDiag(<int>)` | Enable printouts of which functions in hw_motor.cpp are being called. |
| `Cfg.SetEnableTimeDiag(<int>)` | Enable printouts of timing information related to the realtime thread. |
| `Cfg.ValidateConfig()` | Validates the current configuration) |

### Motion

| Command syntax | Description |
|---|---|
| `Cfg.AddAxisEnc(<int>)` | Add encoder object to axis. |
| `Cfg.AddAxisGroup(<str>)` | Creates an axis group object. See [Axis Groups]({{< relref "/manual/general_cfg/axis_groups.md" >}}). |
| `Cfg.AddAxisToGroupByIndex(<int>,<int>)` | Adds an axis to a group. See [Axis Groups]({{< relref "/manual/general_cfg/axis_groups.md" >}}). |
| `Cfg.AddAxisToGroupByName(<int>,<str>)` | Adds an axis to a group. See [Axis Groups]({{< relref "/manual/general_cfg/axis_groups.md" >}}). |
| `Cfg.AddAxisToGroupByName(<int>,<str>,<int>)` | Adds an axis to a group. See [Axis Groups]({{< relref "/manual/general_cfg/axis_groups.md" >}}). |
| `Cfg.AppendAxisPLCExpr(<int>)=<str>` | Append axis sync. |
| `Cfg.CompileAxisPLC(<int>)` | Compile Axis PLC code. For syntax and usage patterns, see [PLC syntax]({{< relref "/manual/PLC_cfg/syntax.md" >}}) and [PLC patterns]({{< relref "/manual/PLC_cfg/patterns.md" >}}). |
| `Cfg.CreateAxis(<int>)` | Creates an axis object at index axisIndex. |
| `Cfg.CreateAxis(<int>,<int>)` | Creates an axis object at index axisIndex. |
| `Cfg.CreateAxis(<int>,<int>,<int>)` | Creates an axis object at index axisIndex. |
| `Cfg.CreateAxis(<int>,<int>,<int>,<int>)` | Creates an axis object at index axisIndex. |
| `Cfg.CreateDefaultAxis(<int>)` | Creates an axis object at index axisIndex. |
| `Cfg.CreateMasterSlaveSM(<int>,<str>,<str>,<str>,<int>,<int>)` | Create a new master/slave state machine object. See [Master/Slave State Machine]({{< relref "/manual/general_cfg/master_slave_state_machine.md" >}}). |
| `Cfg.SetMstSlvAtTgtTimeout(<int>,<float>)` | Set master/slave timeout after all master axes reached target. |
| `GetAxisAcc(<int>)` | Get axis acceleration setpoint. |
| `GetAxisAllowCommandsFromPLC(<int>)` | Get axis allow command from PLC. |
| `GetAxisBlockCom(<int>)` | Get whether active command-parser set commands are blocked for an axis. |
| `GetAxisCycleCounter(<int>)` | Get axis execution cycle counter. |
| `GetAxisDec(<int>)` | Get axis deceleration setpoint. |
| `GetAxisDrvScaleNum(<int>)` | Get drive output scale numerator. |
| `GetAxisEnableAlarmAtHardLimits(<int>)` | Get enable alarms at limits bit. |
| `GetAxisEnableSoftLimitBwd(<int>)` | Get backward soft-limit enabled state of an axis. |
| `GetAxisEnableSoftLimitFwd(<int>)` | Get forward soft-limit enabled state of an axis. |
| `GetAxisEncConfigIndex(<int>)` | Get index of current encoder being configured. |
| `GetAxisEncPosRaw(<int>)` | Get raw unscaled encoder value. |
| `GetAxisEncPrimaryIndex(<int>)` | Get index of current encoder being used for control (PID). |
| `GetAxisEncScaleDenom(<int>)` | Get the denominator part of the encoder scale. |
| `GetAxisEncScaleNum(<int>)` | Get the numerator part of the encoder scale. |
| `GetAxisEncSourceType(<int>)` | Get axis encoder data source. |
| `GetAxisGroupCount()` | Get total axis-group count. See [Axis Groups]({{< relref "/manual/general_cfg/axis_groups.md" >}}). |
| `GetAxisGroupIndexByName(<str>)` | Get index of axis group by name. See [Axis Groups]({{< relref "/manual/general_cfg/axis_groups.md" >}}). |
| `GetAxisHomeVelOffCam(<int>)` | Get off cam referencing/homing velocity setpoint. |
| `GetAxisHomeVelTowardsCam(<int>)` | Get Towards cam referencing/homing velocity setpoint. |
| `GetAxisModRange(<int>)` | Get axis modulo range. |
| `GetAxisModType(<int>)` | Set axis modulo motion type. |
| `GetAxisMonAtTargetTime(<int>)` | Get "at target" monitoring time (cycles). |
| `GetAxisMonAtTargetTol(<int>)` | Set drive type. |
| `GetAxisMonEnableAtTargetMon(<int>)` | Get enable "at target" monitoring. |
| `GetAxisMonEnableLagMon(<int>)` | Get position lag monitoring enable. |
| `GetAxisMonEnableMaxVel(<int>)` | Get enable maximum velocity monitoring (over speed). |
| `GetAxisMonEnableVelocityDiff(<int>)` | Enable monitoring of velocity difference. |
| `GetAxisMonExtHWInterlockPolarity(<int>)` | Get polarity of motion axis interlock from EtherCAT entry. |
| `GetAxisMonHomeSwitchPolarity(<int>)` | Get polarity of home switch. |
| `GetAxisMonLatchLimit(<int>)` | Get latch on limit settings. |
| `GetAxisMonLimitBwdPolarity(<int>)` | Get polarity of hard low limit switch. |
| `GetAxisMonLimitFwdPolarity(<int>)` | Get polarity of hard high limit switch. |
| `GetAxisMonMaxVel(<int>)` | Get maximum allowed velocity. |
| `GetAxisMonMaxVelDriveILDelay(<int>)` | Set velocity monitoring interlock delay for drive. |
| `GetAxisMonMaxVelTrajILDelay(<int>)` | Set velocity monitoring interlock delay for trajectory. |
| `GetAxisMonPosLagTime(<int>)` | Get position lag monitoring time (cycles). |
| `GetAxisMonPosLagTol(<int>)` | Get position lag maximum monitoring tolerance. |
| `GetAxisMonVelDiffDriveILDelay(<int>)` | Set drive interlock filter time in cycles for velocity difference monitoring. |
| `GetAxisMonVelDiffTol(<int>)` | Set maximum allowed difference between setpoint speed and actual speed±n |
| `GetAxisMonVelDiffTrajILDelay(<int>)` | Set trajectory interlock filter time in cycles for velocity difference monitoring. |
| `GetAxisPLCEnable(<int>)` | Get axis enable for axis sync. |
| `GetAxisPLCEncVelFilterEnable(<int>)` | Enables/disables velocity filter of external actual value. |
| `GetAxisPLCEncVelFilterSize(<int>)` | Set size of external encoder velocity filter. |
| `GetAxisPLCTrajVelFilterEnable(<int>)` | Enables/disables velocity filter of external setpoint. |
| `GetAxisPLCTrajVelFilterSize(<int>)` | Set size of external trajectory velocity filter. |
| `GetAxisSoftLimitPosBwd(<int>)` | Get backward soft-limit position. |
| `GetAxisSoftLimitPosFwd(<int>)` | Get forward soft-limit position. |
| `GetAxisTrajSourceType(<int>)` | Get axis trajectory data source. |
| `GetAxisType(<int>)` | Get axis type. |
| `GetAxisVel(<int>)` | Get axis target velocity setpoint. |
| `GetMstSlvAtTgtTimeout(<int>)` | Get master/slave timeout after all master axes reached target. |
| `Cfg.LinkEcEntryToAxisDrive(<int>,,<int>,<int>,<int>)` | Links an EtherCAT entry to the drive object of the axis at axisIndex. |
| `Cfg.LinkEcEntryToAxisDrive(<int>,<str>,<int>,<int>,<int>)` | Links an EtherCAT entry to the drive object of the axis at axisIndex. |
| `Cfg.LinkEcEntryToAxisEncoder(<int>,<str>,<int>,<int>,<int>)` | Links an EtherCAT entry to the encoder object of the axis at axisIndex. |
| `Cfg.LinkEcEntryToAxisMonitor(<int>,<str>,<int>,<int>,<int>)` | Links an EtherCAT entry to the monitor object of the axis at axisIndex |
| `Cfg.LinkEcEntryToAxisStatusOutput(<int>,<str>,<int>)` | Links an EtherCAT entry to the an axis object for status output * The output will be high when the axis object is without error code and otherwise zero. |
| `Cfg.LoadAxisEncLookupTable(<int>,<str>)` | Load encoder correction lookup table file. |
| `MoveAbsolutePosition(<int>,<float>,<float>,<float>,<float>)` | Move axis to an absolute position. |
| `MoveRelativePosition(<int>,<float>,<float>,<float>,<float>)` | Move axis to a relative position. |
| `MoveVelocity(<int>,<float>,<float>,<float>)` | Move axis in a constant velocity. |
| `Cfg.SelectAxisEncConfig(<int>,<int>)` | Select encoder to configured. |
| `Cfg.SelectAxisEncCSPDrv(<int>,<int>)` | Select encoder to be used by ecmc drive object for CSP control. |
| `Cfg.SelectAxisEncPrimary(<int>,<int>)` | Select encoder to be used for control. |
| `Cfg.SetAxisAcc(<int>,<float>)` | Set axis acceleration setpoint. |
| `Cfg.SetAxisAllowCommandsFromPLC(<int>,<int>)` | Allow commands from PLCs. |
| `Cfg.SetAxisAllowSourceChangeWhenEnabled(<int>,<int>)` | Allow change of encoder and trajectory source when axis is enabled |
| `Cfg.SetAxisAutoDisableAfterTime(<int>,<float>)` | Set axis auto amplifier disable after a defined idle time (axis not busy). |
| `Cfg.SetAxisAutoEnableTimeout(<int>,<float>)` | Set axis auto amplifier enable timout time. |
| `Cfg.SetAxisAutoModeCmdHoming(<int>,<int>)` | Set axis auto mode command for homing. |
| `Cfg.SetAxisAutoModeCmdMotion(<int>,<int>)` | Set axis auto mode command for motion. |
| `Cfg.SetAxisBlockCom(<int>,<int>)` | Block or unblock active command-parser set commands for an axis. |
| `Cfg.SetAxisCntrlDeadband(<int>,<float>)` | Set PID-controller deadband. |
| `Cfg.SetAxisCntrlDeadbandTime(<int>,<int>)` | Set PID-controller deadband time filter. |
| `Cfg.SetAxisCntrlInnerParams(<int>,<float>,<float>,<float>,<float>)` | Use a differnt set of pid parameters if within a certain distance of target |
| `Cfg.SetAxisCntrlIPartHL(<int>,<float>)` | Set PID-controller maximum integral part output value. |
| `Cfg.SetAxisCntrlIPartLL(<int>,<float>)` | Set PID-controller minimum integral part output value. |
| `Cfg.SetAxisCntrlKd(<int>,<float>)` | Set PID-controller differential gain. |
| `Cfg.SetAxisCntrlKff(<int>,<float>)` | Set PID-controller feed forward gain. |
| `Cfg.SetAxisCntrlKi(<int>,<float>)` | Set PID-controller integral gain. |
| `Cfg.SetAxisCntrlKp(<int>,<float>)` | Set PID-controller proportional gain. |
| `Cfg.SetAxisCntrlOutHL(<int>,<float>)` | Set PID-controller maximum output value. |
| `Cfg.SetAxisCntrlOutLL(<int>,<float>)` | Set PID-controller minimum output value. |
| `Cfg.SetAxisDec(<int>,<float>)` | Set axis deceleration setpoint. |
| `Cfg.SetAxisDisableAtErrorReset(<int>,<int>)` | Disable axis at error reset * If axis is in error state and a reset command is issued, then the axis will be disabled. |
| `Cfg.SetAxisDrvBrakeCloseAheadTime(<int>,<int>)` | Set brake close ahead time . |
| `Cfg.SetAxisDrvBrakeEnable(<int>,<int>)` | Set enable of brake. |
| `Cfg.SetAxisDrvBrakeOpenDelayTime(<int>,<int>)` | Set brake open delay time . |
| `Cfg.SetAxisDrvReduceTorqueEnable(<int>,<int>)` | Set enable of reduce torque functionality. |
| `Cfg.SetAxisDrvScaleDenom(<int>,<float>)` | Set drive output scale denominator. |
| `Cfg.SetAxisDrvScaleNum(<int>,<float>)` | Set drive output scale numerator. |
| `Cfg.SetAxisDrvStateMachineTimeout(<int>,<float>)` | Set drive timeout . |
| `Cfg.SetAxisDrvVelSetOffsetRaw(<int>,<float>)` | Set drive raw velocity offset. |
| `Cfg.SetAxisEmergDeceleration(<int>,<float>)` | Set axis emergency deceleration setpoint. |
| `Cfg.SetAxisEnableAlarmAtHardLimits(<int>,<int>)` | Set enable alarms at limits bit. |
| `Cfg.SetAxisEnableAlarmAtSoftLimit(<int>,<int>)` | Enable alarm when at softlimit |
| `Cfg.SetAxisEnableAtStartup(<int>,<int>)` | Set axis amplifier enable at ioc startup. |
| `Cfg.SetAxisEnableMotionFunctions(<int>,<int>,<int>,<int>)` | Set enable of motion functions. |
| `Cfg.SetAxisEnableSoftLimitBwd(<int>,<int>)` | Set enable backward soft-limit of an axis. |
| `Cfg.SetAxisEnableSoftLimitFwd(<int>,<int>)` | Set enable forward soft-limit of an axis. |
| `Cfg.SetAxisEncAbsBits(<int>,<int>)` | Set encoder register bit count for absolute data. |
| `Cfg.SetAxisEncAllowOverUnderFlow(<int>,<int>)` | Set allow over/under flow of encoder raw counter * Set flag to allow over- and under-flows of encoder raw counter (default over/underflow are allowed). |
| `Cfg.SetAxisEncBits(<int>,<int>)` | Set encoder register bit count. |
| `Cfg.SetAxisEncDelayCyclesAndEnable(<int>,<float>,<int>)` | Set encoder delay in cycles * Delay between drv setpoint and encoder act, typically atleast 2 cycles |
| `Cfg.SetAxisEncEnableRefAtHome(<int>,<int>)` | Set referance this encoder at homing * Referance this encoder during homing. |
| `Cfg.SetAxisEncHomeLatchArmControlWord(<int>,%` | Set latch control word to arm latch The start bit is defined when linking the entry. |
| `Cfg.SetAxisEncHomeLatchCountOffset(<int>,<int>)` | Set home index pulse count offset. |
| `Cfg.SetAxisEncInvHwReady(<int>,<int>)` | Invert Encoder Ready bit. |
| `Cfg.SetAxisEncLookupTableEnable(<int>,<int>)` | Enable/Disable encoder lookup table. |
| `Cfg.SetAxisEncLookupTableRange(<int>,<float>)` | Set encoder lookup table mask |
| `Cfg.SetAxisEncLookupTableScale(<int>,<float>)` | Set encoder lookup table scale factor |
| `Cfg.SetAxisEncMaxDiffToPrimEnc(<int>,<float>)` | Set maximum position deviation between current encoder and primary encoder. |
| `Cfg.SetAxisEncOffset(<int>,<float>)` | Set encoder offset value. |
| `Cfg.SetAxisEncPosFilterEnable(<int>,<int>)` | Enables/disables encoder position filter. |
| `Cfg.SetAxisEncPosFilterSize(<int>,<int>)` | Set size of encoder position filter. |
| `Cfg.SetAxisEncRawMask(<int>,%` | Set encoder raw data mask. |
| `Cfg.SetAxisEncRefToOtherEncAtStartup(<int>,<int>)` | Reference this encoder to other encoder at startup. |
| `Cfg.SetAxisEncScaleDenom(<int>,<float>)` | Set the denominator part of the encoder scale. |
| `Cfg.SetAxisEncScaleNum(<int>,<float>)` | Set the numerator part of the encoder scale. |
| `Cfg.SetAxisEncSourceType(<int>,<int>)` | Set axis encoder data source. |
| `Cfg.SetAxisEncType(<int>,<int>)` | Set encoder type. |
| `Cfg.SetAxisEncVelFilterEnable(<int>,<int>)` | Enables/disables encoder velocity filter. |
| `Cfg.SetAxisEncVelFilterSize(<int>,<int>)` | Set size of encoder velocity filter. |
| `Cfg.SetAxisErrorId(<int>,<int>)` | Set axis error code. |
| `Cfg.SetAxisHomeAcc(<int>,<float>)` | Set homing acceleration for current encoder beeing configured. |
| `Cfg.SetAxisHomeDec(<int>,<float>)` | Set homing deceleration for current encoder beeing configured. |
| `Cfg.SetAxisHomeLatchCountOffset(<int>,<int>)` | Set home index pulse count offset. |
| `Cfg.SetAxisHomePosition(<int>,<float>)` | Set axis home reference position setpoint. |
| `Cfg.SetAxisHomePostMoveEnable(<int>,<int>)` | Set homing post movement enable * After successfull homing sequence an absolute positioning command can be executed. |
| `Cfg.SetAxisHomePostMoveTargetPosition(<int>,<float>)` | Set homing post movement target position * After successfull homing sequence an absolute positioning command can be executed. |
| `Cfg.SetAxisHomePostMvPos(<int>,<float>)` | Set homing post movement target position * After successfull homing sequence an absolute positioning command can be executed. |
| `Cfg.SetAxisHomeSeqId(<int>,<int>)` | Set homing sequence id for current encoder beeing configured. |
| `Cfg.SetAxisHomeSwitchEnable(<int>,<int>)` | Enable use of home sensor * Enable use of home sensor Will be automatically enabled if an EtherCAT entry is linked |
| `Cfg.SetAxisHomeSwitchPLCOverride(<int>,<int>)` | Override home switch with PLC code * If overridden then the home switch does not need to be linked instead the switch value must be set in plc code |
| `Cfg.SetAxisHomeVelOffCam(<int>,<float>)` | Set off cam referencing/homing velocity setpoint. |
| `Cfg.SetAxisHomeVelTowardsCam(<int>,<float>)` | Set Towards cam referencing/homing velocity setpoint. |
| `Cfg.SetAxisJerk(<int>,<float>)` | Set axis maximum jerk setpoint. |
| `Cfg.SetAxisJogVel(<int>,<float>)` | Set axis jog velocity setpoint. |
| `Cfg.SetAxisLimitSwitchBwdPLCOverride(<int>,<int>)` | Override bwd limit switch with PLC code * If overridden then the limit switch does not need to be linked instead the switch value must be set in plc code |
| `Cfg.SetAxisLimitSwitchFwdPLCOverride(<int>,<int>)` | Override fwd limit switch with PLC code * If overridden then the limit switch does not need to be linked instead the switch value must be set in plc code |
| `Cfg.SetAxisModRange(<int>,<float>)` | Set axis modulo range. |
| `Cfg.SetAxisModType(<int>,<int>)` | Set axis modulo motion type. |
| `Cfg.SetAxisMonAnalogInterlockPolarity(<int>,<int>)` | Set polarity of motion axis interlock from EtherCAT entry. |
| `Cfg.SetAxisMonAnalogInterlockRawLimit(<int>,<float>)` | Set analog interlock raw value limit . |
| `Cfg.SetAxisMonAnILPol(<int>,<int>)` | Set polarity of motion axis interlock from EtherCAT entry. |
| `Cfg.SetAxisMonAnILRawLim(<int>,<float>)` | Set analog interlock raw value limit . |
| `Cfg.SetAxisMonAtTargetTime(<int>,<int>)` | Set "at target" monitoring time (cycles). |
| `Cfg.SetAxisMonAtTargetTol(<int>,<float>)` | Set "at target" monitoring tolerance. |
| `Cfg.SetAxisMonCntrlOutHL(<int>,<float>)` | Set monitoring controller output high limit. |
| `Cfg.SetAxisMonEnableAnalogInterlock(<int>,<int>)` | Enable motion axis interlock from analog EtherCAT entry. |
| `Cfg.SetAxisMonEnableAtTargetMon(<int>,<int>)` | Enable "at target" monitoring. |
| `Cfg.SetAxisMonEnableCntrlOutHLMon(<int>,<int>)` | Enable controller output high limit monitoring. |
| `Cfg.SetAxisMonEnableEncsDiff(<int>,<int>)` | Enable monitoring diff of act. |
| `Cfg.SetAxisMonEnableExtHWInterlock(<int>,<int>)` | Enable motion axis interlock from EtherCAT entry. |
| `Cfg.SetAxisMonEnableLagMon(<int>,<int>)` | Enable position lag monitoring. |
| `Cfg.SetAxisMonEnableMaxVel(<int>,<int>)` | Enable maximum velocity monitoring (over speed). |
| `Cfg.SetAxisMonEnableStallMon(<int>,<int>)` | Enable stall monitoring. |
| `Cfg.SetAxisMonEnAnIL(<int>,<int>)` | Enable motion axis interlock from analog EtherCAT entry. |
| `Cfg.SetAxisMonExtHWInterlockPolarity(<int>,<int>)` | Set polarity of motion axis interlock from EtherCAT entry. |
| `Cfg.SetAxisMonHomeSwitchPolarity(<int>,<int>)` | Set polarity of home switch. |
| `Cfg.SetAxisMonLatchLimit(<int>,<int>)` | Set latch limit settings. |
| `Cfg.SetAxisMonLimitBwdPolarity(<int>,<int>)` | Set polarity of hard low limit switch. |
| `Cfg.SetAxisMonLimitFwdPolarity(<int>,<int>)` | Set polarity of hard high limit switch. |
| `Cfg.SetAxisMonMaxVel(<int>,<float>)` | Set maximum allowed velocity. |
| `Cfg.SetAxisMonPosLagTime(<int>,<int>)` | Set position lag monitoring time (cycles). |
| `Cfg.SetAxisMonPosLagTol(<int>,<float>)` | Set position lag maximum monitoring tolerance. |
| `Cfg.SetAxisMonStallMinTimeOut(<int>,<float>)` | Set stall monitong minimum time out. |
| `Cfg.SetAxisMonStallTimeFactor(<int>,<float>)` | Set stall monitong time factor. |
| `Cfg.SetAxisPLCEnable(<int>,<int>)` | Enable axis sync PLC expression. |
| `Cfg.SetAxisSeqTimeout(<int>,<int>)` | Set sequence timeout time in seconds. |
| `Cfg.SetAxisSoftLimitPosBwd(<int>,<float>)` | Set backward soft-limit position. |
| `Cfg.SetAxisSoftLimitPosFwd(<int>,<float>)` | Set forward soft-limit position. |
| `Cfg.SetAxisSrcChgEn(<int>,<int>)` | Allow change of encoder and trajectory source when axis is enabled |
| `Cfg.SetAxisTrajSourceType(<int>,<int>)` | Set axis trajectory data source. |
| `Cfg.SetAxisTrajStartPos(<int>,<float>)` | Set axis trajectory start position. |
| `Cfg.SetAxisTweakDist(<int>,<float>)` | Set axis tweak distance. |
| `Cfg.SetAxisVel(<int>,<float>)` | Set axis target velocity setpoint. |
| `Cfg.SetAxisVelAccDecTime(<int>,<float>,<float>)` | Set axis deceleration setpoint. |
| `Cfg.SetDiagAxisEnable(<int>)` | Enable detailed motion diagnostics printouts. |
| `Cfg.SetDiagAxisFreq(<int>)` | Set axis frequency of detailed motion diagnostics printouts. |
| `Cfg.SetDiagAxisIndex(<int>)` | Set axis index for detailed motion diagnostics. |
| `Cfg.SetPVTControllerTrgDurMs(<float>)` | Set duration of PVT (profile move) trigger output |
| `StopMotion(<int>)` | Stop axis. |
| `StopMotion(<int>,<int>)` | Stop axis. |

### Ethercat

| Command syntax | Description |
|---|---|
| `Cfg.EcAddDataDT(<str>,<int>,<int>,<int>,<str>,<str>)` | Adds a data item object to access data directly from EtherCAT domain. See [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md" >}}). |
| `Cfg.EcAddDomain(<int>,<int>)` | Add domain. See [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md" >}}). |
| `Cfg.EcAddEntryComplete(<int>,0x<hex>,0x<hex>,<int>,<int>,0x<hex>,0x<hex>,0x<hex>,<int>,<str>,<int>)` | Set update in realtime bit for an entry * If set to zero the entry will not be updated during realtime operation. |
| `Cfg.EcAddEntryDT(<int>,0x<hex>,0x<hex>,<int>,<int>,0x<hex>,0x<hex>,0x<hex>,<str>,<str>)` | Adds an EtherCAT slave to the hardware configuration. |
| `Cfg.EcAddEntryDT(<int>,0x<hex>,0x<hex>,<int>,<int>,0x<hex>,0x<hex>,0x<hex>,<str>,<str>,<int>)` | Adds an EtherCAT slave to the hardware configuration. |
| `Cfg.EcAddMemMap(<int>,<str>,<int>,<int>,<str>)` | Adds a memory map object to access data directly from EtherCAT domain. |
| `Cfg.EcAddMemMapDT(<str>,<int>,<int>,<str>,<str>)` | Adds a memory map object to access data directly from EtherCAT domain. |
| `Cfg.EcAddSdo(<int>,0x<hex>,0x<hex>,0x<hex>,<int>)` | Adds a Service Data Object for writing. |
| `Cfg.EcAddSdo(<int>,0x<hex>,0x<hex>,<int>,<int>)` | Adds a Service Data Object for writing. |
| `Cfg.EcAddSdoAsync(<int>,0x<hex>,0x<hex>,<str>,<str>)` | Adds an async SDO object. For the normal ecmccfg wrapper and resulting PVs, see [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md" >}}). |
| `Cfg.EcAddSdoBuffer(<int>,0x<hex>,0x<hex>,<str>,<int>)` | Adds a Service Data Object for writing. |
| `Cfg.EcAddSdoComplete(<int>,0x<hex>,<str>,<int>)` | Adds a Service Data Object for writing. |
| `Cfg.EcAddSdoDT(<int>,0x<hex>,0x<hex>,<str>,<str>)` | Adds a Service Data Object for writing. |
| `Cfg.EcAddSimEntry(<int>,<str>,<str>,%` | Adds a slave-scoped EtherCAT simulation entry. |
| `Cfg.EcAddSimEntry(<str>,<str>,%` | Adds a global EtherCAT simulation entry on the internal simulation slave. See [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md#simulation-entries" >}}). |
| `Cfg.EcAddSlave(<int>,<int>,0x<hex>,0x<hex>)` | Adds an EtherCAT slave to the hardware configuration. |
| `Cfg.EcApplyConfig(<int>)` | Apply hardware configuration to master. |
| `Cfg.EcEnablePrintouts(<int>)` | Enable diagnostic printouts from EtherCAT objects. |
| `EcGetMemMapId(<str>)` | Get index of a memmap object based on its name id string |
| `EcGetSlaveProductCode(<int>)` | Read product code of selected ethercat slave |
| `EcGetSlaveRevisionNum(<int>)` | revision number id of selected ethercat slave |
| `EcGetSlaveSerialNum(<int>)` | Read serial number of selected ethercat slave |
| `EcGetSlaveVendorId(<int>)` | Read vendor id of selected ethercat slave |
| `EcPrintSlaveConfig(<int>)=` | Prints hardware configuration for a selected slave. |
| `EcReadSdo(<int>,0x<hex>,0x<hex>,<int>)` | Write to a Service Data Object. |
| `Cfg.EcResetMaster(<int>)` | Retry configuring slaves for an selected EtherCAT master. |
| `Cfg.EcSelectReferenceDC(<int>,<int>)` | Select EtherCAT reference clock. |
| `Cfg.EcSetAllowOffline(<int>)` | Allow master to be offline |
| `Cfg.EcSetDelayECOkAtStartup(<int>)` | Delay ethercat OK status for a time * This can be useful to allow extra time for DC clocks to synchronize or for slaves that do not report correct data directly when entering OP. |
| `Cfg.EcSetDiagnostics(<int>)` | Enable EtherCAT bus diagnostics. |
| `Cfg.EcSetDomainAllowOffline(<int>)` | Allow domain to be offline. See [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md" >}}). |
| `Cfg.EcSetDomainFailedCyclesLimit(<int>)` | Set allowed bus cycles in row of none complete domain data transfer. See [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md" >}}). |
| `Cfg.EcSetEntryUpdateInRealtime(<int>,<str>,<int>)` | Set update in realtime bit for an entry * If set to zero the entry will not be updated during realtime operation. |
| `Cfg.EcSetMaster(<int>)` | Selects EtherCAT master to use. |
| `Cfg.EcSetSlaveEnableSDOCheck(<int>,<int>)` | Enable SDO setting check for a slave SDO setting check is default true for slaves linked to a motion axis. |
| `Cfg.EcSetSlaveNeedSDOSettings(<int>,<int>,<int>)` | Set bit that slave needs SDO settings * This slave needs SDO settings i.e. |
| `Cfg.EcSetSlaveSDOSettingsDone(<int>,<int>,<int>)` | Set bit that all SDOs has been set for this slave * After SDOs have been set this function should be called to tell ecmc that. |
| `Cfg.EcSlaveConfigDC(<int>,0x<hex>,<int>,<int>,<int>,<int>)` | Configure slave DC clock. See [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md" >}}). |
| `Cfg.EcSlaveConfigWatchDog(<int>,<int>,<int>)` | Configure Slave watch dog. |
| `Cfg.EcSlaveVerify(<int>,<int>,0x<hex>,0x<hex>)` | Verify slave at position * The command verifies that the actual slave at a certain position\ has the correct alias, position, vendor id, product code and revision number. See [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md" >}}). |
| `Cfg.EcSlaveVerify(<int>,<int>,0x<hex>,0x<hex>,0x<hex>)` | Verify slave at position * The command verifies that the actual slave at a certain position\ has the correct alias, position, vendor id, product code and revision number. See [Advanced EtherCAT and Commissioning]({{< relref "/manual/general_cfg/ethercat_advanced.md" >}}). |
| `Cfg.EcUseClockRealtime(<int>)` | Use CLOCK_REALTIME * Ecmc will as default use CLOCK_MONOTONIC as clock source both for the RT loop and the ethercat bus. |
| `Cfg.EcVerifySdo(<int>,0x<hex>,0x<hex>,0x<hex>,<int>)` | Verify a Service Data Object. |
| `Cfg.EcVerifySdo(<int>,0x<hex>,0x<hex>,<int>,<int>)` | Verify a Service Data Object. |
| `Cfg.EcWriteSdo(<int>,0x<hex>,0x<hex>,0x<hex>,<int>)` | Write to a Service Data Object. |
| `Cfg.EcWriteSdo(<int>,0x<hex>,0x<hex>,<int>,<int>)` | Write to a Service Data Object. |
| `Cfg.EcWriteSoE(<int>,<int>,<int>,<int>,%` | Write SoE |
| `Cfg.LinkEcEntryToEcStatusOutput(<int>,<str>)` | Links an EtherCAT entry to the ethecat master object for hardware status output * The output will be high when the EtherCAT master is without error code and otherwise zero. |
| `ReadEcEntryIndexIDString(<int>,<str>)` | Read the object Index of an entry addressed by slaveBusPosition and entryIdString. |
| `ReadEcSlaveIndex(<int>)` | Read the object Index of an slave addressed by slaveBusPosition. |
| `WriteEcEntry(<int>,<int>,<int>)` | Writes a value to an EtherCAT entry. |
| `Cfg.WriteEcEntryEcPath(<str>,%` | Writes a value to an EtherCAT entry addressed by an ethercat path . |
| `Cfg.WriteEcEntryIDString(<int>,<str>,%` | Writes a value to an EtherCAT entry addressed by slaveBusPosition and entryIdString. |

### Misc

| Command syntax | Description |
|---|---|
| `Cfg.ClearStorage(<int>)` | Clear data storage buffer. |
| `Cfg.CreateStorage(<int>,<int>,<int>)` | Create a data storage object. |
| `GetStorageDataIndex(<int>)` | Get current index of data in storage buffer. |
| `Cfg.LoadLUTFile(<int>,<str>)` | Load and create lookup table (LUT). See [Lookup Tables]({{< relref "/manual/general_cfg/lut.md" >}}). |
| `Cfg.PrintDataStorage(<int>)` | Print contents of buffer. |
| `ReadDataStorage(<int>)` | Reads contents of storage buffer. |
| `Cfg.SetDataStorageCurrentDataIndex(<int>,<int>)` | Set current data index of storage buffer. |
| `Cfg.SetStorageEnablePrintouts(<int>,<int>)` | Enable diagnostic printouts from data storage object. |
| `AppendDataStorage(<int>)=` | No public header brief found (parser-specific or undocumented). |
| `WriteDataStorage(<int>)=` | No public header brief found (parser-specific or undocumented). |

### PlC

| Command syntax | Description |
|---|---|
| `Cfg.AppendPLCExpr(<int>)=<str>` | Append Line to PLC expression. |
| `Cfg.ClearPLCExpr(<int>)` | Clear PLC expression. |
| `Cfg.CompilePLC(<int>)` | Compile PLC expression. |
| `Cfg.CreatePLC(<int>)` | Create a PLC object called. |
| `Cfg.CreatePLC(<int>,<float>)` | Create a PLC object called. |
| `Cfg.DeletePLC(<int>)` | Delete PLC. |
| `GetPLCEnable(<int>)` | Set enable of PLC. |
| `Cfg.LoadAxisPLCFile(<int>,<str>)` | Load PLC file. |
| `Cfg.LoadPLCFile(<int>,<str>)` | Load PLC file. |
| `Cfg.LoadPLCLibFile(<int>,<str>)` | Load PLC Libray to PLC. |
| `ReadPLCVar(<int>,<str>)` | Read PLC variable. |
| `Cfg.SetPLCEnable(<int>,<int>)` | Set enable of PLC. |
| `Cfg.SetPLCExpr(<int>)=<str>` | Set PLC expression. |
| `Cfg.SetPLCExpr(<int>,"<str>)` | Set PLC expression. |
| `WritePLCVar(<int>,<str>,<float>)` | Write to PLC variable. |

### Plugin

| Command syntax | Description |
|---|---|
| `Cfg.LoadPlugin(<int>,<str>)` | Load an ecmc plugin. See [Plugin Interface]({{< relref "/manual/plugins/interface.md" >}}). |
| `Cfg.LoadPlugin(<int>,<str>,<str>)` | Load an ecmc plugin. See [Plugin Interface]({{< relref "/manual/plugins/interface.md" >}}). |
| `Cfg.LoadSafetyPlugin(<str>,<str>)` | Load safety plugin to ecmc (executes just before data is sent to the bus). See [Plugin Interface]({{< relref "/manual/plugins/interface.md" >}}). |
| `Cfg.ReportPlugin(<int>)` | Printout details of a plugin. See [Plugin Interface]({{< relref "/manual/plugins/interface.md" >}}). |

### Parser/Internal

| Command syntax | Description |
|---|---|
| `ControllerErrorReset()` | No public header brief found (parser-specific or undocumented). |
| `Cfg.EcAddEntryComplete(<int>,0x<hex>,0x<hex>,<int>,<int>,0x<hex>,0x<hex>,0x<hex>,<int>,<int>,<str>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.EcAddEntryComplete(<int>,0x<hex>,0x<hex>,<int>,<int>,0x<hex>,0x<hex>,0x<hex>,<int>,<str>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.EcAddPdo(<int>,<int>,0x<hex>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.EcAddSyncManager(<int>,<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.EcApplyConfig()` | No public header brief found (parser-specific or undocumented). |
| `EcPrintAllHardware()` | No public header brief found (parser-specific or undocumented). |
| `EcReadSoE(<int>,<int>,<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.EcResetError()` | No public header brief found (parser-specific or undocumented). |
| `Cfg.EcWriteSdoComplete(<int>,0x<hex>,0x<hex>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.EcWriteSdoComplete(<int>,0x<hex>,<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `fAcceleration?` | No public header brief found (parser-specific or undocumented). |
| `fActPosition?` | No public header brief found (parser-specific or undocumented). |
| `fActVelocity?` | No public header brief found (parser-specific or undocumented). |
| `fDeceleration?` | No public header brief found (parser-specific or undocumented). |
| `fPosition?` | No public header brief found (parser-specific or undocumented). |
| `fVelocity?` | No public header brief found (parser-specific or undocumented). |
| `GetAxisAllowSourceChangeWhenEnabled(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisAutoDisableAfterTime(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisAutoEnableTimeout(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlDeadband(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlDeadbandTime(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlInnerKd(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlInnerKi(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlInnerKp(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlInnerTol(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlIPartHL(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlIPartLL(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlKd(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlKff(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlKi(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlKp(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlOutHL(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisCntrlOutLL(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisDrvBrakeCloseAheadTime(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisDrvBrakeEnable(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisDrvBrakeOpenDelayTime(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisDrvReduceTorqueEnable(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisDrvScaleDenom(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEmergDeceleration(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEnableConstVel(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEnableHome(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEnablePos(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncAbsBits(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncBits(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncDelayCompEnable(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncDelayCompTime(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncEnableRefAtHome(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncHomeIndex(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncLookupTableEnable(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncLookupTableRange(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncLookupTableScale(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncOffset(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncPosFilterEnable(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncPosFilterSize(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncRawMask(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncVelFilterEnable(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisEncVelFilterSize(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisHomeAcc(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisHomeDec(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisHomePosition(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisHomePostMoveEnable(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisHomePostMoveTargetPosition(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisHomeSeqId(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisJerk(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisJogVel(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisMonAnalogInterlockPolarity(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisMonAnalogInterlockRawLimit(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisMonAnalogInterlockRawValue(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisMonEnableAnalogInterlock(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisMonEnableStallMon(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisMonStallMinTimeOut(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisMonStallTimeFactor(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisMonStopAtAnyLimit(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisPLCExpr(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisSrcChgEn(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetAxisTweakDist(<int>)` | No public header brief found (parser-specific or undocumented). |
| `GetControllerError()` | No public header brief found (parser-specific or undocumented). |
| `GetControllerErrorMessage()` | No public header brief found (parser-specific or undocumented). |
| `GetPLCExpr(<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.IocshCmd=<str>` | No public header brief found (parser-specific or undocumented). |
| `Cfg.LinkEcEntryToObject(,)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.LinkEcEntryToObject(,<str>)` | No public header brief found (parser-specific or undocumented). |
| `ReadEcEntry(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `ReadEcEntryIDString(<int>,<str>)` | No public header brief found (parser-specific or undocumented). |
| `sErrorMessage?` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAppMode(<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisAutoResetError(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisCntrlInnerKd(<int>,<float>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisCntrlInnerKi(<int>,<float>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisCntrlInnerKp(<int>,<float>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisCntrlInnerTol(<int>,<float>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisDrvType(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisEnableConstVel(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisEnableHome(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisEnablePos(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisEncDelayCompEnable(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisEncDelayCompTime(<int>,<float>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisMonEnableVelocityDiff(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisMonMaxVelDriveILDelay(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisMonMaxVelTrajILDelay(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisMonStopAtAnyLimit(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisMonVelDiffDriveILDelay(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisMonVelDiffTol(<int>,<float>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisMonVelDiffTrajILDelay(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisPLCEncVelFilterEnable(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisPLCEncVelFilterSize(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisPLCTrajVelFilterEnable(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetAxisPLCTrajVelFilterSize(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetEcStartupTimeout(<int>)` | Set the maximum EtherCAT startup wait time in seconds before entering runtime. Default is 30 seconds. |
| `Cfg.SetSamplePeriodMs(<float>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetSampleRate(<float>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetTraceMask(<int>)` | No public header brief found (parser-specific or undocumented). |
| `Cfg.SetTraceMaskBit(<int>,<int>)` | No public header brief found (parser-specific or undocumented). |
