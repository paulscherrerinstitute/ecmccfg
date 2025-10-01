+++  
title = "manual"   
weight = 1
chapter = true  
+++  

# ecmccfg

A configuration framework for ECMC Motion Control Module for EPICS.

## Purpose

The configuration framework contains the necessary files to configure an EPICS IOC for EtherCAT based motion control and DAQ.

***
## Topics
{{% children %}}

---
## provided common user commands

* addAxis.cmd
* addDataStorage.cmd
* addMaster.cmd
* addSlave.cmd
* addSlaveKL.cmd
* addVirtualAxis.cmd
* applyAxisSynchronization.cmd
* applyConfig.cmd
* applySlaveConfig.cmd
* configureAxis.cmd
* configureSlave.cmd
* configureVirtualAxis.cmd
* loadPLCFile.cmd
* loadPlugin.cmd
* setAppMode.cmd
* setDiagnostics.cmd

## Example IOC

1.  `require` the configuration module with optional version
  ```bash
  require ecmccfg <VERSION>
  ```

2.  add a coupler and slave
  ```bash
  # slave 0 {ecmcEK1100}
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,       "HW_DESC=EK1100"
  # SLAVE_ID is automatically incremented
  # slave 1 {ecmcEL1018}
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,       "HW_DESC=EL1018"
  # skip slaves 2..6
  # slave 7 {ecmcEL2008}, with optional SLAVE_ID
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,       "HW_DESC=E2008, SLAVE_ID=7"
  #-- ATTENTION, this only work for certain slaves, as the EPICS templates have to be migrated before
  # slave 9 {ecmcEL2008}, with optional SLAVE_ID and P_SCRIPT
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,       "HW_DESC=E2008, SLAVE_ID=9, P_SCRIPT=mXsXXX"
  ```
3.  add more slaves and apply configuration to the slaves
  ```bash
  # slave 10 {ecmcEL7062}, add slave and apply component
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL7062"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000, R_COIL_MOHM=1230,L_COIL_UH=500'"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper, CH_ID=2, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000, R_COIL_MOHM=1230,L_COIL_UH=500'"

  # For two channel drives, both channels must be configured (ensure correct motor cfgs are used). If channel is not in use, then apply the "Generic-Ch-Not-Used" component.
  ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL7062"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000, R_COIL_MOHM=1230,L_COIL_UH=500'"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Generic-Ch-Not-Used"

  # Just ignore some slaves (increase SLAVE_ID with 4)
  ${SCRIPTEXEC} ${ecmccfg_DIR}ignoreSlaves.cmd    "COUNT=4"

  # slave 16 {ecmcEL7037}, configure slave with optional SLAVE_ID. Please use applyComponent.cmd instead
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,  "HW_DESC=EL7037"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000, R_COIL_MOHM=1230,L_COIL_UH=500'"

  # slave 17 {ecmcEL7037}, addSlave, with immediate call off applySlaveConfig. Please use applyComponent.cmd instead
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,       "HW_DESC=EL7037"
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}applySlaveConfig,   "CONFIG=-Motor-Nanotec-ST4118L1804-B"
  
  # slave with local configuration, in this case provided by the module `ECMC_AGIR`
  epicsEnvSet("CFG_ROOT", "${ECMC_AGIR_DIR}/")
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,       "HW_DESC=EP7211-0034_ALL"
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}applySlaveConfig.cmd, "LOCAL_CONFIG=${CFG_ROOT}AM8211_AGIR.cfg"
  ```

4. additional configuration

  manually set `binaryOutput01` to `1`

  ```bash
  ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},binaryOutput01,1)"
  ```
  If a limit switch needs to be fed from a binary output then this can be configured in the yaml configuration for the axis by setting (cleaner solution):

  ```bash
  axis: 
    feedSwitchesOutput: ec0.s1.binaryOutput04
  ```

5. adding a physical motor axis

  * yaml config
  ```bash
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}loadYamlAxis.cmd, "FILE=./AM8111_CSV_minimum.yaml, ECMC_TMPDIR=/tmp/"
  ```

  * classic config, please use yaml config instead.
  ```bash
  epicsEnvSet("DEV",      "STEST-MYDEVICE")
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}configureAxis.cmd,  "CONFIG=./cfg/axis_1"
  ```
  
6. adding a virtual motor axis, please use yaml config instead.
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}configureVirtualAxis.cmd,     "CONFIG=./cfg/axis_11_virt"
  ```

7. adding synchronization, can be simpler to add the code in a normal PLC, see.
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/axis_1_sync"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/axis_11_sync"
  ```   

8. loading a PLC from file
  * classic PLC-file
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd, "PLC_ID=0, FILE=./plc/homeSlit.plc, SAMPLE_RATE_MS=100"
  ```
  * pure yaml based PLC, please use classic PLC-file load instead
  ```bash
  ${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}loadYamlPlc.cmd" "FILE=./plc1.yaml, ECMC_TMPDIR=/tmp/"
  ```
  * pure yaml based PLC, please use classic PLC-file load instead, with classic PLC-file, 
  Note: `file` key in yaml config will overwrite anything in the `code` key!
  ```bash
  ${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}loadYamlPlc.cmd" "FILE=./plc1File.yaml, ECMC_TMPDIR=/tmp/"
  ```
