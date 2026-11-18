+++
title = "Motor position and soft-limit autosave"
weight = 24
chapter = false
+++

## Scope and required support

Motor position restoration and soft-limit restoration are separate features.
This page describes the ECMC motor-record startup restore implementation and its
startup gate. Use an ECMC build containing that implementation; adding an option
to YAML does not add support to an older binary.

For the complete incremental stepper setup, see
[the stepper_openloop_asr example](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_openloop_asr).

## Enable soft-limit restoration in YAML

```yaml
epics:
  name: Axis1
  motorRecord:
    restoreSoftLimits: true
    syncSoftLimits: true  # false keeps the restored pair motor-local
```

`restoreSoftLimits` is a startup-only policy. `syncSoftLimits` remains
runtime-configurable. With restore enabled and sync disabled, autosave-restored
motor limits remain local and enabled ECMC limits bound them without being
modified. With both enabled, the restored pair is copied to ECMC and ongoing
synchronization is enabled.

For backward compatibility, advanced configurations may still put
`restoreMotorSoftLims=1` in `axis.parameters`; mode 1 restores into ECMC and
forces synchronization. Internal mode 2 performs motor-local restoration.
Normal YAML configurations should use the two booleans above rather than these
numeric driver modes.

Without the restore option, ECMC seeds the motor's limits from its configured
limits at startup. Saving the motor limit fields alone does not make restored
values authoritative in that mode.

After changing soft limits, reload any open caQtDM panels. Numeric input widgets,
such as the motor `VAL` field, use the limits read when the panel was opened and
can reject values based on the previous limits until the panel is reloaded.

## Three soft-limit arrangements

ECMC supports three useful arrangements. They differ in which layer enforces a
limit and whether changes propagate between the motor record and ECMC. The
complete PSI IOC projects are under
[`examples/PSI/lab_setup/asr`](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/lab_setup/asr).
They deliberately share the `MTEST04-EC-ASR` IOC identity and the same hardware;
install and run only one project at a time.

| Arrangement | Motor limits | ECMC limits | Runtime synchronization |
| --- | --- | --- | --- |
| Motor only | Autosave-restored | Disabled | Off |
| Motor and ECMC, independent | Autosave-restored and bounded by ECMC | YAML-configured | Off |
| Motor and ECMC, synchronized | Autosave-restored | Replaced by the restored motor pair | On |

All three arrangements save only the motor dial fields:

```text
MTEST04-EC-ASR:M1.DLLM
MTEST04-EC-ASR:M1.DHLM
```

Do not add `-CfgDLLM`, `-CfgDHLM`, their readbacks, or their enable records to
the same autosave request. Those records create a second, competing restore
path.

### Motor limits only

Use motor-only limits when motor-record commands should be constrained but ECMC
native commands may bypass that range. Disable ECMC limits and enable motor-local
restoration without synchronization:

```yaml
epics:
  name: M1
  motorRecord:
    restoreSoftLimits: true
    syncSoftLimits: false
    fieldInit: 'DLLM=-50,DHLM=50,RTRY=0,FOFF=Frozen'

softlimits:
  enable: false
```

`fieldInit` supplies the motor defaults used when no save file exists. Autosave
overwrites `.DLLM/.DHLM` when a saved pair is available. Because ECMC limits are
disabled, native commands are not protected by these motor-only limits. See
[`softlimits_motor_only`](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/lab_setup/asr/softlimits_motor_only).

### Independent motor and ECMC limits

Use independent limits when ECMC must enforce an outer safety envelope while
the motor record uses a narrower operator range:

```yaml
epics:
  name: M1
  motorRecord:
    restoreSoftLimits: true
    syncSoftLimits: false

softlimits:
  enable: true
  backward: -100
  backwardEnable: true
  forward: 100
  forwardEnable: true
```

For example, autosave may restore motor limits `-80, 80` while ECMC remains at
`-100, 100`. With synchronization off, later motor edits do not change ECMC.
The enabled ECMC limits are nevertheless the maximum range accepted by the
motor record, so restored motor limits must lie inside the ECMC envelope. See
[`softlimits_motor_and_ecmc`](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/lab_setup/asr/softlimits_motor_and_ecmc).

After restart, the expected values for that example are:

```text
M1.DLLM/M1.DHLM                 -80 / 80
M1-CfgDLLM-RB/M1-CfgDHLM-RB   -100 / 100
M1-CfgSyncSftLim                 No
```

### Synchronized motor and ECMC limits

Use synchronized limits when both interfaces should expose and enforce the same
restored pair:

```yaml
epics:
  name: M1
  motorRecord:
    restoreSoftLimits: true
    syncSoftLimits: true

softlimits:
  enable: true
  backward: -100
  backwardEnable: true
  forward: 100
  forwardEnable: true
```

At startup, the autosave-restored motor pair replaces the YAML ECMC pair. Later
motor-limit edits propagate to ECMC, and ECMC limit changes propagate back to
the motor record. See
[`softlimits_motor_and_ecmc_synced`](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/lab_setup/asr/softlimits_motor_and_ecmc_synced).

## Which values are used?

The standard YAML generator initializes the motor record's `.DLLM` and `.DHLM`
from the YAML soft-limit configuration. Autosave can overwrite those fields
while the IOC initializes. ECMC then snapshots the initialized motor fields and
applies the selected motor-local or synchronized restore policy.

| Configuration | Startup source of the restored limit pair |
| --- | --- |
| Restore option, with autosave restoring `.DLLM` and `.DHLM` | Autosave-restored motor fields |
| Restore option, with no autosave restore of those fields | Motor fields initialized by the standard YAML generator |
| No restore option | Configured ECMC limits seed the motor at startup |

The driver does not detect whether autosave supplied a field. It uses the motor
record values after initialization. Without a saved pair, the standard generated
motor record retains its YAML- or `fieldInit`-derived values. In synchronized
mode, a saved pair replaces the configured ECMC pair. In independent mode, the
saved motor pair remains local and must fit inside the enabled ECMC envelope.
A custom motor template must initialize its dial fields consistently with the
desired arrangement.

## Autosave request and restore passes

For an IOC named `MTEST04-MTN-ASM`, use `cfg/MTEST04-MTN-ASM_pos.req`:

```text
# Position restoration is controlled separately by the motor's RSTM field.
MTEST04-MTN-ASM:Axis1.DVAL
# Soft limits are dial coordinates, in engineering units.
MTEST04-MTN-ASM:Axis1.DLLM
MTEST04-MTN-ASM:Axis1.DHLM
```

Do not also restore the writable `-CfgDLLM` and `-CfgDHLM` records for the same
axis. That creates competing restore paths. Do not save `-RB` readback records
as configuration. Configure the ECMC limit values and enable flags in YAML for
the independent arrangement.

With the PSI `ioc install` workflow, a filename ending in `_pos.req` selects the
two-pass restore setup. For a differently named request, the PSI directive
`#ENABLE-PASS=2` requests that setup. Verify that the generated restore script
contains both actual autosave pass registrations before `iocInit`:

```iocsh
set_pass0_restoreFile "MTEST04-MTN-ASM_pos.sav"
set_pass1_restoreFile "MTEST04-MTN-ASM_pos.sav"
```

Autosave calls these passes **0 and 1**; the PSI directive's value `2` denotes the
two-pass setup. A `.req` lists fields to save. The `.sav` contains the values
which will actually be restored, so inspect it when troubleshooting.

## Position restoration and MRES

The restore option above concerns soft limits only. Position uses the saved
`.DVAL` and the motor's `RSTM` policy. In the ESS motor implementation, the
`NearZero` default restores a nonzero saved position when the initial readback
is near zero, according to the motor deadband. It does not request restoration
of a saved zero. `Always` is a different, explicit position-restoration policy;
do not change it merely to troubleshoot soft limits.

This example uses an incremental encoder (`encoder.type: 0`), whose counter
position can be restored through the motor. Soft-limit restoration can be used
independently of position restoration.

ECMC uses engineering units. An ECMC-specific motor template should establish
`MF_DRIVER_USES_EGU` from database loading, for example:

```epics
field(MFLG, "$(MFLG=8)")
```

Mask `8` (`1 << 3`) selects the driver's engineering-unit convention. It does not select a
position-restore policy or request zeroing. Keep the real MRES scaling; do not
set MRES to 1 to conceal a limit conversion problem. The ECMC compatibility init
hook also sets the EGU flag before motor-record initialization.

## Startup sequence, step by step

With `restoreSoftLimits: true` and `ECMC_STARTUP_GATE=1`, startup proceeds as
follows:

1. **Load the YAML configuration, before `iocInit`.** ECMC receives the configured
   soft limits. The standard motor template also initializes `.DLLM` and `.DHLM`
   from those limits, for example `-100` and `100`.
2. **Hold limit readback while restoration is pending.** The driver suppresses
   ECMC-to-motor soft-limit updates so that the configured limits cannot overwrite
   values restored into the motor record.
3. **Autosave restores the motor fields during `iocInit`.** Restore passes 0 and 1
   load `.DLLM` and `.DHLM`, for example `-123` and `123`. `.DVAL` is restored
   separately and follows the motor's position-restoration policy.
4. **Capture the restored limits after the IOC is running.** At
   `initHookAfterIocRunning`, ECMC captures the motor record's `.DLLM`, `.DHLM` and
   `.MRES`. This is an IOC initialization hook, not an autosave callback. If
   autosave did not replace the fields, their template defaults are captured.
5. **Allow native axis initialization.** Once the IOC is running and bus/timing
   health has been good continuously for two seconds, the gate allows native axis
   initialization. Drives, motion commands and ordinary cyclic command producers
   remain held.
6. **Complete the selected restore policy.** With synchronization enabled, the
   motor poller applies the captured pair to ECMC under the RT mutex; failed
   attempts are retried. With synchronization disabled, the captured pair stays
   in the motor record and ECMC either retains its YAML envelope or remains
   disabled in the motor-only arrangement.
7. **Deliver the first healthy motor status.** The compatibility workaround
   handles a stale startup `COMM_ALARM` once, under the motor-record lock, before
   normal asyn status delivery. This permits a deferred position-load command to
   proceed.
8. **Complete position restoration, if requested by `RSTM`.** The motor sends the
   saved `.DVAL` through asyn to ECMC. Startup waits for motor-record completion
   and a subsequent RT sample acknowledging the loaded coordinate; merely
   queueing the command is not sufficient.
9. **Release the remaining startup gate.** Every native axis must finish
   initialization, and every loaded motor record must complete its startup
   handshake. Ordinary PLCs, plugins and other motion command producers can then
   run, and a configured startup enable can be applied. An axis without a loaded
   motor record does not wait for a motor-record handshake.
10. **Continue normal operation.** Synchronized mode propagates changes in both
    directions. Independent and motor-only modes keep motor edits local.
    Autosave saves the motor dial fields for the next restart.

## Complete startup before motion

Set the gate explicitly before ecmccfg enters runtime:

```iocsh
epicsEnvSet("ECMC_STARTUP_GATE", "1")
```

With the gate enabled, native axis initialization proceeds with drives disabled.
Ordinary PLC/plugin cyclic execution, motion sequences, PVT, master/slave state
machines, C++ logic and position compare remain held until every native axis
and every **loaded motor record** has completed startup. This includes restored
limits, the position-load handshake when requested, and a subsequent RT sample
acknowledging the loaded coordinate. Axes without a loaded motor record do not
wait for one. Early motion/enable requests are rejected, not replayed later;
STOP, disable, coordinate loading and status polling remain available.

Configuration and plugin/logic enter-RT initialization hooks still run to prepare
runtime; supported motion/enable commands from those hooks are held too. The
dedicated safety plugin and bus/disabled-axis I/O continue operating. Gate `0`
selects legacy startup and does not provide this guarantee. `START_EPICS_FIRST`
changes startup order; its fixed delay is not a substitute for the gate.

The ECMC motor-record compatibility workaround clears only a stale startup
`COMM_ALARM`, once a healthy sample and live axis state have been verified. It
uses EPICS alarm handling under the record lock before delivering the asyn
callback, allowing a deferred position load to be queued. It preserves other
alarms and does not repeatedly clear runtime communication faults. This is a
narrow exception to normal motor-record alarm ownership; it does not change
motorECMC or bypass asyn command delivery.

See [startup configuration]({{< relref "/manual/general_cfg/startup/_index.md" >}})
for startup ordering. Verify a known nonzero saved position and limits different
from YAML defaults before the log announcing release of PLCs and motion command
producers. Repeat with no loaded motor record and with a stalled restore or bus
fault; incomplete startup must leave motion held.
