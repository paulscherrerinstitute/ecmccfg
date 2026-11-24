+++
title = "Native target-write mode"
weight = 24
chapter = false
+++

This feature belongs to the native ECMC motion interface, independently of whether an EPICS motor record is loaded.

Native axes normally stage a target position and wait for an EXECUTE request.
The optional target-write mode starts an ABS or REL move when the target is
written. It is configured separately for each axis and is **disabled by default**.

{{% notice warning %}}
**The axis can move without EXECUTE when this mode is enabled.**

Writing the native target-position PV starts motion, similar to writing `.VAL`
on an EPICS motor record. Editing the target in a panel, writing it from a
script, or restoring it from a saved value is therefore a motion request—not
just preparation for a later execute command. Each accepted write triggers,
including an identical REL value written again. Configured auto-enable can
enable a disabled drive and start the move.
{{% /notice %}}

## Enable, query and disable

For axis 6, use these ECMC command strings:

```text
Cfg.SetAxisAutoExec(6,1)
GetAxisAutoExec(6)
Cfg.SetAxisAutoExec(6,0)
```

The query returns `1` for target-write mode and `0` for the default staged mode.
In an IOC startup script, opt in after creating and configuring the axis:

```iocsh
ecmcConfigOrDie "Cfg.SetAxisAutoExec(6,1)"
```

Selecting the mode does not execute an already staged target. Disabling the
mode restores separate target/execute handling; it **does not stop an active
move**. Use the normal native STOP command or `-StpCmd` PV to stop motion.

The longer names `SetAxisAutoExecuteOnTargetPos` and
`GetAxisAutoExecuteOnTargetPos` remain accepted aliases. Prefer the short names
over `MCU-Cmd.AOUT`, which has a 39-character usable string limit even when the
asyn record's `OMAX` is larger.

## Motion behavior

Configure the motion command, velocity, acceleration and deceleration before
writing a target. The supported command types are:

| Native command | Meaning of the written target |
| --- | --- |
| `3`: ABS | Absolute target position |
| `2`: REL | Relative distance using the existing relative-move semantics |

These native interfaces trigger motion in this mode:

- The axis `-TgtPosCmd` PV, linked to `ax6.targpos` for axis 6.
- The text command `Main.M6.fPosition=<value>`.
- The C API `setAxisTargetPos(6,value)`.

A write during an active position move of the same type retargets that move.
Requests during another motion type or pending enable/start preparation are
rejected rather than queued. Homing and velocity commands require their normal
trigger interfaces.

Motor-record `.VAL` behavior and internal PLC/sequencer setpoint updates are
unchanged. Enabling target-write mode does not turn a continuously updated PLC
setpoint into a new move every RT cycle.

## Auto-enable and interlocks

The existing axis auto-enable sequence is supported. For example:

```iocsh
ecmcConfigOrDie "Cfg.SetAxisAutoEnableTimeout(6,5)"
ecmcConfigOrDie "Cfg.SetAxisEnableAutoEnable(6,1)"
```

Motion waits for the normal drive enable acknowledgement and coordinated start
permission. With auto-enable disabled, a disabled axis rejects a target-triggered
move. The normal startup holds, command ownership, trajectory-source checks,
axis errors, limits and interlocks still apply.

## Panel indication and readback

`<axis-prefix>-AutoExecuteOnTargetPos-RB` reports the selected mode. For example,
`SIMSLIT:TR_HI-AutoExecuteOnTargetPos-RB` belongs to the TR_HI axis in that IOC.
It is a read-only indicator; use the configuration command to change the mode.

The main and native axis panels show a compact amber **NO EXEC** badge when the
mode is enabled. The expert panel shows **NO EXEC needed**. Hover over the badge
for the explanation that target writes start motion. The badge is hidden in
the default mode, where EXECUTE remains required.

The mode is status-word bit 24. Sequence state and last interlock now occupy
the low and next byte of `axN.status2`; its upper 16 bits are reserved. Install
matching ECMC and ecmccfg versions when adopting this status layout. Existing
`-SeqState` and `-LastIlock` PV names use the updated decoding.

For the existing motor-record interface, see
[Motor Record]({{< relref "/manual/motion_cfg/motor.md" >}}).
