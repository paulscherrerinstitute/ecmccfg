+++  
title = "ecmc server"   
weight = 14
chapter = false  
+++

***
***
## Topics
1. [latency issues](#latency-issues)

---

### latency issues

High latency, more than 10% of the ethercat cycle time, can in worse case result, in lost ethercat frames, which of course is not an ideal situation. High latency of the ecmc_rt thread can be related to:
1. The generic device driver is used
2. High load on system
3. ...

#### generic device driver is used
Check which driver is in use by running (on the ecmc server):
```
lsmod | grep ec_
```
If the ec_master is using the ec_generic driver then a switch to igb driver is recommended.

The file /ioc/hosts/\<hostname\>/cfg/ETHERCATDRVR is listing the available drivers.

The recommended contents of the ETHERCATDRVR file is:
```
DEVICE_MODULES="igb generic"
```
In this case, the system will first try to use igb driver, if not possible it will fallback to the generic driver.
After editing the file, the host needs to be rebooted in order for the changes to take effect.

#### high load on system

** Reduce sample rate**
Reducing the ethercat cycle time is often very effichient when it comes to reduce latency. Do not run the ecmc systems faster than needed.
The default ecmc sample rate is 1Khz, which in many cases is not needed.

The sample rate is defined when require ecmccfg (example set to 500Hz, instead of 1kHz):
```
require ecmccfg "EC_RATE=500"
```
{{% notice info %}}
There are some restrictions on the sample rate. Normally, a rate in the range 100Hz-1Khz is a good choice. For other rates, please check the documentation of slaves in use.  
{{% /notice %}}

** Affinity**
Setting the affinity of the ecmc realtiem thread can often improve the performace. First check how many cores the controller has. 
{{% notice warning %}}
At PSI, core 0 is always isolated, do not move any threads to core 0.
{{% /notice %}}

In order to pin the ecmc thread to a single core, add the following line to the startup script (after setAppMode.cmd):
```
#- go active (create ecmc_rt)
${SCRIPTEXEC} ${ecmccfg_DIR}setAppMode.cmd

#- Set affinity of ecmc_rt (core 5)
epicsThreadSetAffinity ecmc_rt 5
```
If more than one ecmc ioc is running on the server, then make sure the ecmc_rt threads run on differnt cores.

Also other threads might take a lot of resources, for instace the epics thread "cbLow": 
```
afterInit "epicsThreadSetAffinity cbLow 6"
```
{{% notice info %}}
cbLow is created at iocInit, therefore the "epicsThreadSetAffinity" must be executed with the "afterInit" command.
{{% /notice %}}
