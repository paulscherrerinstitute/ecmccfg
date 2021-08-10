# ecmccfg

A configuration framework for ECMC Motion Control Module for EPICS.

## License

This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA

## Build
by default this module is only build for RHEL7 and Epics >=R7.0.4
```bash
make [LIBVERSION] [clean] install
```
check the module loads for version `dev`, Epics `R7+` and ECMC version `dev`, note `MASTER_ID=-1` which runs ECMC in master-less mode.
Make proper adjustements to match your needs in terms of versions.
```bash
iocsh -7 -r "ecmccfg,dev 'ECMC_VER=dev,MASTER_ID=-1'"
```

## Purpose

The configuration framework contains the necessary files to configure an EPICS IOC for EtherCAT based motion control and DAQ.

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
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addSlave.cmd,       "HW_DESC=E2008, SLAVE_ID=7, P_SCRIPT=mXsXXX"
  ```
3.  add more slaves and apply configuration to the slaves
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

4.  apply the configuration
  ```bash
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}applyConfig.cmd
  ```

5. additional configuration

  manually set `binaryOutput01` to `1`

  ```bash
  ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},binaryOutput01,1)"
  ```

6. adding a physical motor axis

  * classic config
  ```bash
  epicsEnvSet("DEV",      "STEST-MYDEVICE")
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}configureAxis.cmd,  "CONFIG=./cfg/axis_1"
  ```
   * yaml config
  ```bash
  ${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}addAxisYaml.cmd, "FILE=./AM8111_CSV_minimum.yaml, ECMC_TMPDIR=/tmp/"
  ```

7. adding a virtual motor axis
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}configureVirtualAxis.cmd,     "CONFIG=./cfg/axis_11_virt"
  ```

8. adding synchronization
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/axis_1_sync"
  ${SCRIPTEXEC} ${ecmccfg_DIR}applyAxisSynchronization.cmd, "CONFIG=./cfg/axis_11_sync"
  ```   

9. loading a PLC from file
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

10. go active
  ```bash
  ${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
  ```
