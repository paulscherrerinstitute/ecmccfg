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


## Purpose

The configuration framework contains the necessary files to configure an EPICS IOC for EtherCAT based motion control and DAQ.

## provided common user commands

*  addMaster.cmd
*  addSlave.cmd
*  addSlaveKL.cmd
*  applySlaveConfig.cmd
*  configureSlave.cmd
*  applyConfig.cmd
*  loadPLCFile.cmd
*  setAppMode.cmd

## Example IOC

1.  `require` the configuration module
    ```bash
    require ecmccfg <VERSION>
    ```

2.  add a coupler and slave
    ```bash
      # slave 0 {ecmcEK1100}
      ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EK1100"
      # slave 1 {ecmcEL1018}, with optional SLAVE_ID
      ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL1018, SLAVE_ID=1"
    ```
3.  add more slaves and apply configuration to the slaves
    ```bash
      # slave 8 {ecmcEL7037}, configure slave with optional SLAVE_ID
      ${SCRIPTEXEC} ${ecmccfg_DIR}configureSlave.cmd, "HW_DESC=EL7037, CONFIG=-Motor-Nanotec-ST4118L1804-B, SLAVE_ID=8"
      # slave 9 {ecmcEL7037}, addSlave, with immediate call off applySlaveConfig
      ${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL7037"
      ${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig,   "CONFIG=-Motor-Nanotec-ST4118L1804-B"
    ```

4.  apply the configuration
    ```bash
       ${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cmd
    ```

5. additional configuration
    ```bash
       ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM_DIG_OUT},BO_1,1)"
    ```
6. adding a physical motor axis
   ```bash
      epicsEnvSet("DEV",      "STEST-MYDEVICE")
      ${SCRIPTEXEC} ${ecmccfg_DIR}configureAxis.cmd,            "CONFIG=./cfg/axis_1"
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
   ```bash
      ${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd, "PLC_ID=0, FILE=./plc/homeSlit.plc, SAMPLE_RATE_MS=100"
   ```   

4. go active
    ```bash
      ${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd
    ```
