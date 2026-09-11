+++
title = "EtherCAT Endpoint Timing"
weight = 18
chapter = false
+++

## Purpose

ecmc describes when an input value was acquired and when an output will be
applied. The same model is used for encoders, digital inputs, drives and digital
outputs, with or without Distributed Clocks (DC). It is the timing base for
control-delay compensation, touch probes and position-triggered outputs.

## Generic timing model

```text
TIME ────────────────────────────────────────────────────────────────────────►

 input event                 application anchor A[k]              output event
 E_in ●───────────────────────────────●────────────────────────────────● E_out
      │                               │                                │
      └── input age Δin (< 0) ────────┘──── output lead Δout (> 0) ────┘
          sample → copy → PDO → Rx       control calculation → Tx → apply

 endpoint delay = E_out - E_in = Δout - Δin

 input terminal generation selection:

 sample ── calculation/copy time ── ready ─────────────────────────────►
                                      │
 PDO frame after ready  ──────────────┘ uses this sample
 PDO frame before ready ─────────────── uses the previous sample
```

`calculationCopyTimeNs` determines which PDO generation is visible. It is not
added again after that generation has been represented by `cycleOffset`.

## Endpoint fields

| Field | Meaning |
|---|---|
| `source` | Cycle-only, SYNC0, SYNC1 or hardware timestamp |
| `reference` | Receive, application, SYNC or absolute DC time |
| `cycleTimeNs` | Endpoint cycle period |
| `shiftTimeNs` | Slave-reported synchronization shift (diagnostic) |
| `cycleOffset` | PDO generation relative to the selected endpoint event |
| `eventOffsetNs` | Terminal/electronics correction from that event |
| `updateDivisor` | EtherCAT cycles between fresh endpoint values |
| `uncertaintyNs` | Error bound propagated into the calculated path |
| `timestampBits` | Linked hardware timestamp width, otherwise zero |
| `timestampCorrectionNs` | Correction applied to a linked timestamp |

For a DC endpoint, ecmc resolves events from the actual ESC schedule
(`0x0990`/`0x09A0`) and the configured SYNC source. For a non-DC endpoint, the
result remains cycle-bounded. A linked terminal timestamp provides absolute DC
event time and the highest timing quality.

The values are resolved during startup/configuration. They are published by the
slow `ecmcRTLog` diagnostics port only when changed; they are not added to the
normal per-cycle asyn parameter loop.

## Configuration

Direction is `1` for output and `2` for input.

```text
Cfg.EcSetSlaveTimingSource(slave,direction,source)
Cfg.EcSetSlaveTimingOverride(slave,direction,cycleOffset,eventOffsetNs,uncertaintyNs)
Cfg.EcSetSlaveTimingUpdateDivisor(slave,direction,divisor)
Cfg.EcLinkSlaveTimingTimestamp(slave,direction,entryId,bits,correctionNs)
```

Use automatic discovery where the slave reports enough information. Put
terminal-specific overrides in its ecmccfg hardware snippet so IOC startup
remains hardware-independent.

## DC/SYNC shift and scheduling margin

The DC/SYNC shift changes where the slave input sample or output application
lands inside the EtherCAT cycle. Even when the timestamp conversion is correct,
this phase can affect the practical timing margin:

- If an input sample is too close to frame transfer or terminal calculation
  completion, the visible PDO value can move by one cycle.
- If a timed output is scheduled with too little lead time relative to the
  terminal's SYNC phase, the terminal may not reliably accept the new schedule.
- Adding terminals changes frame length and can move host send/receive timing,
  so margins that are only barely sufficient may become unstable.

Prefer hardware timestamps and scheduled-output start times for sub-cycle
accuracy, but still choose a DC/SYNC shift that leaves comfortable margin around
PDO transfer and terminal processing. The best shift is terminal-, topology- and
cycle-rate-dependent and should be verified on the real system.

Inspect the resolved result:

```text
EcPrintSlaveConfig(slave)
EcPrintControlTiming(inputSlave,outputSlave)
```

## Timing PV panel

Default slave PVs load `ecmcEcTiming.substitutions`. Open the panel with:

```bash
caqtdm -macro "IOC=my-ioc,MasterID=0,SlaveID=9" \
  ${ecmccfg_DIR}../qt/ecmcEcTiming.ui
```

The resulting PV prefix follows the normal slave naming, for example
`my-ioc:m0s009-Timing-In-...`.

## Worked example

At a 1 ms EtherCAT period, an input sampled 250 us before `C[k-1]` and an
output applied 500 us after `C[k]` have:

```text
delay = 250 us + 1 ms + 500 us = 1.750 ms
```

This example describes the measured EL5042 input (`SYNC0 shift = -250 us`) to
EL7041 output (`SYNC0 shift = +500 us`) configuration. Other terminals use the
same model but require their own discovered values or hardware-snippet
overrides.

## Accuracy limits

- Normal PDO events remain quantized to the endpoint update cycle.
- DC makes the phase deterministic but does not remove PDO cycle quantization.
- Sub-cycle, preferably below 10 us, touch-probe or compare accuracy requires
  terminal hardware timestamps or timestamp-scheduled outputs such as EL2252.
- Mechanical response is separate from EtherCAT/software endpoint delay.
