+++
title = "variables"
weight = 14
chapter = false
+++

Reference companion to [syntax]({{< relref "/manual/plc_cfg/syntax.md" >}}),
[patterns]({{< relref "/manual/plc_cfg/patterns.md" >}}), and
[best practice]({{< relref "/manual/plc_cfg/best_practice.md" >}}).

As a general rule, prefer PLC helper functions over direct raw variable access
when both are available. PLC variables are refreshed around each PLC scan,
while helper functions read current values directly. This is similar to other
PLC systems where the normal variable view is scan-based.

## variables

### generic
```text
 1.  static.<varname>             Static variable. Initialized to 0. (rw)
                                  Accessible only in the PLC where defined.
                                  Keeps its value between execution
                                  loops.
 2.  global.<varname>             Global variable. Initialized to 0. (rw)
                                  Accessible from all PLCs.
                                  Keeps its value between execution
                                  loops.
 3.  var <varname>                Local variable (exprtk syntax)   (rw)
                                  Does NOT keep its value between
                                  execution loops.
```

`static.<name>` variables are private to one PLC, while `global.<name>` variables
are shared between PLCs. Both can also be exposed as EPICS PVs; see
[best practice]({{< relref "/manual/plc_cfg/best_practice.md" >}}).

### EtherCAT
```text
  1.  ec<ecid>.s<sid>.<alias>      EtherCAT data               (rw)
                                   ecid:  EtherCAT master index
                                   sid:   EtherCAT slave bus position
                                   alias: entry name as defined in
                                          "Cfg.EcAddEntryComplete()
  2.  ec<ecid>.masterstatus        Status of master (1=OK)
```

### motion
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
 13. ax<id>.traj.setpos           current trajectory setpoint      (rw)
 14. ax<id>.traj.targetpos        target position                  (rw)
 15. ax<id>.traj.extsetpos        current trajectory setpoint from
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
 37. ax<id>.mon.attarget          axis at target                   (ro)
 38. ax<id>.mon.lowlim            low limit switch                 (ro)
 39. ax<id>.mon.highlim           high limit switch                (ro)
 40. ax<id>.mon.homesensor        home sensor                      (ro)
 41. ax<id>.mon.lowsoftlim        low soft limit                   (rw)
 42. ax<id>.mon.highsoftlim       high soft limit                  (rw)
 43. ax<id>.mon.lowsoftlimenable  low soft limit enable            (rw)
 44. ax<id>.mon.highsoftlimenable high soft limit enable           (rw)
 45. ax<id>.blockcom              Blocks active command-parser      (rw)
                                  "set" commands for this axis.
                                  Status and read commands still
                                  work.
                                  Same state as:
                                  - "Cfg.SetAxisBlockCom(axid,block)"
                                  - "GetAxisBlockCom(axid)"
                                  Exceptions ("set"-commands) that
                                  still work:
                                  - "StopMotion(axid)"
                                  - "StopMotion(axid,1)"
                                  - "Cfg.SetAxisBlockCom(axid,block)"
 46. ax<id>.ctrl.kp               Set PID-controller kp            (rw)
 47. ax<id>.ctrl.ki               Set PID-controller ki            (rw)
 48. ax<id>.ctrl.kd               Set PID-controller kd            (rw)
 49. ax<id>.ctrl.kff              Set PID-controller kff           (rw)
 50. ax<id>.mr.off                EPICS motor record OFF field     (ro)
                                  User coordinate offset.
 51. ax<id>.mr.dir                EPICS motor record DIR field     (ro)
                                  0: positive, 1: negative
 52. ax<id>.mr.loaded             EPICS motor record bound        (ro)
                                  0: not bound, 1: bound
                                  All three default to 0 before binding.
```

`ax<id>.blockcom` is a per-axis protection bit. It is independent of the
global parser runtime gate `Cfg.SetBlockCfgCmdsInRuntime(...)`, which instead
blocks most `Cfg.` commands after ecmc has entered runtime.

### PLC
```text
 1.  plc<id>.enable               plc enable                       (rw)
                                  (end exe with "plc<id>.enable:=0#"
                                  Could be useful for startup
                                  sequences)
 2.  plc<id>.dbg                  plc debug print enable           (rw)
                                  Intended only for debug print
                                  gating, for example:
                                  if(plc0.dbg) { println('...'); };
                                  See also PLC best practice for
                                  runtime debug usage.
 3.  plc<id>.error                plc error                        (rw)
                                  Will be forwarded to user as
                                  controller error.
 4.  plc<id>.scantime             plc sample time in seconds       (ro)
 5.  plc<id>.firstscan            true during first plc scan only  (ro)
                                  useful for initialization of variables
 6.  ax<id>.plc.enable            Same as plc<id>.enable but for
                                  axis <id> sync plc.
 7.  ax<id>.plc.error             Same as plc<id>.error but for
                                  axis <id> sync plc.
 8.  ax<id>.plc.scantime          Same as plc<id>.scantime but for
                                  axis<id> sync plc.
 9.  ax<id>.plc.firstscan         Same as plc<id>.firstscan but for
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
