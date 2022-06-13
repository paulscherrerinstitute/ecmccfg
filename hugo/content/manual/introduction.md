+++  
title = "introduction"   
weight = 5
chapter = false  
+++  

## principle
EtherCAT requires the field bus components (slaves) to be configured on the master.
The master must know about the data exchanges with the slaves, this is referred to as **process image**.

During IOC-startup, the requested configuration is validated against the actually present hardware on the bus.
Mismatches will result in an error, the IOC will _not_ start.

{{% notice warning %}}
Blindly restarting the IOC, with only partially working EtherCAT hardware, will results in an inoperable IOC! Refer to the [troubleshooting guide](../troubleshooting) for details.
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

##### examples
The `addSlave` is used for simple slaves, a default configuration is automatically applied.
In addition default PVs will created for the basic slave features, i.e. status.
Most slaves also have PVs created matching the purpose, i.e. inputs will have `bi` records, outputs will have `bo` records for each channel.
This behaviour can be modified by arguments.

* add a coupler and slaves
  ```bash
  # slave 0 {ecmcEK1100}
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,    "HW_DESC=EK1100"
  # SLAVE_ID is automatically incremented
  # slave 1 {ecmcEL1018}
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,    "HW_DESC=EL1018"
  # skip slaves 2..6
  # slave 7 {ecmcEL2008}, with optional SLAVE_ID
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,    "HW_DESC=EL2008, SLAVE_ID=7"
  # slave 9 {ecmcEL2008}, with optional SLAVE_ID and P_SCRIPT
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,    "HW_DESC=EL2008, SLAVE_ID=7, P_SCRIPT=mXsXXX"
  # slave 10 {ecmcEL3204}, without any of the default PVs
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,    "HW_DESC=EL3204, DEFAULT_SUBS=false, DEFAULT_SLAVE_PVS=true"

  ```

* add more slaves and apply configuration to the slaves
  ```bash
  # slave 8 {ecmcEL7037}, configure slave with optional SLAVE_ID
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}configureSlave.cmd, "HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B, SLAVE_ID=8"
  # slave 9 {ecmcEL7037}, addSlave, with immediate call off applySlaveConfig
  # slave with global configuration
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,       "HW_DESC=EL7037"
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}applySlaveConfig,   "CONFIG=-Motor-Nanotec-ST4118L1804-B"
  # slave with local configuration, in this case provided by the module `ECMC_AGIR`
  epicsEnvSet("CFG_ROOT", "${ECMC_AGIR_DIR}/")
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,       "HW_DESC=EP7211-0034_ALL"
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}applySlaveConfig.cmd, "LOCAL_CONFIG=${CFG_ROOT}AM8211_AGIR.cfg"
  ```

#### apply the configuration
The configured process image is applied to the master
  ```bash
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}applyConfig.cmd
  ```

##### additional configuration
Optionally, manual modifications can be made to the default configuration.

In order to manually set `binaryOutput01` to `1` at startup, the following can be added to the startup script.
  ```bash
  ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},binaryOutput01,1)"
  ```

##### adding a physical motor axis
Axis configuration will is explained in details [here](../axis).

  * classic config
  ```bash
  epicsEnvSet("DEV",      "STEST-MYDEVICE")
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}configureAxis.cmd,  "CONFIG=./cfg/axis_1"
  ```
   * yaml config
  ```bash
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addAxisYaml.cmd, "FILE=./AM8111_CSV_minimum.yaml, ECMC_TMPDIR=/tmp/"
  ```

##### adding a virtual motor axis
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}configureVirtualAxis.cmd,     "CONFIG=./cfg/axis_11_virt"
  ```

##### adding synchronization
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/axis_1_sync"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/axis_11_sync"
  ```   

##### loading a PLC from file
The PLC functionionality is exmplained in detail here.
ECMC PLCs can be loaded from classical PLC files, from pure yaml files or from a yaml/PLC hybrid.
  * classic PLC-file
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd, "PLC_ID=0, FILE=./plc/homeSlit.plc, SAMPLE_RATE_MS=100"
  ```
  * pure yaml based PLC
  ```bash
  ${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}loadYamlPlc.cmd" "FILE=./plc1.yaml, ECMC_TMPDIR=/tmp/"
  ```
  * yaml definition, with classic PLC-file, Note: `file` key in yaml config will overwrite anything in the `code` key!
  ```bash
  ${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}loadYamlPlc.cmd" "FILE=./plc1File.yaml, ECMC_TMPDIR=/tmp/"
  ```

#### go active
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
  ```
