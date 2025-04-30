+++  
title = "host / ecmc server"   
weight = 17
chapter = false  
+++

## Topics
1. [Prefered NICs](#Prefered-NICs)
2. [latency issues / lost frames](#latency-issues--lost-frames)
3. [EtherCAT rate (EC_RATE)](#EtherCAT-rate-(EC_RATE))
4. [Debian 12](#(PSI-specific)-Debian-12)

### Prefered NICs

igb driver (ec_igb):
* Intel Corporation I210 Gigabit Network Connection (rev 03)
* Intel Corporation I350 Gigabit Network Connection (rev 01)

### latency issues / lost frames

High latency, more than 30% of the ethercat cycle time, can result in lost ethercat frames, which means data are lost. High latency of the ecmc_rt thread can be related to:
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
Reducing the ethercat cycle time is often very efficient when it comes to reduce latency. Do not run the ecmc systems faster than needed.
The default ecmc sample rate is 1Khz, which in many cases is not needed.

The sample rate is defined when require ecmccfg (example set to 500Hz, instead of 1kHz):
```
require ecmccfg "EC_RATE=500"
```
{{% notice info %}}
There are some restrictions on the sample rate. Normally, a rate in the range 100Hz-1Khz is a good choice. For other rates, please check the documentation of slaves in use. See heading "EtherCAT rate" below for more information.
{{% /notice %}}

** Affinity**
Setting the affinity of the ecmc realtime thread can often improve the performance. First check how many cores the controller has. 
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
If more than one ecmc ioc is running on the server, then make sure the ecmc_rt threads run on different cores.

Further tuning might include moving other cpu intensive threads to dedicated cores, for instance the epics thread ```cbLow```: 
```
afterInit "epicsThreadSetAffinity cbLow 6"
```
{{% notice info %}}
```cbLow``` is created at iocInit, therefore the "epicsThreadSetAffinity" must be executed with the "afterInit" command.
{{% /notice %}}

{{% notice note %}}
The affinity can also be set with the tools accessible in the EPICS module MCoreUtils.
{{% /notice %}}

### EtherCAT rate (EC_RATE)
The default EtherCAT frame rate in ecmc is set to 1kHz. For most applications this is however not needed and can therefore be reduced. A reduced EtherCAT rate reduces the load on the controller. In general, a good value for the frame rate is in the range 100Hz to 1kHz. For motion systems, a frame rate of 100Hz..500Hz is normally enough. Rates outside the 100Hz..1kHz range is normally not a good idea, and some slaves might not support it. However, in special cases both lower and higher rates might be possible and required.

Example: Set rate to 500Hz
```
require ecmccfg "EC_RATE=500"
...
```
For more information see the chapter describing startup.cmd.

As a comparison, TwinCAT default EtherCAT rates are:
* 100Hz for PLC
* 500Hz for motion

#### Lower rates
Issues that could occur in rates below 100Hz:
* triggering of slave watchdogs
* issues with dc clock syncs (DC capable slaves normally performs best with at a rate of at least 500Hz)
* some slaves might not support it

#### Higher rates
Issues that could occur in rates over 1Kz:
* missed frames
* issues with dc clock syncs
* some slaves might not support it.

NOTE: Some slave might support a high rate but could have built in signal filters of several ms which then makes sampling at higher freqs unnecessary/not needed.

In order to successfully run an ecmc ethercat system at higher rates some tuning might be needed:
* minimize slave count (and ensure that the slaves support it)
* minimize amount of processing (PLC, motion)
* use a performant host/controller
* use native ethercat driver (igb, not generic)
* only transfer the needed PVs to epics.
* affinity: Use a dedicated core for the ecmc_rt thread and move other high prio threads to other cores. see "high load on system
" above.
* consider use of more than one domain

#### (PSI specific) Debian 12
For debian 12 a different phyton venv needs to be copied to the tmp dir at startup.
The venv can be found here: /ioc/NeedfulThings/ecmc_python_venv/.venv_deb12/
