# Simulated EtherCAT slave inventory

From the `ecmc_engineering` checkout, start the Podman IOC with:

```sh
./start_slave_inventory.sh
```

The launcher builds or reuses the local `ecmc-dev:local` image. Use
`./start_slave_inventory.sh --prebuilt` to use that image as-is, or add
`--image IMAGE` to select another image. The IOC runs in the foreground.

Without the container, run from this directory with `iocsh startup.cmd`, using the same ECMC and
ecmccfg module versions as the slit simulation. The default IOC name is
`SIMSLAVES`. Override it with `TEST_IOC`, or select module versions with
`ECMC_TEST_VER` and `ECMCCFG_TEST_VER`.

The startup configures simulated PDO mappings and loads standard slave PVs and device-specific default database substitutions.
It does not configure axes or plant models.
Each listed hardware descriptor gets its own bus position. The list covers
standalone hardware scripts that declare their own hardware type and product
ID, plus the Nanotec N6 option wrapper. It uses default options.
The inventory follows the GNUmakefile exclusions for Beckhoff KL (including
BK couplers), ESS crates, and Kuhnke slaves. It also skips EL6224, EP6224, and internal
mapping scripts. Festo CMMT-ST is excluded because its default records depend
on asynchronous SDOs that simulation does not support.

Descriptors that require EtherCAT domain memory maps (such as EL1262)
are excluded because the simulation backend rejects EcAddMemMap and
EcAddMemMapDT. SmarAct MCS2 is also excluded because it uses the physical
EtherCAT master CLI and requires EcAddDataDT, which simulation rejects. The MO7221-9016 variants also require that
command for their shared FSoE PDO configuration. The Technosoft iPOS4808BX
and iPOS8020BX voltage variants also require it for their TML PDO data items.

MO1918-0000 requires project-specific FSoE finalization. MS1132-2001
ships with its process-data mappings disabled. Both are excluded from this
standalone PV loading check.

The inventory is a checked-in snapshot. When adding a standalone descriptor,
add it here with a unique slave position and any required option macros.
