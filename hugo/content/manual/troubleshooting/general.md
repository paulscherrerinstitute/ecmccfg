
+++  
title = "general"   
weight = 12
chapter = false  
+++

***

### culprit

From experience, very few issues are related to the EtherCAT hardware itself.
Mostly the cabling or the actual motor/encoder hardware is to blame.

Even more likely is human error, such as:
* wrong scaling of the axis
* writing to the wrong hardware (forgot to select the right slave in the axis config)
* ...

#### check the status
Before anything is restarted or power cycled, check the status of the system.

A simple way to get an overview of the entire ecmc system is to start the ecmcMain.ui panel. This panel contains, or links to, almost the entire ecmc IOC:
* thread status
* EtherCAT master status 
* EtherCAT slaves status (overview of all configured slaves)
* motion axes (all axes in the system are reachable)
* PLC:s
* ...

```bash
caqtdm -macro "IOC=<iocname>" ecmcMain.ui
```

Remember, `red` is not necessarily a bad sign!
It can also indicate that certain channels are not connected.
Whether those channels _should_ be connected is beyond the scope of this guide.

Next step is to diagnose from a dedicated shell, or from within the `iocsh`.

If all slaves are in 'OP' state, at least data is exchanged between the hardware and the master. 

#### restarting the IOC
{{% notice warning %}}
Blindly restarting the IOC, with only partially working EtherCAT hardware, WILL RESULT IN TOTAL FAILURE OF THE IOC!!!
{{% /notice %}}

Check the hardware BEFORE restarting the IOC!
