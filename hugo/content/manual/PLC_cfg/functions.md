+++
title = "functions"
weight = 16
chapter = false
+++

Reference companion to [syntax]({{< relref "/manual/PLC_cfg/syntax.md" >}}),
[variables]({{< relref "/manual/PLC_cfg/variables.md" >}}), and
[patterns]({{< relref "/manual/PLC_cfg/patterns.md" >}}).

Most PLC helper functions follow a clear prefix:

- `ec_...`: EtherCAT and process-image helpers
- `m2m_...`: communication between ecmc IOCs on the same host
- `mc_...`: single-axis motion helpers
- `mc_grp_...`: motion-group helpers
- `ds_...`: data-storage helpers
- `lut_...`: lookup-table helpers
- `epics_...`: EPICS runtime state helpers
- `system_...`: combined system state helpers

Use your browser search for these prefixes when you already know the category.

## functions

### EtherCAT
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
     Write wrtValue to a range of bits (startBit..stopBit) of value. Returns the new value.

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

     Note: The mmId can be retrieved by the below ecmc command (and fed into PLC via macro):
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

     Note: The mmId can be retrieved by the below ecmc command (and fed into PLC via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})

  12. retvalue = ec_get_mm_data(
                          <srcId>,       : Source memmap index
                          <index>        : Index of data element
                          );
     Reads data element at index from memmap with srcId and returns value.

     Note: The mmId can be retrieved by the below ecmc command (and fed into PLC via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})

  13. retvalue = ec_set_mm_data(
                          <srcId>,       : Source memmap index
                          <index>        : Index of data element
                          <data>         : Data to write
                          );
     Writes data element at index from memmap with srcId. Returns 0 for success or an error code.

     Note: The mmId can be retrieved by the below ecmc command (and fed into PLC via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})

  14. retvalue = ec_get_mm_size(
                          <srcId>,       : Source memmap index
                          );
     Returns number of elements (of type "ec_get_mm_type()")in memmap with srcId.
     If return value is less than zero it should be considered to be an error code.

     Note: The mmId can be retrieved by the below ecmc command (and fed into PLC via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})

  15. retvalue = ec_mm_append_to_ds(
                          <mmId>,       : Source memmap index
                          <dsId>);      : Destination data storage index
     Returns Error code or zero if success

     Note: The mmId can be retrieved by the below ecmc command (and fed into PLC via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})

  16. retvalue = ec_mm_append_to_ds_scale_offset(
                          <mmId>,       : Source memmap index
                          <dsId>        : Destination data storage index
                          <scale>       : Scale
                          <offset>);    : Offset

     Returns Error code or zero if success

     Note: The mmId can be retrieved by the below ecmc command (and fed into PLC via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})

  17. retvalue = ec_mm_push_asyn(
                        <mmId>)       : Source memmap index.
      push memap data to epics (can be used if T_SMP_MS=-1 for the param)
     Note: The mmId can be retrieved by the below ecmc command (and fed into PLC via macro):
        ecmcConfig "EcGetMemMapId(ec0.s11.mm.analogInputArray01)"
        epicsEnvSet(MM_CH_1_IN,${ECMC_CONFIG_RETURN_VAL})

  18a. retvalue = ec_get_time();
     Returns the current clock time when the PLC calls the function, in nano
     seconds (from 1 Jan 2000, same as EtherCAT DC:s). This is not a cached
     EtherCAT receive or send timestamp.
     If return value is less than zero it should be considered to be an error code.

  18a. retvalue = ec_get_last_receive_time();
     Returns the cached timestamp of the receive phase in the current EtherCAT
     application cycle. Calling this function does not read the clock.
     If return value is less than zero it should be considered to be an error code.

  18b. retvalue = ec_get_last_send_time();
     Returns the cached timestamp of the most recently completed EtherCAT send
     phase. Because PLCs execute before send, this normally refers to the
     preceding application cycle. Calling this function does not read the clock.
     If return value is less than zero it should be considered to be an error code.

  19. retvalue = ec_get_time_l32();
     Returns lower 32 bits of current time in nano seconds (from 1 Jan 2000, same as EtherCAT DC:s).
     If return value is less than zero it should be considered to be an error code.

  20. retvalue = ec_get_time_u32();
     Returns upper 32 bits of current time in nano seconds (from 1 Jan 2000, same as EtherCAT DC:s).
     If return value is less than zero it should be considered to be an error code.

  21. retvalue = ec_get_time_frm_src(
                             <clock_src_id>);  : System dependent clock id. Normally CLOCK_REALTIME=0, CLOCK_MONOTONIC=1.

     Returns current time in nano seconds for a certain clock source defined by clock_id.
     (from 1 Jan 2000, same as EtherCAT DC:s).
     If return value is equal or less than zero it should be considered to be an error.

  22. retvalue = ec_get_time_offset_mono():

     Returns current time offset in nano seconds if selected clock source is CLOCK_MONOTONIC, otherwise 0.

  23. retvalue = ec_get_time_local_hour(
                             <ns_since_ec_epoch>);  : Nano seconds since jan 1:st 2000.
                  returns the hours part, 0..23, of the nano second counter (removes years, months , days),

  24. retvalue = ec_get_time_local_min(
                             <ns_since_ec_epoch>);  : Nano seconds since jan 1:st 2000.
                  returns the minutes part, 0..59, within the hour,

  25. retvalue = ec_get_time_local_sec(
                             <ns_since_ec_epoch>);  : Nano seconds since jan 1:st 2000.
                  returns the seconds part, 0..59, within the minute,

  26. retvalue = ec_get_time_local_nsec(
                             <ns_since_ec_epoch>);  : Nano seconds since jan 1:st 2000.
                  returns the nanoseconds part, 0..1E9-1, within the second,

  27. retvalue = ec_get_dom_state(
                             <domain_id>);  : Id for domain
                  returns 1 if domain communication is ok, 0 if not and -1 if error (domain id out of range).

  28. retvalue=ec_get_err():
      Returns error code from last lib call.

  29. retvalue=ec_err_rst():
       Resets error code for ec_lib.
```

### Master to Master communication (within same host)

Support for communication between different ecmc ioc:s running on the same host.
A shared memory buffer of 120 doubles can be accessed for read and write operations by all ecmc IOCs running on the same master.

```text
 1. retvalue = m2m_write(
                       <index>,       : Mem buffer index (index must be 0..119)
                       <value>):      : value to write
    returns 0 if success or error code.
    Write a value to an index of a common memory buffer accessible by all masters running on same host

 2. retvalue = m2m_read(<index>);     : Mem buffer index (index must be 0..119)

    returns the value stored at index in the shared mem buffer.

 3. retvalue = m2m_stat();

    returns 1 if connection to shared memory is OK, else 0 or a negative value with an error code.

 4. m2m_err_rst();

    reset any m2m error codes.

 5. retvalue = m2m_err_rst();

    returns current m2m error code.

 6. retvalue = m2m_ioc_ec_ok(<master_index>);

    returns status ethercat status of another ecmc ioc (1==op, 0==not op, -1==error).

 7. retvalue = m2m_ioc_run(<master_index>);

    checks if a certain master is running (negative master id is IOCs without EC master).
```

### Motion
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
    Motion is triggered with a positive edge on <execute> input.
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
    Motion is triggered with a positive edge on <execute> input.
    returns 0 if success or error code.

 3. retvalue = mc_move_ext_pos(
                         <axIndex>,       : Axis index
                         <execute>,       : Trigger
                         <vel>,           : Target velocity
                         <acc>,           : Acceleration
                         <dec>            : Deceleration
                         );
    Move to current external plc position. Functions intended use is to
    move to the start position for synchronized axes. This command is exactly
    the same as issuing "mc_move_pos()" with the target position ax<id>.traj.extsetpos.
    Motion is triggered with a positive edge on <execute> input.
    returns 0 if success or error code.

 4. retvalue = mc_move_vel(
                         <axIndex>,       : Axis index
                         <execute>,       : Trigger
                         <vel>,           : Target velocity
                         <acc>,           : Acceleration
                         <dec>            : Deceleration
                         );
    Constant velocity motion of axis <axIndex>.
    Motion is triggered with a positive edge on <execute> input.
    returns 0 if success or error code.

 5. retvalue = mc_home(
                         <axIndex>,       : Axis index
                         <execute>,       : Trigger
                         <seqId>,         : Motion sequence
                         <velTwoardsCam>, : Target velocity towards cam
                         <velOffCam>      : Target velocity off cam
                         );
    Perform a homing sequence of axis <axIndex>.
    Motion is triggered with a positive edge on <execute> input.
    returns 0 if success or error code.

 6. retvalue = mc_home_pos(
                      <axIndex>,       : Axis index
                      <execute>,       : Trigger
                      <seqId>,         : Motion sequence
                      <velTwoardsCam>, : Target velocity towards cam
                      <velOffCam>      : Target velocity off cam
                      <homePos>        : Homing position
                      );
 Perform a homing sequence of axis <axIndex>
 Motion is triggered with a positive edge on <execute> input.
 returns 0 if success or error code.

 7. retvalue = mc_halt(
                         <axIndex>,       : Axis index
                         <execute>,       : Trigger
                         );
    Stop motion of axis <axIndex>.
    Command is triggered with a positive edge on <execute> input.
    returns 0 if success or error code.

 8. retvalue = mc_power(
                         <axIndex>,       : Axis index
                         <enable>,        : Enable power
                         );
    Enable power of  axis <axIndex>.
    
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
                         <encIndex>         : Encoder index (starts from 1)
                         );

    Returns encoder position for any of the configured encoders of an axis.

 15a. retvalue = mc_get_touch_probe_pos(
                         <axIndex>,         : Axis index
                         <encIndex>         : Encoder index (starts from 1)
                         );

    Returns the last hardware-latched position after the encoder object's
    masking, multiturn conversion, scaling, and engineering offset.

 15b. retvalue = mc_get_touch_probe_sequence(
                         <axIndex>,         : Axis index
                         <encIndex>         : Encoder index (starts from 1)
                         );

    Returns a counter incremented for each new hardware-latched position.

 16. retvalue = mc_set_act_pos(
                         <axIndex>,         : Axis index
                         <encIndex>         : Encoder index (starts from 1)
                         <position>         : position to set
                         );

    NOTE: Preferably executed when axis is disabled.
    Returns 0 or error code.

 17. retvalue = mc_get_enc_ready(
                         <axIndex>,         : Axis index
                         <encIndex>         : Encoder index (starts from 1)
                         <position>         : position to set
                         );

    Returns 1 if encoder is ready, otherwise 0

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

 18.  mc_set_enc_homed(
                       <axis_id>,    : Axis index
                       <encoder_id>, : Encoder index
                       <homed>,      : Homed (value to set)
                      );
     Sets homed bit of a certain encoder. Returns error code.

 19.  mc_get_enc_homed(
                       <axis_id>,    : Axis index
                       <encoder_id>, : Encoder index
                      );
     Returns homed bit of a certain encoder or an error code (negative number)

 20. mc_set_axis_error(
                         <axis_id>,         : Axis index
                         <error_code>       : Error code to set
                         );

    Sets an arbitrary error code to an axis object.

 21. mc_set_slaved_axis_in_error(
                         <axis_id>,         : Axis index
                         );

    Set axis error that indicates that a slaved axis is in error state (ERROR_AXIS_SLAVED_AXIS_IN_ERROR 0x1432B).

 22.  mc_mr_set_sync(
                       <axis_id>, : Axis index
                       <sync>,    : Sync yes or no (1 or 0)
                       );
     1. Sync ecmc current setpoint with actual value (if not enabled and internal mode)
     2. Execute a motor record SYNC
     Note: The command only triggers once per ecmc cycle (with the latest value written to sync)

 23.  mc_mr_set_stop(
                       <axis_id>, : Axis index
                       <stop>,    : Stop yes or no (1 or 0)
                       );
     1. Execute a motor record STOP
     Note: The command only triggers once per ecmc cycle (with the latest value written to stop)

 24.  mc_mr_set_cnen(
                       <axis_id>, : Axis index
                       <enable>,  : Enable yes or no (1 or 0)
                       );
     1. Enable/disable motor record via CNEN field
     Note: The command only triggers once per ecmc cycle (with the latest value written to enable)

  25. error = mc_set_traj_vel(
                            <axIndex>,  : Axis index
                            <vel>       : Target velocity
                            );
  Set target velocity.

  26. error = mc_set_traj_acc(
                            <axIndex>,  : Axis index
                            <acc>       : Max acceleration
                            );
  Set max acceleration.

  27. error = mc_set_traj_dec(
                            <axIndex>,  : Axis index
                            <dec>       : Max deceleration
                            );
  Set max deceleration.
  note: mc_set_traj_dec() is only valid for trapez trajectory (trajectory.type=0). For s-curve trajectory mc_set_traj_acc() is used for both acceleration and deceleration.

  28. error = mc_set_traj_jerk(
                            <axIndex>,  : Axis index
                            <jerk>      : Max jerk
                            );
  Set max jerk.
  note: mc_set_traj_jerk() is only valid for s-curve trajectory (ruckig, trajectory.type=1)

  29. error = mc_ctrl_i_reset(
                            <axisid>,   : Axis index
                            <reset>     : Reset integral part when nonzero
                            );
  Resets the PID controller integral (I) part to zero when reset is nonzero.
  Returns 0 on success or an error code if the axis is invalid.
```

### Motion Group

Use [Axis Groups]({{< relref "/manual/general_cfg/axis_groups.md" >}}) to define the groups that these functions operate on.

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

 20.  mc_grp_mr_set_sync(
                       <grp_id>, : Group index
                       <sync>,   : Sync yes or no (1 or 0)
                       );
     1. Sync ecmc current setpoint with actual value (if not enabled and internal mode)
     2. Execute a motor record SYNC
     Note: The command only triggers motor record maximum once per ecmc cycle (with the latest value written to sync)

 21.  mc_grp_mr_set_stop(
                       <grp_id>, : Group index
                       <stop>,   : Stop yes or no (1 or 0)
                       );
     1. Execute a motor record STOP
     Note: The command only triggers motor record maximum once per ecmc cycle (with the latest value written to stop)

 22.  mc_grp_mr_set_cnen(
                       <grp_id>, : Group index
                       <enable>, : Enable yes or no (1 or 0)
                       );
     1. Enable/disable motor record via CNEN field
     Note: The command only triggers motor record maximum once per ecmc cycle (with the latest value written to enable)

 23.  mc_grp_set_ignore_mr_status_check_at_disable(
                                                   <grp_id>, : Group index
                                                   <ignore>, : Ignore 1/0
                                                   );
     Ignore check of status when mr is disabling (avoid enableAmplifier(xx) failed") error

 23.  mc_grp_get_any_at_fwd_limit(
                                  <grp_id>, : Group index
                                  );
     Returns true if any axis in the group is at a fwd limit switch, otherwise false.

 24.  mc_grp_get_any_at_bwd_limit(
                       <grp_id>, : Group index
                       );
     Returns true if any axis in the group is at a bwd limit switch, otherwise false.

 25.  mc_grp_get_any_at_limit(
                       <grp_id>, : Group index
                       );
     Returns true if any axis in the group is at a limit switch, otherwise false.

 26.  mc_grp_set_slaved_axis_ilocked(
                       <grp_id>, : Group index
                       );
     Set slaved axis in interlock error.
```

### Data Storage
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

### Lookup tables
```text
 1.  value = lut_get_value(
                         <lutObjIndex>,       : Lookup table object index
                         <index>              : Index to which a value should be interpolated
                         );

   Returns an interpolated value from the lookup table object, with "lutObjIndex", for the position "index".
```

### Misc
```text
 1.  value = epics_get_started()

   Returns 1 if EPICS has reached the IOC-running state, otherwise 0.

 2.  value = epics_get_state()

   Returns the numeric EPICS initialization-hook state.

 3.  value = ec_get_started()

   Returns 1 only when an EtherCAT master is configured, ECMC has completed
   runtime startup, and the EtherCAT master status is OK. Returns 0 while the
   bus is starting, when it is not operational, or when no master is configured.

 4.  value = system_get_started()

   Returns 1 only when both epics_get_started() and ec_get_started() return 1.
   Use this as the normal readiness check for PLC logic that depends on both
   EPICS initialization and operational EtherCAT communication.
```

Example startup gate:

```text
if(system_get_started()) {
  # Logic requiring both EPICS and EtherCAT readiness
};
```

`system_get_started()` is intentionally strict: it remains 0 for an ECMC IOC
configured without an EtherCAT master. Use `epics_get_started()` when the logic
only depends on EPICS initialization.
