+++  
title = "panel"   
weight = 20
chapter = false  
+++

### Overview panel
For an overview of an ecmc system, the ecmcMain.ui panel is a good starting point.
The ecmcMain.ui covers most parts of an ecmc system:
* ecmc_rt thread diagnostics:
    - Jitter
    - Cycle time
* EtherCAT:
    - Status 
    - Lost frames
    - Slave count
    - master Id
    - Links to dedicated sub panels for each slave type.
* Links to all configured objects:
    - motion expert panels
    - PLC objects
    - plugin objects
    - data storage objects

The panel is started with the following syntax:
```
caqtdm -macro "IOC=<ioc_name>" ecmcMain.ui
```
