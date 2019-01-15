# ECMC_config

## Conventions

- declare variables with `epicsEnvSet`
- functions calls in the following two forms:
    1.  `fooBar arg1 arg2`
    2.  `fooBar(arg1, arg2)`

No mixes please, keep the code nice.
- Macros
    - put double quotes (`"`) around macros
    - use _UPPERCASE_ for marocs
    - use _curly brackets_ for macros
    - i.e.: `"${MY_MIGHTY_MACRO}"`

- Example: `epicsEnvSet("DEV", "${SYS}")`

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
    require ECMC_config <VERSION>
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
