+++
title = "EL1xxx"
weight = 17
chapter = false
+++

## Scope
Use this page for EL1xxx digital-input terminals with special timing or signal
level behavior.

## EL1262 oversampling and `NELM`
The EL1262 transfers its oversampled digital inputs as packed bytes. Therefore,
for this terminal, `NELM` specifies the number of bytes per channel and per
EtherCAT cycle, not the number of individual digital samples.

The actual oversampling factor is:

```text
oversampling factor = NELM * 8
```

For example, `NELM=1` transfers one byte containing eight time-ordered input
bits, so it configures 8-times oversampling. `NELM=125` transfers 125 bytes and
corresponds to the maximum factor of 1000 samples per EtherCAT cycle.

```bash
# 8-times oversampling (8 bits per channel and EtherCAT cycle):
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL1262, NELM=1"

# 1000-times oversampling (125 packed bytes per channel and EtherCAT cycle):
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL1262, NELM=125"
```

At an EtherCAT rate of `1 kHz`, `NELM=125` therefore produces an effective
digital-input sampling rate of `1 MHz`. The corresponding sample period is
calculated using `NELM * 8`, not `NELM` alone.

{{% notice note %}}
For the EL1262, valid `NELM` values are byte counts in the range 1 through 125.
The waveform elements are packed bytes; each element contains eight consecutive
digital input samples.
{{% /notice %}}

## EL1252, EL1252-0050
`EL1252-xxxx` is a two-channel digital-input terminal with timestamps for both
low-to-high and high-to-low edges:
* EL1252: **24V signals**
* EL1252-0050: **5V signals**

Both terminals have the same product ID and process data and can therefore be
configured as `EL1252`:
```bash
# One channel:
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL1252"
```

These terminals are useful because they can latch the timestamp of the positive
edge and/or negative edge of an input signal independently of the EtherCAT bus
rate. These timestamps can then be correlated with other timestamped data, such
as encoder or analog-input signals.

**IMPORTANT**
Since the `EL1252-0050` is a `5V` terminal, it must be powered with `5V`. If it
is powered with `24V`, it will most likely be damaged. The simplest way to get
the correct supply is to add an `EL9505` or similar terminal before the
`EL1252-0050`.

See [ELxxxx](../elxxxx/) for more information about terminal power levels.

{{% notice warning %}}
**Make sure the EL1252-0050 has a 5V power supply from an EL9505 (or similar) before powering the system. If the terminal is powered with the normal 24V it will most likely break.**
{{% /notice %}}

{{% notice note %}}
A `5V` signal will not be detected by the `24V` version (`EL1252`), but the
terminal will not be damaged. Conversely, it is also not a good idea to power
the `24V` version from an `EL9505` or similar `5V` supply.
{{% /notice %}}

## Related Pages
- [hardware]({{< relref "/manual/knowledgebase/hardware/_index.md" >}})
- [ELxxxx]({{< relref "/manual/knowledgebase/hardware/ELxxxx.md" >}})
