# ECMC_config

## Purpose

provide a module to handle ECMC configuration

## provided commands

*   addMaster.cmd
*   addSlave.cmd
*   configureSlave.cmd
*   applyConfig.cmd
*   loadPLCFile.cmd
*   setAppMode.cmd

## Example IOC

1.  `require` the configuration module

    ```bash
    require ECMC_config kivel "SYS=STEST_ESS"
    ```

2.  add a slave

    ```bash
    # slave 0 (ecmcEK1100-EtherCatCoupler)
    $(SCRIPTEXEC) $(ECMC_config_DIR)addSlave.cmd, "SLAVE_ID=0, HW_DESC=ecmcEK1100-EtherCatCoupler"
    ```

3.  apply the configuration
    
    ```bash
    $(SCRIPTEXEC) ($(ECMC_config_DIR)applyConfig.cmd)
    ```
    
4. go active
    
    ```bash
    $(SCRIPTEXEC) ($(ECMC_config_DIR)setAppMode.cmd)
    ```