# ELM3504 queued SDO autosave / restore

The `softlimits_*` subdirectories are three independent motion IOCs demonstrating
soft-limit autosave/restore for the motor-only, independent motor/ECMC, and
synchronized motor/ECMC cases. See `softlimits_README.md` for a comparison.

This PSI IOC example tests PREOP restoration of the low/high range-error
thresholds on all four channels of an ELM3504 at master 0, slave 26. It requires
ECMC and ecmccfg builds with queued-SDO support. No motion axes are loaded.
The real EtherCAT terminal is required; the simulation backend cannot run these
mailbox transfers.

The startup script currently includes a diagnostic trial for intermittent
`0x0032` PLL errors: `Cfg.EcSelectReferenceDC(0,26)` explicitly selects the
ELM3504 as the DC reference instead of EtherLab's automatic selection (slave 0
in the captured log). Cycle and shift settings are unchanged. Compare repeated
startups and confirm the selected reference in the kernel log before treating
this as a fix; this trial has not been tested on hardware here. Remove that
line to return to automatic reference selection.

To diagnose the remaining PLL startup failure, the example explicitly sets
`START_EPICS_FIRST=1` so logging is initialized before runtime even when the
SDO definitions are skipped for an isolation test. Scalar SDORT objects normally
select this order automatically; the explicit flag is only for this diagnostic
comparison. The example enables INFO and ERROR logging (`ECMC_ASYN_TRACE_MASK=0x41`, `MCU-RTLog-Ctrl=5`). With an ECMC
build containing the startup cycle timing diagnostics, look for `Startup timing
master 0`: the first message reports first-send delay from the startup timestamp,
wake latency and execution time. While startup remains held, a summary every
five seconds reports maximum wake latency/execution time and minimum/maximum
cycle periods. These use the cyclic thread's existing timestamps and are logged
after sending; they do not require the normal thread diagnostic PVs to update.
At 1 kHz, the nominal cycle period is 1000 microseconds. These messages provide
evidence for investigating the PLL error; adding them is not a PLL fix.

## IOC layout

The layout follows `best_practice/motion/stepper_openloop_asr`:

- `Makefile`: `ioc install --clean -V --ioc MTEST04-EC-ASR`.
- `MTEST04-EC-ASR_parameters.yaml`: IOC name, host, port and EPICS/platform.
- `MTEST04-EC-ASR_startup.script`: terminal and eight queued SDO endpoints.
- `cfg/MTEST04-EC-ASR_sdo_set.req`: IOC-local autosave requests.

Adjust the IOC host/port and module versions to your installation. When renaming
this IOC, update the Makefile, parameter/startup filenames, and request filename
and PV prefixes together. The startup script relies on the normal ecmccfg
finalize hook. There is no separate `startup.cmd`.

The request file has `#ENABLE-PASS=1` and `#UPDATE-FREQ=5`. The PSI installer uses
these to generate pass-1 restore and a five-second autosave monitor set. There
are no duplicate autosave registrations in the startup script. Inspect the
resulting `saveRestore.script_restore` before testing; it should contain:

```iocsh
set_pass1_restoreFile "MTEST04-EC-ASR_sdo_set.sav"
```

There must be no pass-0 restore of this file, since the saved records are
waveforms. The generated save script should contain:

```iocsh
create_monitor_set("MTEST04-EC-ASR_sdo_set.req",5)
```

## Terminal settings and PDO status

The ELM350x [CoE settings](https://infosys.beckhoff.com/content/1033/elm3xxx/8800001547.html)
provide these signed INT32 range-error thresholds, expressed in the terminal's
integer measurement units:

| Channel | Low Range Error | High Range Error | SDO aliases |
| --- | --- | --- | --- |
| 1 | `0x8000:32` | `0x8000:33` | `Ch01LowRangeError`, `Ch01HighRangeError` |
| 2 | `0x8010:32` | `0x8010:33` | `Ch02LowRangeError`, `Ch02HighRangeError` |
| 3 | `0x8020:32` | `0x8020:33` | `Ch03LowRangeError`, `Ch03HighRangeError` |
| 4 | `0x8030:32` | `0x8030:33` | `Ch04LowRangeError`, `Ch04HighRangeError` |

These thresholds determine when the channel error bit and error LED are set.
They have no separate limit-enable SDO. The familiar “Limit 1/2 + Enable Limit
1/2” interface belongs to other EL analog terminals. ELM3504 output clamps
(`:35/:36`) are a separate function and are not configured by this example.

The thresholds are configured through SDOs, rather than output PDOs. The loaded
input PDOs expose each channel's status through `AI01-Stat` ... `AI04-Stat` and
the corresponding `-ErrAlrm`, `-UndrLimAlrm` and `-OvrLimAlrm` PVs. Range-status
indications and the configurable error thresholds are distinct; this example
checks saved SDO settings, not analog threshold-crossing behavior.

## First commissioning and save

Start the IOC normally. An absent save file on the first run is expected. With
no saved requests, EtherLab applies the explicit `EcAddSdoDT` defaults
(-8388608 / 8388607). No additional SDORT write is appended. Use
suitable thresholds for the configured measurement mode and sensor. For example,
in a client shell, submit both thresholds for all channels:

```sh
for ch in 01 02 03 04; do
    caput "MTEST04-EC-ASR:m0s026-SDO-Ch${ch}LowRangeError-Val" -100000
    caput "MTEST04-EC-ASR:m0s026-SDO-Ch${ch}HighRangeError-Val" 100000
done
```

`WRITE_ON_VAL=1` means each value write queues a transfer. It is the only behavior
option in this example. Without it, `Val` only stages a value and `WrtCmd=1`
submits the write, preserving the existing interface. `RdCmd=1` requests an
upload in either case. All scalar SDOs automatically queue requests, verify
writes and expose a snapshot for autosave; no `QUEUE` or `RESTORE` option is needed.

For every endpoint, wait for `-Bsy` to become zero, check `-ErrId` is zero, and
check `-Val-RB` equals the requested threshold. A successful `caput` alone does
not confirm a successful hardware write. Runtime writes remain available; a
terminal may itself reject settings that cannot be changed in its current state.

The request file saves `-StartupData_`, an internal waveform containing the
accepted write request and endpoint identity. It does not save command triggers,
staged `Val` or readback. An untouched endpoint causes no restore write; an
explicit write of zero is a valid saved request. Wait for autosave to finish and
inspect `MTEST04-EC-ASR_sdo_set.sav` in the IOC's configured autosave directory
before stopping. Keep this file for the next run.

## Restart and verify the actual SDOs

1. Restart normally with the saved file. Do not write `Val` or `WrtCmd` again.
   The startup worker appends restored writes after the `EcAddSdoDT` defaults.
   EtherLab downloads the list in PREOP, so the saved values win. After the bus
   reaches OP, SDORT uploads and compares the final values before motion/PLCs
   are released. This also works when the normal startup order would be ECMC
   first. There is no manual start command
   or `SDO_AUTO_START` setting in this example.
2. Check all eight endpoints for `Bsy=0`, `ErrId=0`, and the expected `Val-RB`.
3. Request fresh hardware uploads, then wait for completion and check the same
   readbacks again:

   ```sh
   for ch in 01 02 03 04; do
       caput "MTEST04-EC-ASR:m0s026-SDO-Ch${ch}LowRangeError-RdCmd" 1
       caput "MTEST04-EC-ASR:m0s026-SDO-Ch${ch}HighRangeError-RdCmd" 1
   done
   ```

A failed startup download prevents successful slave configuration. A failed
readback verification leaves motion/PLCs held and sets the endpoint error.
Check the IOC log and `ErrId`, correct the cause, and restart the IOC. The bus
may already be in OP during verification; OP alone does not mean motion is ready.
The SDO verification hold also applies when `STARTUP_GATE=0`.

Only the configured target slave must reach OP before its SDO readbacks start.
Other physical slaves that this IOC does not configure may remain PREOP; the
master’s combined AL-state mask is not used as an SDO readiness condition.
On a timeout, the log reports bus/timing/SDO readiness and lists pending or
failed SDOs with their target slave’s OP state, busy flag and error code.

The terminal descriptor normally resets its configuration at startup, so this
restart exercises reapplying the saved settings. To test the no-value case, use
a separate empty autosave directory/file, write only one endpoint, save and
restart: only that endpoint should have a restore request, and all other
thresholds should retain the script defaults. Keep the established save file
when doing this separate trial.

Static startup SDOs from ecmccomp or `EcAddSdo*` remain the baseline. Restored
writes are appended after all component/plugin startup configuration, immediately
before master activation. The example deliberately includes both for each
threshold, so the restart check exercises precedence. If several accepted startup
writes target the same address, readback is compared to the final requested
value. PDO mapping/assignment overrides remain rejected.

The optional `PREOP_ONLY=1` can restrict a particular endpoint to
startup writes; it is not required for autosave restoration and is not used here.

The files have been checked locally. No installer, live IOC, or hardware test
has been run for this example.
