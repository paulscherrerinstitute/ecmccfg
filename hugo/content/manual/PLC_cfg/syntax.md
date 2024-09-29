+++  
title = "syntax"
weight = 15
chapter = false  
+++

In `ECMC`, PLCs are based on the `exprtk` expression evaluation library.
For detailed syntax help please visit the [exprtk website](https://github.com/ArashPartow/exprtk)

## common errors, misconceptions and info
### operators
- `:=`: assignment
- `=` or `==`: equal comparison

### functions
PLC do _not_ immediately write to the bus!
The PLC will execute synchronous to the cycle, or at an integer fraction of it.
The processed data will be send to the bus with the next cycle.
PLCs do _not_ delay the bus!

### statement terminator
Statements are terminated by a semicolon `;`

### variables
All variables are initiated to `0`

### comments
The hash character `#` is reserved for comments.
Everything after this char will be removed before compile.
{{% notice warning %}}
`println('########');` will be seen by the compiler as `println('` !
{{% /notice %}}

### macros
{{% notice warning %}}
So far macro substitution is **not** implemented for `yaml`!
{{% /notice %}}

{{% notice tip %}}
If macro substitution is needed, please use the traditional approach using `loadPLCFile.cmd`, with the `PLC_MACROS` variable.
{{% /notice %}}

## examples

PLC can access:
- [variables](#variables)
- [process data](#process-data)
- [axis](#axis)
- [PLCs](#PLC)
- [data storage](#data-storage)

[Function](#functions) examples are given at the end.

{{% notice tip %}}
Custom function libs in exprtk syntax can be added and loaded to the PLC objects.
{{% /notice %}}

{{% notice tip %}}
Custom plc functions can be written in c in plugins.
{{% /notice %}}

### general

```text
  1. Assignment:
     ec0.s1.VALUE:=100;

  2. if-else (note the equal sign):
     if(ec0.s1.VALUE=100) {
       # code
     }
     else {
       # code
     };

   3. for loop:
     for (static.i := 0; static.i < static.elements; static.i += 1) {
       # code
     };

   4. printouts (minimize printouts or use only for debug):
      print("The value of ec0.s1.VALUE is: ",ec0.s1.VALUE);  # Without line feed
      println("The value of ec0.s1.VALUE is: ",ec0.s1.VALUE);  # With line feed

      Also see the "ec_print_bin()" and "ec_print_hex()" below.
```

### variables

#### generic
```text
 1.  static.<varname>             Static variable. Initiated to 0. (rw)                                    
                                  Access only in the PLC where defined.
                                  Will keep value between execution
                                  loops.
 2.  global.<varname>             Global variable. Initiated to 0. (rw)
                                  Access from all PLCs.
                                  Will keep value between execution
                                  loops.
 3.  var <varname>                Local variable (exprtk syntax)   (rw)
                                  Will NOT keep value between
                                  execution loops.
```

#### EtherCAT
```text
  1.  ec<ecid>.s<sid>.<alias>      ethetcat data                (rw)
                                   ecid:  ethercat master index
                                   sid:   ethercat slave bus position
                                   alias: entry name as defined in
                                          "Cfg.EcAddEntryComplete()
  2.  ec<ecid>.masterstatus        Status of master (1=OK)
```

#### motion
```text
 1.  ax<id>.id                    axis id                          (ro)
 2.  ax<id>.reset                 reset axis error                 (rw)
 3.  ax<id>.counter               execution counter                (ro)
 4.  ax<id>.error                 error                            (ro)
 5.  ax<id>.allowplccmd           Allow writes to axis from PLC    (rw)
 6.  ax<id>.enc.actpos            actual position                  (rw)
 7.  ax<id>.enc.extactpos         actual position from plc sync.
                                  expression                       (ro)
 8.  ax<id>.enc.actvel            actual velocity                  (ro)
 9.  ax<id>.enc.rawpos            actual raw position              (ro)
 10.  ax<id>.enc.source           internal source or expressions   (rw)
                                  source = 0: internal encoder
                                  source > 0: actual pos from expr
 11. ax<id>.enc.homed             encoder homed                    (rw)
 12. ax<id>.enc.homepos           homing position                  (rw)
 13. ax<id>.traj.setpos           curent trajectory setpoint       (rw)
 14. ax<id>.traj.targetpos        target position                  (rw)
 15. ax<id>.traj.extsetpos        current trajecrory setpoint from
                                  plc sync. expression             (rw) 
 16. ax<id>.traj.targetvel        target velocity setpoint         (rw)
 17. ax<id>.traj.targetacc        target acceleration setpoint     (rw)
 18. ax<id>.traj.targetdec        target deceleration setpoint     (rw)
 19. ax<id>.traj.setvel           current velocity setpoint        (ro)
 20. ax<id>.traj.setvelffraw      feed forward raw velocity        (ro)
 21. ax<id>.traj.command          command                          (rw)
                                  command=1: move velocity  
                                  command=2: move rel. pos
                                  command=3: move abs. pos
                                  command=10: homing
 22. ax<id>.traj.cmddata          cmddat. Homing procedure
                                  only valid if ax<id>.traj.command=10
                                  cmddata=1 : ref low limit
                                  cmddata=2 : ref high limit
                                  cmddata=3 : ref home sensor
                                              (via low limit)
                                  cmddata=4 : ref home sensor
                                              (via high limit)
                                  cmddata=5 : ref center of home sensor
                                              (via low limit)
                                  cmddata=6 : ref center of home sensor
                                              (via high limit)
                                  cmddata=15 : direct homing
                                  cmddata=21 : ref partly abs. encoder
                                               (via low limit).
                                               ref at abs bits.
                                               over/under-flow..
                                  cmddata=22 : ref partly abs. encoder
                                               (via high limit).
                                               ref at abs bits.
                                               over/under-flow..
 23. ax<id>.traj.source           internal source or expressions   (rw)
                                  source = 0: internal traj
                                  source > 0: setpoints from expr
 24. ax<id>.traj.execute          execute motion command           (rw)
 25. ax<id>.traj.busy             axis busy                        (ro)
 26. ax<id>.traj.dir              axis setpoint direction          (ro)
                                  ax<id>.traj.dir>0: forward
                                  ax<id>.traj.dir<0: backward
                                  ax<id>.traj.dir=0: standstill
 27. ax<id>.cntrl.error           actual controller error          (ro)
 28. ax<id>.cntrl.poserror        actual position error            (ro)
 29. ax<id>.cntrl.output          actual controller output         (ro)
 30. ax<id>.drv.setvelraw         actual raw velocity setpoint     (ro)
 31. ax<id>.drv.enable            enable drive command             (rw)
 32. ax<id>.drv.enabled           drive enabled                    (ro)
 33. ax<id>.seq.state             sequence state (homing)          (ro)
 34. ax<id>.mon.ilock             motion interlock (both dir)      (rw)
                                  ax<id>.mon.ilock=1: motion allowed
                                  ax<id>.mon.ilock=0: motion not allowed        
 35. ax<id>.mon.ilockbwd          motion interlock bwd dir         (rw)
                                  ax<id>.mon.ilockbwd=1: motion allowed
                                  ax<id>.mon.ilockbwd=0: motion not allowed        
 36. ax<id>.mon.ilockfwd          motion interlock fwd dir         (rw)
                                  ax<id>.mon.ilockfwd=1: motion allowed
                                  ax<id>.mon.ilockfwd=0: motion not allowed        
 37. ax<id>.mon.attarget          axis at taget                    (ro)
 38. ax<id>.mon.lowlim            low limit switch                 (ro)
 39. ax<id>.mon.highlim           high limit switch                (ro)
 40. ax<id>.mon.homesensor        home sensor                      (ro)
 41. ax<id>.mon.lowsoftlim        low soft limit                   (rw)
 42. ax<id>.mon.highsoftlim       high soft limit                  (rw)
 43. ax<id>.mon.lowsoftlimenable  low soft limit enable            (rw)
 44. ax<id>.mon.highsoftlimenable high soft limit enable           (rw)
 45. ax<id>.blockcom              Enables/disables "set" commands  (rw)
                                  via command parser (ascii commands)
                                  Statuses can still be read.
                                  Exceptions ("set"-commands) that 
                                  will work: 
                                  - "StopMotion(axid)"
                                  - "Cfg.SetAxisBlockCom(axid,block)"
 46. ax<id>.ctrl.kp               Set PID-controller kp            (rw)
 47. ax<id>.ctrl.ki               Set PID-controller ki            (rw)
 48. ax<id>.ctrl.kd               Set PID-controller kd            (rw)
 49. ax<id>.ctrl.kff              Set PID-controller kff           (rw)
```

#### PLC 
```text
 1.  plc<id>.enable               plc enable                       (rw)
                                  (end exe with "plc<id>.enable:=0#"
                                  Could be use full for startup
                                  sequences)
 2.  plc<id>.error                plc error                        (rw)
                                  Will be forwarded to user as
                                  controller error.
 3.  plc<id>.scantime             plc sample time in seconds       (ro)
 4.  plc<id>.firstscan            true during first plc scan only  (ro)
                                  use full for initiations of variables
 5.  ax<id>.plc.enable            Same as plc<id>.enable but for
                                  axis <id> sync plc.
 6.  ax<id>.plc.error             Same as plc<id>.error but for
                                  axis <id> sync plc.
 7.  ax<id>.plc.scantime          Same as plc<id>.scantime but for
                                  axis<id> sync plc.
 8.  ax<id>.plc.firstscan         Same as plc<id>.firstscan but for
                                  axis <id> sync plc.
```

### data storage
```text
 1.  ds<id>.size                  Set/get size of data storage     (rw)
                                  Set will clear the data storage
 2.  ds<id>.append                Add new data at end              (rw)
                                  Current position index will be
                                  increased
 3.  ds<id>.data                  Set/get data ar current position (rw)
 4.  ds<id>.index                 Set/get current position index   (rw)
 5.  ds<id>.error                 Data storage class error         (ro)
 6.  ds<id>.clear                 Data buffer clear (set to zero)  (ro)
 7.  ds<id>.full                  True if data storage is full     (ro)
```

### functions
####  EtherCAT
```text
  1. retvalue = ec_set_bit(
                          <value>,         : Value to change
                          <bitindex>       : Bit index 
                          );
     Sets bit at bitindex position of value. Returns the new value.
  
  2. retvalue = ec_wrt_bit(
                          <value>,         : Value to change
                          <wrtValue>,      : Value of bit to write
                          <bitindex>       : Bit index 
                          );
     Write wrtValue to a bit at bitindex position of value. Returns the new value.
  
  3. retvalue = ec_wrt_bits(
                          <value>,         : Value to change
                          <wrtValue>,      : Value of bit to write
                          <startBit>       : Start bit index (lsb is bit 0)
                          <stopBit>        : Stop bit index 
                          );
     Write wrtValue to a range of bits (statBit..stopBit) of value. Returns the new value.
  
  4. retvalue = ec_clr_bit(
                          <value>,         : Value to change
                          <bitindex>       : Bit index 
                          );
     Clears bit at bitindex position of value. Returns the new value.
  
  5. retvalue = ec_flp_bit(
                          <value>,         : Value to change
                          <bitindex>       : Bit index 
                          );
     Flips bit at bitindex position of value. Returns the new value.
  
  6. retvalue = ec_chk_bit(
                          <value>,         : Value to change
                          <bitindex>       : Bit index 
                          );
     Checks bit at bitindex position of value. Returns the value of bit.
  
  7. retvalue = ec_chk_bits(
                          <value>,         : Value to change
                          <startBit>       : Start bit index (lsb is bit 0)
                          <stopBit>        : Stop bit index 
                          );
     Checks range of bits (startBit..stopBit) of value. Returns the value of bits.
  
  8. retvalue = ec_print_hex(
                          <value>,         : Value to print
                          <startBit>       : Start bit index 
                          <stopBit>        : Stop bit index 
                          );
     Prints <startBit> to <stopBit> of <value> in hex format 
     Returns error code or 0 if success.
  
  9. retvalue = ec_print_bin(
                          <value>,         : Value to print
                          <startBit>       : Start bit index 
                          <stopBit>        : Stop bit index 
                          );
     Prints <startBit> to <stopBit> of <value> in bin format 
     Returns error code or 0 if success.
  
  10. retvalue = ec_mm_cp(
                          <srcId>,         : Source memmap index
                          <sdestId>        : Dest memmap index
                          );
     Copies data from source memmap to dest memmap. The memmap ids are defined by the 
     order they are created (starting at 0). The smallest memmap size will define the
     amount of data copied. Returns 0 for success or an error code.
  
     Note: The mmId can be retrieved by the bellow ecmc command (and feed into plc via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})
  
  
  11. retvalue = ec_get_mm_type(
                          <srcId>,         : Source memmap index
                          );
     Returns data type of memmap:
         0  = Not defined (Use "Cfg.EcAddMemMapDT()" instead of "Cfg.EcAddMemMap()")
         1  = (Not valid for memmap)
         2  = (Not valid for memmap)
         3  = (Not valid for memmap)
         4  = (Not valid for memmap)
         5  = U8
         6  = S8
         7  = U16
         8  = S16
         9  = U32
         10 = S32
         11 = U64
         12 = S64
         13 = F32
         14 = F64
  
     Note: The mmId can be retrived by the bellow ecmc command (and feed into plc via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})
  
  
  12. retvalue = ec_get_mm_data(
                          <srcId>,       : Source memmap index
                          <index>        : Index of data element 
                          );
     Reads data element at index from memmap with srcId and returns value.
  
     Note: The mmId can be retrived by the bellow ecmc command (and feed into plc via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})
  
  13. retvalue = ec_set_mm_data(
                          <srcId>,       : Source memmap index
                          <index>        : Index of data element 
                          <data>         : Data to write
                          );
     Writes data element at index from memmap with srcId. Returns 0 for success or an error code.
  
     Note: The mmId can be retrived by the bellow ecmc command (and feed into plc via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})
  
  14. retvalue = ec_get_mm_size(
                          <srcId>,       : Source memmap index
                          );
     Returns number of elements (of type "ec_get_mm_type()")in memmap with srcId. 
     If return value is less than zero it should be considered to be an error code.
  
     Note: The mmId can be retrived by the bellow ecmc command (and feed into plc via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})
  
  14. retvalue = ec_mm_ds_append(
                          <mmId>,       : Source memmap index
                          <dsId>);      : Destination data storage index
     Returns Error code or zero if success
  
     Note: The mmId can be retrived by the bellow ecmc command (and feed into plc via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})
  
  15. retvalue = ec_mm_append_to_ds_scale_offset(
                          <mmId>,       : Source memmap index
                          <dsId>        : Destination data storage index
                          <scale>       : Scale 
                          <offset>);    : Offset  
  
     Returns Error code or zero if success
  
     Note: The mmId can be retrived by the bellow ecmc command (and feed into plc via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})
  
  16. retvalue = ec_mm_push_asyn(
                        <mmId>)       : Source memmap index.
      push memap data to epics (can be used if T_SMP_MS=-1 for the param)
     Note: The mmId can be retrived by the bellow ecmc command (and feed into plc via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})
  
  17. retvalue = ec_get_time();
     Returns current time in nano seconds (from 1 Jan 2000, same as EtherCAT DC:s).
     If return value is less than zero it should be considered to be an error code.
  
  18. retvalue = ec_get_time_l32();
     Returns lower 32 bits of current time in nano seconds (from 1 Jan 2000, same as EtherCAT DC:s).
     If return value is less than zero it should be considered to be an error code.
  
  19. retvalue = ec_get_time_u32();
     Returns upper 32 bits of current time in nano seconds (from 1 Jan 2000, same as EtherCAT DC:s).
     If return value is less than zero it should be considered to be an error code.
  
  20. retvalue=ec_get_err():
      Returns error code from last lib call.
  
  21. retvalue=ec_err_rst():
      Resets error code for ec_lib.
```
  
#### Master to Master communication (within same host)

Support for communication between different ecmc ioc:s running on the same host.
A shared memory buffer of 120 doubles can be accessed for read and write operations by alll ecmc ioc running on the same master.

```text
 1. retvalue = m2m_write(
                       <index>,       : Mem buffer index (index must be 0..119)
                       <value>):      : value to write
    returns 0 if success or error code.
    Write a value to an index of a common memory buffer accessible by all masters running on same host
 
 2. retvalue = m2m_read(<index>);     : Mem buffer index (index must be 0..119)
                       
    returns the value stored at index in the shared mem buffer.
 
 3. retvalue = m2m_stat();
                       
    returns 1 if connection to shared memory is OK, else 0 or a negative value with an errro code.
 
 4. m2m_err_rst();
                       
    reset any m2m error codes.
 
 5. retvalue = m2m_err_rst();
                       
    returns current m2m error code.
 
 6. retvalue = m2m_ioc_ec_ok(<master_index>);
 
    returns status etehrcat status of another ecmc ioc (1==op, 0==not op, -1==error).
 
 7. retvalue = m2m_ioc_run(<master_index>);
 
    checks of a certian master is running (negative master id is ioc:s without ec master).
```

#### Motion
```text
 1. retvalue = mc_move_abs(
                       <axIndex>,       : Axis index
                         <execute>,       : Trigger
                         <pos>,           : Target position
                         <vel>,           : Target velocity
                         <acc>,           : Acceleration
                         <dec>            : Deceleration
                         ):
    Absolute motion of axis.
    Motion is triggerd with a positive edge on <execute> input.
    returns 0 if success or error code.
    
 2. retvalue = mc_move_rel(
                         <axIndex>,       : Axis index
                         <execute>,       : Trigger
                         <pos>,           : Target position
                         <vel>,           : Target velocity
                         <acc>,           : Acceleration
                         <dec>            : Deceleration
                         );
    Relative motion of axis <axIndex>.
    Motion is triggerd with a positive edge on <execute> input.
    returns 0 if success or error code.
 
 3. retvalue = mc_move_ext_pos(
                         <axIndex>,       : Axis index
                         <execute>,       : Trigger
                         <vel>,           : Target velocity
                         <acc>,           : Acceleration
                         <dec>            : Deceleration
                         );
    Move to current external plc position. Functions intended use is to 
    move to the start position for syncronized axes. This command is exactly 
    the same as issueing "mc_move_pos()" with the target postion ax<id>.traj.extsetpos.
    Motion is triggerd with a positive edge on <execute> input.
    returns 0 if success or error code.
 
 
 4. retvalue = mc_move_vel(
                         <axIndex>,       : Axis index
                         <execute>,       : Trigger
                         <vel>,           : Target velocity
                         <acc>,           : Acceleration
                         <dec>            : Deceleration
                         );
    Constant velocity motion of axis <axIndex>.
    Motion is triggerd with a positive edge on <execute> input.
    returns 0 if success or error code.
 
 5. retvalue = mc_home(
                         <axIndex>,       : Axis index
                         <execute>,       : Trigger
                         <seqId>,         : Motion sequence
                         <velTwoardsCam>, : Target Velocity twords cam
                         <velOffCam>      : Target velocity off cam
                         );
    Perform a homing sequence of axis <axIndex>.
    Motion is triggerd with a positive edge on <execute> input.
    returns 0 if success or error code.
 
 6. retvalue = mc_home_pos(
                      <axIndex>,       : Axis index
                      <execute>,       : Trigger
                      <seqId>,         : Motion sequence
                      <velTwoardsCam>, : Target Velocity twords cam
                      <velOffCam>      : Target velocity off cam
                      <homePos>        : Homing position
                      );
 Perform a homing sequence of axis <axIndex>
 Motion is triggerd with a positive edge on <execute> input.
 returns 0 if success or error code.
 
 7. retvalue = mc_halt(
                         <axIndex>,       : Axis index
                         <execute>,       : Trigger
                         );
    Stop motion of axis <axIndex>.
    Command is triggerd with a positive edge on <execute> input.
    returns 0 if success or error code.
 
 8. retvalue = mc_power(
                         <axIndex>,       : Axis index
                         <enable>,        : Enable power
                         );
    Enable power of  axis <axIndex>.
    Motion is triggerd with a positive edge on <execute> input.
    returns 0 if success or error code.
 
 9. retvalue = mc_get_busy(
                         <axIndex>,       : Axis index#                           
                         );
    Check if axis is busy.
    returns busy state of axis (1 if busy and 0 if not busy).
 
 10. retvalue = mc_get_homed(
                         <axIndex>,       : Axis index#                           
                         );
    Check if axis is homed.
    returns state of homed flag of axis (1 if homed and 0 if not homed).
 
 11. retvalue = mc_get_err();
    Returns error code for last lib call.
 
 12. retvalue = mc_reset(<axIndex>);
    Resets error of motion axis.
 
 13. retvalue = mc_get_axis_err(<axIndex>);
    Returns motion axis error code.
 
 14. retvalue = mc_set_enable_motion_funcs(
                         <axIndex>,         : Axis index
                         <enablePos>,       : Enable positioning
                         <enableVelo>,      : Enable const velo
                         <enableHome>,      : Enable const homing
                         );
 
    Enables/disables motion functionalities. Returns error code.
 
 15. retvalue = mc_get_act_pos(
                         <axIndex>,         : Axis index
                         <encIndex>         : Encoder index                        
                         );
 
    Returns encoder position for any of the configured encoders of an axis.
 
 16. retvalue = mc_set_prim_enc(
                         <axIndex>,         : Axis index
                         <encIndex>         : Encoder index                        
                         );
 
    Sets primary and homing encoder index of the axis (the encoder used for control). 
    The primary encoder can only be changed when the axis is not busy.
 
    Returns motion axis error code.
 
 17. retvalue = mc_get_prim_enc(
                         <axIndex>,         : Axis index        
                         );
 
    Returns primary encoder index of the axis (the encoder used for control).
 
 18. mc_set_axis_error(
                         <axis_id>,         : Axis index
                         <error_code>       : Error code to set
                         );
    
    Sets an arbitrary error code to an axis object.
 
 19. mc_set_slaved_axis_in_error(
                         <axis_id>,         : Axis index
                         );
    
    Set axis error that indicates that a slaved axis is in error state (ERROR_AXIS_SLAVED_AXIS_IN_ERROR 0x1432B).
```

#### Motion Group

```text
 1.  mc_grp_get_enable(
                      <grp_id>,         : Group index
                      );
    
    Returns true if all axes in the group have the enable bit set, else false.
    Note: The axes do not need to be enabled if this function returns true, see mc_grp_get_enabled().
 
 2.  mc_grp_get_any_enable(
                      <grp_id>,         : Group index
                      );
    
    Returns true if atleast one axis in the group has the enable bit set, else false.
 
 3.  mc_grp_get_enabled(
                      <grp_id>,         : Group index
                      );
    
    Returns true if all axes in the group are in enabled state, else false.
 
 4.  mc_grp_get_any_enabled(
                      <grp_id>,         : Group index
                      );
    
    Returns true if atleast one axis in the group is in enabled state, else false.
 
 5.  mc_grp_get_busy(
                      <grp_id>,         : Group index
                      );
    
    Returns true if all axes in the group are in busy state, else false.
 
 6.  mc_grp_get_any_busy(
                      <grp_id>,         : Group index
                      );
    
    Returns true if atleast one axis in the group is in busy state, else false.
 
 7.  mc_grp_get_any_error_id(
                      <grp_id>,         : Group index
                      );
    
    Returns error id if atleast one axis in the group is in error state, else zero.
 
 8.  mc_grp_set_enable(
                      <grp_id>,         : Group index
                      <enable>          : Enable state
                      );
    
    Sets enable for all axes in group.
    Returns 0 or error id.
 
 9.  mc_grp_set_traj_src(
                      <grp_id>,         : Group index
                      <source>          : Trajectory source (0 = internal, 1 = external/PLC )
                      );
    
    Sets trajectory source for all axes in group.
    Returns 0 or error id.
 
 10.  mc_grp_set_enc_src(
                      <grp_id>,         : Group index
                      <source>          : Encoder source (0 = internal, 1 = external/PLC )
                      );
    
    Sets encoder source for all axes in group.
    Returns 0 or error id.
 
 11.  mc_grp_reset_error(
                      <grp_id>,         : Group index
                      );
    
    Resets error of all axes in group.   
 
 12.  mc_grp_set_error(
                      <grp_id>,         : Group index
                      <error_id>        : Error Id
                      );
    
    Set error id of all axes in group.
 
 13.  mc_grp_set_slaved_axis_in_error(
                      <grp_id>,         : Group index
                      );
    
    Set error id of all axes in group to ERROR_AXIS_SLAVED_AXIS_IN_ERROR (0x1432B)
 
 14.  mc_grp_halt(
                      <grp_id>,         : Group index
                      );
    
    Halt all axes in group (only works if traj source = internal/0)
 
 15.  mc_grp_axis_in_grp(
                      <grp_id>,         : Group index
                      <axis_id>,        : Axis index
                      );
    
    Returns true if axis is in group, else false.
 
 16.  mc_grp_size(
                      <grp_id>,         : Group index
                      );
    
    Returns the number of axes in group.
 
 
 17.  mc_grp_get_traj_src_ext(
                       <grp_id>, : Group index
                       );
    
    Returns true if all axes in the group have trajectory source set to external.
 
 18.  mc_grp_get_any_traj_src_ext(
                       <grp_id>, : Group index
                       );
     Returns true if atleast one axis in the group have trajectory source set to external.
 
 19.  mc_grp_set_allow_src_change_when_enabled(
                       <grp_id>, : Group index
                       <allow>,  : Allow change of source
                       );
     Allow source change for trajectory and encoder when axis is enabled.

 20.  mc_grp_sync_act_set(
                       <grp_id>, : Group index
                       <sync>,   : Sync yes or no
                       );
     1. Sync ecmc current setpoint with actual value (if not enabled and internal mode)
     2. Sync MR at next poll (maximum once).
 
```

#### Data Storage
```text
 1. retvalue = ds_append_data(
                         <dsIndex>,       : Data storage index
                         <data>,          : Data
                         );
    Append data to data storage.
    returns 0 if success or error code.
 
 2. retvalue = ds_clear_data(
                         <dsIndex>,       : Data storage index
                         );
    Clear data to data storage.
    returns 0 if success or error code.
 
 3. retvalue = ds_get_data(
                         <dsIndex>,       : Data storage index
                         <bufferIndex>,   : Buffer index
                         );
    Returns data from buffer.
 
 4. retvalue = ds_set_data(
                         <dsIndex>,       : Data storage index
                         <bufferIndex>,   : Buffer index
                         );
    Sets data in data storage buffer.
    returns 0 if success or error code.
 
 5. retvalue = ds_get_buff_id(
                         <dsIndex>,       : Data storage index
                         );
    Returns current buffer index.
 
 6. retvalue = ds_set_buff_id(
                         <dsIndex>,       : Data storage index
                         <bufferIndex>,   : Buffer index
                         );
    Sets current buffer index in data storage buffer.
    returns 0 if success or error code.
 
 7. retvalue = ds_is_full(
                         <dsIndex>,       : Data storage index
                         );
    Returns true if buffer is full.
 
 8. retvalue = ds_get_size(
                         <dsIndex>,       : Data storage index
                         );
    Returns buffer size of data storage.
 
 9. retvalue = ds_get_err()
    Returns error code for last lib call.
 
 10. retvalue = ds_push_asyn(
                         <dsIndex>,       : Data storage index
                         );
    Triggers push of all asyn parameters in ds to EPICS (including data). 
 
 11. retvalue = ds_get_avg(
                         <dsIndex>,       : Data storage index
                         );
    Returns average of the values in the data storage.
 
 12. retvalue = ds_get_min(
                         <dsIndex>,       : Data storage index
                         );
    Returns minimum of the values in the data storage.
 
 13. retvalue = ds_get_max(
                         <dsIndex>,       : Data storage index
                         );
    Returns maximum of the values in the data storage.
 
 14. retvalue=ds_append_to_ds(
                         <dsFromId>,       : Source data storage index
                         <dsFromDataId>,   : Source data element index
                         <elements>,       : Number of elements to copy 
                         <dsToId>          : Destination data storage index
                         );
    Appends data at the current position of the destination data storage (dsToId). The data source is defined by (dsFromId) and the selected tion (dsFromDataId) and element count (elements).
 
 15. retvalue=ds_err_rst():
    Resets error code for ds_lib.
 
```
