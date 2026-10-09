+++
title = "RT Logger Diagnostics"
weight = 20
chapter = false
+++

## Scope

The RT logger diagnostics provide two related tools:

- filtered realtime messages showing what ecmc most recently reported
- motion diagnostics for determining where an axis command stopped progressing
- retained log buffers for configuration and runtime warnings/messages

Open **RT logger diagnostics** from `ecmcMain.ui`. Open the axis-specific
**Troubleshooting** panel from the axis expert or error/interlock panel.

## Retained Log Buffers

ecmc keeps retained log buffers for messages that should remain easy to inspect
after startup or during runtime troubleshooting. The buffers are independent of
the normal IOC console output:

- the configuration log buffer keeps messages generated while the IOC is in
  configuration mode
- the runtime log buffer keeps messages generated after ecmc has entered runtime

Each buffer stores timestamped messages with severity `INFO`, `WARNING`, or
`ERROR`. The buffers have a fixed size of 1024 rows; when a buffer is full, the
oldest row in that buffer is overwritten. This avoids unbounded memory growth
while preserving the most recent relevant diagnostics.

Use the iocsh command `ecmcLogBufferWrite(level,message)` to write a manual
message. The command writes to the configuration buffer before runtime and to
the runtime buffer after runtime has started. Use `ecmcLogBufferPrint()` and
`ecmcRtLogBufferPrint()` to print the configuration and runtime buffers.

## Realtime Messages

`Last message` is the most recent message accepted by the current level and
source filters. `Last level` is its severity. `Count` counts accepted messages,
while `Dropped` counts messages that could not be queued.

### Enabled Levels

The four buttons select which severities are accepted:

| Bit | Level | Numeric value |
|---:|---|---:|
| 0 | Info | 1 |
| 1 | Warning | 2 |
| 2 | Error | 4 |
| 3 | Debug | 8 |

The numeric control value is the sum of enabled bits. For example, Info,
Warning, and Error produce `7`; all levels produce `15`. Normally use Info,
Warning, and Error. Enable Debug only while investigating a specific problem.

### Source Filter

The source filter has three modes:

| Mode | Behavior |
|---|---|
| Off | Reject all messages. |
| All sources | Accept enabled levels from every source. Source mask and index are ignored. |
| Selected | Accept enabled levels only when the source mask and source index match. |

Use **All sources** for general troubleshooting. Use **Selected** only when the
message rate is high or one axis/object must be isolated.

In Selected mode, source index `-1` accepts every index. A non-negative index
selects one axis, PLC, EtherCAT source, or other indexed object.

### Source Mask

Click source bits in the horizontal controller. The decimal mask is retained for
scripts and exact readback.

| Bit | Value | Source |
|---:|---:|---|
| 0 | 1 | Unknown |
| 1 | 2 | Axis family |
| 2 | 4 | Axis base |
| 3 | 8 | Axis sequencer |
| 4 | 16 | Axis data |
| 5 | 32 | Axis monitor |
| 6 | 64 | Axis encoder |
| 7 | 128 | Axis drive |
| 8 | 256 | Axis PID |
| 9 | 512 | Axis trajectory |
| 10 | 1024 | Axis PVT |
| 11 | 2048 | Motor family |
| 12 | 4096 | Motor-record axis |
| 13 | 8192 | Motor controller |
| 14 | 16384 | Master/slave state machine |
| 15 | 32768 | EtherCAT |
| 16 | 65536 | PLC |

Axis-family bit 1 matches every axis subtype. Motor-family bit 11 matches both
motor subtypes. Selecting a subtype bit matches only that subtype.

Example: to inspect all axis messages for axis 3, select mode `Selected`, source
bit 1, and source index `3`.

## Motion Diagnostic Dump

Set `Axis` to the ecmc axis index. `Axis rpt` immediately summarizes the axis
command, request/execute counters, state, and detected blockers.

Press `Dump` to request a YAML snapshot. File creation runs in the RT logger
worker thread, not in the realtime motion thread. The generated path is reported
in `File` and has this form:

```text
/tmp/ecmc_motion_diag_<pid>_<timestamp>.yaml
```

`DiagLevel` controls the amount of information:

| Level | Contents |
|---:|---|
| 0 | Compact metadata and object counts. |
| 1 | Metadata, analyzed axis/group/master-slave state, blockers, findings, and both log buffers. |
| 2 | Level 1 plus a second YAML document containing the complete raw state of all motion objects and their member variables. |

Level 2 includes axis internals, encoder, monitor, trajectory, controller,
drive, motor-record adapter, axis groups, PVT, and master/slave state machines.
Creating that snapshot briefly holds the ecmc realtime mutex while the state is
formatted, so use level 2 for diagnostics rather than cyclic acquisition.

Levels 1 and 2 include non-destructive snapshots of the configuration log
buffer and the runtime/debug log buffer. Each entry contains its sequence,
timestamp, severity, and message. Runtime entries also contain source type and
source index. Up to the existing 1024 entries from each buffer are included.

## Axis Command Counters

For an axis such as `M1`, the troubleshooting records use the axis prefix:

| PV suffix | Meaning |
|---|---|
| `-MtnCmdMrReqCnt` | Command arrived at the motor-record adapter. |
| `-MtnCmdReqCnt` | An ecmc axis motion function or momentary control-word command arrived. |
| `-MtnCmdExecCnt` | A real execute attempt reached `setExecute(true)`. |
| `-MtnCmdMrLastType` | Last motor-record command type. |
| `-MtnCmdMrLastRslt` | Accepted, rejected, ignored, or deferred. |
| `-MtnCmdMrLastRsn` | Decoded reason for the result. |
| `-MtnCmdMrLastErr` | Associated ecmc error code. |
| `-MtnCmdMrLastCyc` | Realtime cycle of the result. |
| `-MtnCmdMrLastTxt` | Combined human-readable result. |
| `-MtnMsBlk` | Axis is currently blocked by master/slave ownership. |
| `-MtnMsBlkCnt` | Number of master/slave block/unblock transitions. |
| `-MtnMsBlkCyc` | Cycle of the last master/slave block transition. |
| `-MtnMsBlkTxt` | Human-readable master/slave block state. |
| `-MtnCmdClr` | Clear counters and remembered diagnostic fields. |

Motor-record STOP and enable commands are excluded from the counters by default
because normal motor operation can generate them frequently. Use
`-MtnCmdCntMrStop` and `-MtnCmdCntEna` when those commands are relevant.

## Motion Does Not Start

Clear the counters, issue exactly one command, and compare the three stages:

1. `MtnCmdMrReqCnt` did not increase: the command did not reach the motor-record
   adapter. Check Channel Access, the motor record, and the selected axis.
2. Motor-record count increased but `MtnCmdReqCnt` did not: inspect
   `MtnCmdMrLastRslt`, `MtnCmdMrLastRsn`, and `MtnCmdMrLastTxt`.
3. Request count increased but `MtnCmdExecCnt` did not: inspect the axis report
   for busy state, command blocking, master/slave ownership, trajectory source,
   auto-enable, limits, and interlocks.
4. Execute count increased but motion did not start: create a diagnostic dump
   and inspect axis, group, sequencer, and master/slave state together.

For commands sent directly through the ecmc axis interface, including absolute,
relative, homing, and tweak commands, start at `MtnCmdReqCnt`; no motor-record
request is expected.

## Main PVs

The general records use the IOC prefix:

```text
$(IOC):MCU-RTLog-Msg
$(IOC):MCU-RTLog-Level
$(IOC):MCU-RTLog-Ctrl
$(IOC):MCU-RTLog-FilterMode
$(IOC):MCU-RTLog-FilterMode-Txt
$(IOC):MCU-RTLog-FilterMask
$(IOC):MCU-RTLog-FilterIndex
$(IOC):MCU-RTLog-DiagAxis
$(IOC):MCU-RTLog-DiagAxisRpt
$(IOC):MCU-RTLog-DiagLevel
$(IOC):MCU-RTLog-DiagDump
$(IOC):MCU-RTLog-DiagBusy
$(IOC):MCU-RTLog-DiagStatus
$(IOC):MCU-RTLog-DiagFile
```

## Related Pages

- [Troubleshooting]({{< relref "/manual/knowledgebase/troubleshooting.md" >}})
- [Motion troubleshooting]({{< relref "/manual/knowledgebase/motion.md" >}})
- [Master/slave state machine]({{< relref "/manual/general_cfg/master_slave_state_machine.md" >}})
