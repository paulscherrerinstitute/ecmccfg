+++  
title = "introduction"   
weight = 5
chapter = false  
+++  

## Principle
EtherCAT requires the field bus components (slaves) to be configured on the master.
The master must know about the data exchanges with the slaves, this is referred to as **process image**.

During IOC-startup, the requested configuration is validated against the actually present hardware on the bus.
Mismatches will result in an error, the IOC will _not_ start.

{{% notice warning %}}
Blindly restarting the IOC, with only partially working EtherCAT hardware, will results in an inoperable IOC! If troubleshooting is needed then check out the [knowledge base](../knowledgebase) for details.
{{% /notice %}}

### IOC structure
The startup script has several steps:

1. `require` [ecmccfg](#require-ecmccfg)
1. [configure](#slave-configuration) the slaves on the EtherCAT bus
    - additional configuration
    - adding a physical motor axis
    - adding a virtual motor axis
    - adding synchronization
    - loading a PLC from file
1. [apply](#apply-the-configuration) the configuration
1. [go active](#go-active)

#### require ecmccfg
  ```bash
  require ecmccfg <VERSION>
  ```

#### slave configuration
Each slave on the field bus must be configured for use with ECMC.
For this purpose scripts can be called for:

* **adding** slaves with default configuration
* **adding and configure** while adding
* **applying** a configuration to the previously added slaves

In addition to these ecmccfg scripts also the ecmccomp repo that contains a component library can be used. Settings are then applied with the ecmccomp/applyComponent.cmd, see below examples.

##### examples
The `addSlave` is used for simple slaves, a default configuration is automatically applied.
In addition default PVs will created for the basic slave features, i.e. status.
Most slaves also have PVs created matching the purpose, i.e. inputs will have `bi` records, outputs will have `bo` records for each channel.
This behaviour can be modified by arguments.

* add a coupler and slaves
  ```bash
  # slave 0 {EK1100}
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,        "HW_DESC=EK1100"
  # SLAVE_ID is automatically incremented
  # slave 1 {EL1018}
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,        "HW_DESC=EL1018"
  # skip slaves 2..6
  # slave 7 {EL2008}, with optional SLAVE_ID
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,        "HW_DESC=EL2008, SLAVE_ID=7"
  # slave 9 {EL2008}, with optional SLAVE_ID and P_SCRIPT
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,        "HW_DESC=EL2008, SLAVE_ID=7, P_SCRIPT=mXsXXX"
  # slave 10 {EL3204}, without any of the default PVs
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,        "HW_DESC=EL3204, DEFAULT_SUBS=false, DEFAULT_SLAVE_PVS=true"

  ```

* add more slaves and apply configuration to the slaves
  ```bash
  # slave 8 {EL7037}, configure slave using applyComponent.cmd from ecmccomp module with optional SLAVE_ID.
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,        "HW_DESC=EL7037, SLAVE_ID=8"
  ${SCRIPTEXEC} ${ecmccomp_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper, MACROS='I_MAX_MA=1000, I_STDBY_MA=500, U_NOM_MV=48000, R_COIL_MOHM=1230'"
  # slave 9 {EL7037}, addSlave, with immediate call off applySlaveConfig
  # slave with global configuration
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,         "HW_DESC=EL7037"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd, "CONFIG=-Motor-Nanotec-ST4118L1804-B"
  # slave with local configuration, in this case provided by the module `ECMC_AGIR`
  epicsEnvSet("CFG_ROOT", "${ECMC_AGIR_DIR}/")
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,         "HW_DESC=EP7211-0034_ALL"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd, "LOCAL_CONFIG=${CFG_ROOT}AM8211_AGIR.cfg"
  ```

#### apply the configuration
The configured process image is applied to the master
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd
  ```

##### additional configuration
Optionally, manual modifications can be made to the default configuration.

In order to manually set `binaryOutput01` to `1` at startup, the following can be added to the startup script.
  ```bash
  ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},binaryOutput01,1)"
  ecmcConfigOrDie "Cfg.WriteEcEntryEcPath(ec0.s${ECMC_EC_SLAVE_NUM_DIG_OUT}.binaryOutput12,1)"
  ```

##### adding a physical motor axis
Axis configuration will is explained in details [here](../axis).
The preferred way to confuser axes is with the `yaml` based configuration.
It unifies the way, (1) physical axes, (2) virtual axes and (3) synchronization is handled.
It is theoretically possible to use a mix of `yaml` and classic configuration, but this is untested.

  * yaml config
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/ax1.yaml, DEV=${DEV}, DRV_SLAVE=4, ENC_SLAVE=3, ENC_CHANNEL=01"
  ```
  * classic config
  ```bash
  epicsEnvSet("DEV",      "STEST-MYDEVICE")
  ${SCRIPTEXEC} ${ecmccfg_DIR}configureAxis.cmd,  "CONFIG=./cfg/axis_1"
  ```
{{% notice tip %}}
See [best practice](../motion_cfg/best_practice/) and [yaml cfg](../motion_cfg/axisyaml/) and for more information.
{{% /notice %}}

##### adding a virtual motor axis
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}configureVirtualAxis.cmd,     "CONFIG=./cfg/axis_11_virt"
  ```
{{% notice tip %}}
See [best practice](../motion_cfg/best_practice/) and [yaml cfg](../motion_cfg/axisyaml/) and for more information.
{{% /notice %}}

##### adding synchronization
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/axis_1_sync"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/axis_11_sync"
  ```   
{{% notice tip %}}
See [best practice](../motion_cfg/best_practice/) and [yaml cfg](../motion_cfg/axisyaml/) and for more information.
{{% /notice %}}

##### loading a PLC from file
The PLC functionality is explained in detail here.
ECMC PLCs can be loaded from classical PLC files, from pure yaml files or from a yaml/PLC hybrid.
  * classic PLC-file
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd, "PLC_ID=0, FILE=./plc/homeSlit.plc, SAMPLE_RATE_MS=100"
  ```
  * pure yaml based PLC
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlPlc.cmd "FILE=./plc1.yaml"
  ```
  * yaml definition, with classic PLC-file, Note: `file` key in yaml config will overwrite anything in the `code` key!
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlPlc.cmd "FILE=./plc1File.yaml"
  ```
{{% notice tip %}}
See [plc cfg](../plc_cfg/best_practice/) for more information.
{{% /notice %}}

#### go active
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
  ```
