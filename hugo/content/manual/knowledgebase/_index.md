+++  
title = "knowledge base"   
weight = 15
chapter = false  
+++  

## Topics
{{% children %}}
---

## Overview panel
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

The ecmcMain.ui is started with the following syntax:
```
caqtdm -macro "IOC=<ioc_name>" ecmcMain.ui
```

## Knowledge base
Due to the complexity an EtherCAT bus topology can assume, troubleshooting can be challenging.
This guide should provide the basic means to diagnose simple errors and is by no means complete!

### [command line interface](ethercatcli)
A very powerful tool is provided through the command line.
See a summary, incl. some examples of what possible [here](ethercatcli).

### [motion](motion)
For motion related issues, a very short troubleshooting guide is provided [here](motion).

### [drive tuning](tuning)
Tune drive control loops

### [hardware](hardware)
For hardware related issues, a very short troubleshooting guide is provided [here](hardware).
