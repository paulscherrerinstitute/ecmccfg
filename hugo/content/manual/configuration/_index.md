+++  
title = "Configuration.cmd"   
weight = 7
chapter = false  
+++  

## startup.cmd
startup.cmd takes the following arguments:
```
 Arguments
 [optional]
 ECMC_VER          = 9.5.4
 EthercatMC_VER    = 3.0.2 (obsolete)
 INIT              = initAll
 MASTER_ID         = 0 <-- put negatuve number to disable master, aka non ec-mode
 SCRIPTEXEC        = iocshLoad
 NAMING            = mXsXXX (default), ClassicNaming, ESSnaming
 EC_RATE           = 1000
 MODE              = FULL / DAQ
    FULL:  Init ecmc with support for both motion and DAQ (DEFAULT)
    DAQ:   Init ecmc with support for only daq (not motion)
    NO_MR: Init ecmc with support for motion (without motor record) and DAQ
 PVA               = YES / NO
 TMP_DIR           = directory for temporary files
 ENG_MODE          = 1/0. If ENG_MODE is set then PVs used for commissioning will be avaialble
 EC_TOOL_PATH      = Path to ethercat tool defaults to ethercat tool in ECmasterECMC_DIR, 
 otherwise            "/opt/etherlab/bin/ethercat"
 MAX_PARAM_COUNT   = Maximum asyn param count, defaults to 1500

 [set by module]
 ECMC_CONFIG_ROOT       = root directory of ${MODULE}
 ECMC_CONFIG_DB         = database directory of ${MODULE}
 EthercatMC_DB          = database directory of EthercatMC
 ECMC_EC_MASTER_ID      =  EtherCAT master id in use (for use in later scripts)
 ECMC_EC_SAMPLE_RATE    = EtherCAT bus sampling rate [Hz] (1000 default)
 ECMC_EC_SAMPLE_RATE_MS = EtherCAT bus sampling rate [ms] (1 default)
 ECMC_MODE              = ecmc mode. FULL/DAQ, Defaults to FULL
 ECMC_PVA               = use pva, default NO
 ECMC_SUPPORT_MOTION    = Variable to be used to block use of motion (""/empty=support motion or "#-"=disable motion)
 ECMC_TMP_DIR           = directory for temporary files, defaults to "/tmp/${IOC}/EcMaster_${ECMC_EC_MASTER_ID}}/"
 ECMC_EC_TOOL_PATH      = path to ethercat tool
 ECMC_SAMPLE_RATE_MS    = current record update rate in milli seconds
 ECMC_SAMPLE_RATE_MS_ORIGINAL = ECMC_SAMPLE_RATE_MS (used for restore to default if ECMC_SAMPLE_RATE_MS is changed)
```

Normally these arguments are set when the module is required:
```
require ecmccfg "ENG_MODE=1,MASTER_ID=2"
```

### [set mode](modes)
A very powerful tool is provided through the command line.
See a summary, incl. some examples of what possible [here](ethercatcli).

