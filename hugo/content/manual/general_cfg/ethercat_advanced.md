+++
title = "Advanced EtherCAT and Commissioning"
weight = 17
chapter = false
+++

## Scope
This page covers the lower-level EtherCAT and commissioning helpers that are available when the normal `addSlave.cmd` and `applyComponent.cmd` path is not enough.

Use it when you need:

- additional EtherCAT domains
- custom process-image pointers/data items
- cyclic copying between EtherCAT entries
- runtime read/write access to individual SDOs
- explicit distributed-clock setup
- slave identity verification
- firmware update over FoE
- topology gaps where one or more slave positions should be skipped
- longer EtherCAT OP-state startup timeout during commissioning

For the common `Max wait time 30 second(s)` startup message, see
[EtherCAT startup timeout]({{< relref "/manual/general_cfg/startup/_index.md#ethercat-startup-timeout" >}})
before changing lower-level EtherCAT settings.

## Coupler Port Wiring Check

After the EtherCAT master scan completes, ecmc can check selected slaves for a
likely upstream cable connected to OUT instead of IN. The check only produces
a retained startup warning; it does not interlock motion or modify EtherCAT
configuration.

The check is disabled by default and enabled per slave by its hardware snippet,
after the slave object has been created. The standard EK1100, EK1101, EKM1101,
Technosoft iPOS, Nanotec N6, SmarAct MCS2, and Festo CMMT-ST snippets enable it.
Other hardware with a verified port layout can opt in the same way:

```bash
ecmcConfigOrDie "Cfg.EcSetSlavePortWiringCheckEnable(${ECMC_EC_SLAVE_NUM},1)"
```

Passing `0` disables the check for that slave. The command is configuration-only
and must be issued before runtime. Wiring warnings are retained in the
configuration log buffer and are included in motion diagnostic dumps at
diagnostic levels 1 and 2.

The global master switch is enabled by default. Disable every port-wiring check
without changing the per-slave selections with:

```bash
ecmcConfigOrDie "Cfg.EcSetPortWiringCheckEnable(0)"
```

Setting it to `1` again restores the checks selected by the hardware snippets.

## Additional Domains

The normal setup uses one EtherCAT domain.

If you need a separate execution rate or execution offset for a set of entries, create another domain:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}addDomain.cmd "EXE_RATE=2,EXE_OFFSET=0,ALLOW_OFFLINE=0"
```

Important behavior:

- all EtherCAT entries created after `addDomain.cmd` belong to the new domain
- `EXE_RATE` is in realtime cycles
- `EXE_OFFSET` is also in realtime cycles
- `ALLOW_OFFLINE=1` relaxes the domain state requirement, but can affect the rest of the bus and the DC behavior

Use extra domains only when you have a clear reason. For most systems, the default single-domain setup is simpler and safer.

## Simulation Entries

Simulation entries are local `ecmc` memory-backed EtherCAT entries. They are useful when an axis object needs an EtherCAT-style link, but the value is produced locally rather than by a real slave.

Two entries, `ZERO` and `ONE`, are created by default on the internal simulation slave. Additional entries can be added with `Cfg.EcAddSimEntry(...)`.

Global simulation entries:

```bash
ecmcConfigOrDie "Cfg.EcAddSimEntry(SIM_LIMIT,U32,0)"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(SIM_LIMIT,ax1.mon.lowlim)"
ecmcConfigOrDie "Cfg.WriteEcEntryEcPath(SIM_LIMIT,1)"
```

The global form stores the entry on the internal simulation slave (`-1`), but the entry can be addressed by name without an `ec<master>.s<slave>.` prefix. This is the preferred form for local dummy values and PLC-produced values.

Slave-scoped simulation entries are still supported:

```bash
ecmcConfigOrDie "Cfg.EcAddSimEntry(5,SIM_LIMIT,U32,0)"
ecmcConfigOrDie "Cfg.LinkEcEntryToObject(ec0.s5.SIM_LIMIT,ax1.mon.lowlim)"
```

Use the scoped form only when it is helpful to keep the simulated value visually associated with a specific slave in configuration.

Notes:

- global simulation entries do not require an EtherCAT master to be initialized
- they use the same data types as normal EtherCAT entries, for example `B1`, `U16`, `S32`, `U64`, `F32`, and `F64`
- they can be linked to motion objects with `Cfg.LinkEcEntryToObject(...)`
- they can be read and written with `ReadEcEntryIDString(<name>)` and `Cfg.WriteEcEntryEcPath(<name>,<value>)`
- entries are held in the internal simulation slave and share the normal ecmc entry-list limit

## Cyclic EtherCAT Entry Writes

`Cfg.EcAddEntryCyclicWrite(...)` copies the value of one EtherCAT entry to
another on every realtime cycle. This can be used to route an input or a local
simulation value directly to an EtherCAT output without adding a PLC
expression.

The argument order is destination first, then source:

```text
Cfg.EcAddEntryCyclicWrite(<to-entry-path>,<from-entry-path>)
Cfg.EcAddEntryCyclicWrite(<to-entry-path>,<from-entry-path>,<force>)
```

Both entries must already exist when the command is issued. The destination
must be an EtherCAT output entry or a simulation entry.

Example: copy a digital input on slave 1 to a digital output on slave 6:

```bash
ecmcConfigOrDie "Cfg.EcAddEntryCyclicWrite(ec0.s6.binaryOutput01,ec0.s1.binaryInput01)"
```

### Datatype and `force` behavior

By default, the source and destination entries must have identical datatypes:

```bash
ecmcConfigOrDie "Cfg.EcAddEntryCyclicWrite(ec0.s6.outputValue,ec0.s1.inputValue)"
```

Set the optional `force` argument to a nonzero value to bypass datatype
matching:

```bash
ecmcConfigOrDie "Cfg.EcAddEntryCyclicWrite(ec0.s6.outputValue,ec0.s1.inputValue,1)"
```

In forced mode, ecmc performs a raw bit copy using the smaller bit width of the
two entries. It does not perform numeric scaling or datatype conversion. Use
this mode only when the raw binary representations are intentionally
compatible.

{{% notice warning %}}
A cyclic write updates its destination every realtime cycle. Do not configure
another realtime object to write the same destination unless the resulting
write ordering and ownership are explicitly understood.
{{% /notice %}}

### Reporting configured writes

Use this command during startup diagnostics to list all configured cyclic
writes:

```bash
ecmcConfigOrDie "Cfg.EcReportEntryCyclicWrites()"
```

The report includes the source, destination, number of copied bits, and whether
`force` was enabled. `ecmcGrepParam` also annotates involved EtherCAT parameters
with `r`, `w`, or `rw` for source, destination, or both.

## Custom EtherCAT Data Items

`addEcDataItem.cmd` exposes a value directly from already configured process-image data.

Think of it as a typed pointer into the process image.

Example:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}addEcDataItem.cmd \
  "STRT_ENTRY_S_ID=5,STRT_ENTRY_NAME=statusWord01,OFFSET_BYTE=0,OFFSET_BITS=0,RW=2,DT=U16,NAME=rawStatus"
```

Use this when:

- you need direct access to a value that is already in the process image
- you need a custom EPICS-facing record for a piece of EtherCAT data
- a plugin or PLC should consume a small custom process-image item without defining a full axis or component object

Key parameters:

- `STRT_ENTRY_S_ID`: slave position
- `STRT_ENTRY_NAME`: start entry name
- `OFFSET_BYTE`, `OFFSET_BITS`: offset from that start entry
- `RW`: `1` write, `2` read
- `DT`: data type such as `B1`, `U16`, `S32`, `F32`, `F64`
- `NAME`: runtime name of the created item

By default, the wrapper also loads a matching EPICS record for the item.

## Runtime SDO Objects

Use `addEcSdoRT.cmd` when you need on-demand access to one EtherCAT SDO while the IOC is already running in realtime.

This is useful for:

- reading one diagnostic or configuration register during operation
- writing one non-cyclic setting without rebuilding the full slave setup
- exposing one SDO as a small EPICS control object with read/write commands

`addEcSdoRT.cmd` wraps `Cfg.EcAddSdoAsync(...)`.

### What It Creates

`addEcSdoRT.cmd` creates one named asynchronous SDO object in ecmc and then loads EPICS records for it.

For a name like `HW_ENABLE`, the underlying asyn object path becomes:

```text
ec<master>.s<slave>.sdo.HW_ENABLE
```

The script then creates these PVs:

- `...SDO-HW_ENABLE-Val`
- `...SDO-HW_ENABLE-RdCmd`
- `...SDO-HW_ENABLE-WrtCmd`
- `...SDO-HW_ENABLE-Bsy`
- `...SDO-HW_ENABLE-ErrId`

In practice:

- `Val` holds the current value to write and the most recent readback value
- `RdCmd` triggers an SDO read
- `WrtCmd` triggers an SDO write
- `Bsy` indicates that the SDO object is currently busy
- `ErrId` exposes the most recent SDO error code

### Startup Syntax

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}addEcSdoRT.cmd \
  "SLAVE_ID=<slave>,INDEX=0x<index>,SUBINDEX=0x<sub>,DT=<type>,NAME=<name>"
```

Supported parameters:

- `SLAVE_ID`: EtherCAT slave position. Optional, defaults to `0`
- `INDEX`: SDO index, for example `0x8010`
- `SUBINDEX`: SDO subindex, for example `0x07`
- `DT`: data type string such as `U8`, `S16`, `U32`, `S32`, `F32`, `F64`
- `NAME`: logical object name used in both the asyn path and EPICS PV names
- `P_SCRIPT`: optional naming-prefix script; defaults to `${ECMC_P_SCRIPT}`

### Example

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}addEcSdoRT.cmd \
  "SLAVE_ID=7,INDEX=0x8010,SUBINDEX=0x07,DT=U16,NAME=DRV_PARAM"
```

Typical usage from EPICS:

1. put the desired value to `...SDO-DRV_PARAM-Val`
2. process `...SDO-DRV_PARAM-WrtCmd` to write it
3. or process `...SDO-DRV_PARAM-RdCmd` to refresh the readback
4. watch `...SDO-DRV_PARAM-Bsy` and `...SDO-DRV_PARAM-ErrId`

### Datatype Behavior

The script chooses the value record template from `DT`:

- `F32` and `F64` use the floating-point template and `asynFloat64`
- all other supported types use the integer template and `asynInt32`

That means:

- integer-like SDOs are exposed through one EPICS `ao`
- float SDOs are also exposed through one EPICS `ao`
- `Val` is always the central EPICS value record, while `RdCmd` and `WrtCmd` control when the actual SDO transfer happens

### When To Use This

Prefer RT SDO objects when:

- you only need one or a few specific SDOs
- the access should be available after IOC startup
- operator or service staff should be able to read/write the SDO from EPICS

Do not use RT SDO objects when:

- the setting belongs to normal startup configuration and should always be applied deterministically at boot
- the value should instead be mapped into the process image as a cyclic PDO
- you need a large structured device interface rather than a few individual SDOs

For startup-time writes, prefer normal SDO configuration with `Cfg.EcAddSdo(...)`, `Cfg.EcAddSdoDT(...)`, or the higher-level slave/component setup.

## Distributed Clocks

Use `applySlaveDCconfig.cmd` when a slave needs explicit distributed-clock configuration:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveDCconfig.cmd \
  "ASSIGN_ACTIVATE=0x0300,SYNC_0_CYCLE=1000000,SYNC_0_SHIFT=0"
```

Typical inputs:

- `ASSIGN_ACTIVATE`: DC assign/activate word from the terminal XML
- `SYNC_0_CYCLE`: sync period in ns
- `SYNC_0_SHIFT`: sync shift in ns
- `SYNC_1_CYCLE`: optional second sync period in ns

Use this only when the slave actually needs explicit DC setup. Unnecessary DC customization can make commissioning harder.

## Slave Identity Verification

Use `slaveVerify.cmd` during commissioning or in strict production setups to verify that the expected slave is actually present:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=0,READ_FW=1"
```

The script can:

- verify vendor/product identity
- optionally reset the terminal through `0x1011`
- optionally read the firmware version from `0x100a`

This is useful when:

- identical stations may have different hardware revisions
- you want startup to fail early on the wrong terminal
- you are commissioning replacement hardware

## Firmware Update Over FoE

Some EtherCAT slaves can be updated with Beckhoff firmware files (`.efw`) over
FoE, File over EtherCAT. Do this only during commissioning or maintenance, with
motion disabled and the affected hardware in a safe state.

{{% notice warning %}}
Use the firmware file that exactly matches the terminal type and revision. Do
not interrupt power or the EtherCAT connection while `foe_write` is running.
The write can take a few minutes.
{{% /notice %}}

General procedure:

1. Identify the EtherCAT master and slave position.
2. Read the current firmware version from SDO `0x100A:0`.
3. Confirm the expected terminal is at the selected slave position.
4. Put the slave in `BOOT`.
5. Write the `.efw` file with `ethercat foe_write`.
6. Put the slave in `INIT`, then `PREOP`.
7. Read `0x100A:0` again and verify that the firmware version changed.

Example for an `EL7062` on master `0`, slave position `23`:

```bash
# Read current firmware version.
ethercat upload -m0 -p23 0x100A 0x0

# Confirm that slave position 23 is the expected terminal.
ethercat slaves | grep EL7062

# Enter BOOT mode.
ethercat states -m0 -p23 BOOT
ethercat slaves | grep EL7062

# Write firmware. This can take a few minutes.
ethercat foe_write -m0 -p23 /ioc/NeedfulThings/beckhoff_firmwares/EL7062-0000_REV0017_SW03.efw

# Return to INIT and then PREOP.
ethercat states -m0 -p23 INIT
ethercat slaves | grep EL7062
ethercat states -m0 -p23 PREOP
ethercat slaves | grep EL7062

# Read back firmware version.
ethercat upload -m0 -p23 0x100A 0x0
```

Typical firmware readback for this example changes from `02` before the update
to `03` after the update.

## Skipping Slave Positions

Use `ignoreSlaves.cmd` when the logical topology in the startup file must skip one or more bus positions:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}ignoreSlaves.cmd "COUNT=2"
```

This does not configure anything by itself. It only advances the slave-position counter used by later slave-related scripts.

Typical use:

- a coupler branch or optional hardware is not part of the active configuration
- one startup file is shared across similar but not identical topologies

## Recommended Usage

For normal systems:

1. start with `addSlave.cmd`
2. use `applyComponent.cmd` where possible
3. use the helpers on this page only when there is a concrete commissioning or process-image need

For advanced systems:

1. define the topology
2. add extra domains only if the timing model requires them
3. expose extra process-image data with `addEcDataItem.cmd`
4. apply explicit DC settings only where required
5. verify critical slaves during commissioning

## Related Pages

- [startup.cmd]({{< relref "/manual/general_cfg/startup/_index.md" >}})
- [Script Reference]({{< relref "/manual/general_cfg/script_reference.md" >}})
- [ecmc command reference]({{< relref "/manual/general_cfg/ecmc_command_ref.md" >}})
- [knowledgebase: EtherCAT CLI]({{< relref "/manual/knowledgebase/ethercatCLI.md" >}})
