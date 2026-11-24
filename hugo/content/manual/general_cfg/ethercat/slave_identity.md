+++
title = "Slave firmware and identity"
weight = 18
chapter = false
+++

`addSlave.cmd` loads static identity records next to the existing `HWType` PV.
`slaveIdentity.cmd` reads the values once after the hardware script, before
runtime and `iocInit`, and passes them as initial values when loading the records.

| Slave PV suffix | Value |
| --- | --- |
| `HWType` | Configured hardware description, such as `EL2794` |
| `HWFw` | Firmware string read from CoE SDO `0x100A:00` |
| `HWRev` | Discovered SII revision, formatted as eight hexadecimal digits |
| `HWSer` | Discovered SII serial number, formatted as an unsigned decimal string |
| `HWFwStat` | Result of the optional firmware read |
| `HWIdStat` | Result of the revision/serial read |

Use the same slave prefix as `HWType`. These are soft `stringin` records with
no cyclic read. The values describe the startup snapshot; restart the IOC to
refresh them after replacing a terminal or updating firmware. String storage
preserves the entire unsigned 32-bit serial number without signed conversion.

## Availability and status

Not every EtherCAT slave supports CoE or implements `0x100A`. For example,
[EL27xx terminals have no CoE interface](https://infosys.beckhoff.com/content/1033/el27xx/index.html).
Where implemented, [0x100A is a firmware string](https://infosys.beckhoff.com/content/1033/ej2502/2448711307.html),
not a fixed two-byte number. Revision and serial are read from the master's
discovered identity, so their read does not depend on that firmware object.

`Available` means the corresponding read succeeded. Firmware that is absent,
unsupported or could not be read remains `Unknown` with status
`Unavailable/read failed`. Empty and non-text values have explicit statuses.
The EPICS string field holds 39 characters; a longer firmware string is shortened
and marked `Truncated`. Identity read failures leave revision and serial
`Unknown`. These optional reads do not abort startup.

Firmware containing quotes, backslashes, dollar signs, commas or semicolons
is marked `Unsupported database text` and displayed as `Unknown`, so device
text cannot become IOC-shell syntax or database macros. The generic reader
also exposes the raw text in an environment variable for direct inspection.

A successful serial read can return `0`. This is the device's reported value,
not a guarantee of a unique manufacturing serial. Some Beckhoff devices encode
production information in this field; see the
[identity-object description](https://infosys.beckhoff.com/content/1033/ej2502/2448711307.html).
`HWRev` is the SII device revision and is kept separate from firmware.

Before attempting the optional firmware SDO, ecmccfg calls
`Cfg.EcGetSlaveSdoReadSupport(slave)`. A zero result skips the transfer and
reports `No discovered SDOs`. This is a conservative EtherLab check based on
the discovered SDO count, not the slave's authoritative SII CoE mailbox flag;
a CoE slave without SDO-info enumeration can therefore also be skipped.

## Enable or disable reads

Reads are enabled by default for real hardware. Revision and serial use the
existing `EcGetSlaveRevisionNum` and `EcGetSlaveSerialNum` commands; firmware
additionally requires the generic string helper. Disable reads for one slave with:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd "HW_DESC=EL2794,READ_IDENTITY=0"
```

Or set the global default before adding slaves:

```bash
epicsEnvSet("ECMC_READ_SLAVE_IDENTITY", "0")
```

An explicit `READ_IDENTITY` overrides the global default. The records report
`Disabled` when reads are disabled, `Simulation` for `SIM=1`, and
`Development mode` when slave verification is disabled through `ECMC_DEV_MODE`.
No hardware reads are issued in those modes. `DEFAULT_SLAVE_PVS=false`
suppresses these records and their reads along with the other standard slave PVs.

## ECMC support

Firmware string capture requires an ECMC build registering
`ecmcEpicsEnvSetSdoString`. Such builds export `ECMC_SDO_STRING_SUPPORTED=1`;
rebuild and install ECMC as well as ecmccfg to enable firmware capture. The
helper reads an arbitrary VISIBLE_STRING SDO in configuration mode and sets
environment variables. All slave-specific policy, numeric identity reads and
database loading are in ecmccfg. No native code writes these PVs.

For example, read firmware into `MY_FW`, limited to the 39 characters of an
EPICS string field:

```bash
ecmcEpicsEnvSetSdoString(MY_FW,13,0x100a,0,39)
epicsEnvShow("MY_FW")
epicsEnvShow("MY_FW_STATUS")
```

Arguments are environment-variable name, slave position, index, subindex and
optional character limit (0 or omitted means 255). Each call resets the result
and sets `<name>_STATUS`. `<name>_DB_VALUE` contains text safe for the startup
macro path, or `Unknown` if the read failed or the text contains unsupported
characters. The raw `<name>` value remains available after a successful read.

On older ECMC builds, revision and serial still use their existing commands.
Only firmware remains `Unknown` with status `Not supported`; the startup script
does not attempt the missing helper. Do not set the capability variable manually.

The legacy `slaveVerify.cmd` option `READ_FW=1` remains a two-byte numeric read
into `ECMC_EC_SLAVE_FW`; it does not populate these PVs and is not the generic
firmware-string reader.
