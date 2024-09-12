+++  
title = "hardware"   
weight = 16
chapter = false  
+++

***
***
## Topics
1. [over current protection](#over current protection)
2. [el7041 error/warning](#el7041 error/warning)
3. [latency issues](#latency issues)
---
### over current protection
In the standard setup at PSI over current protection modules are used to feed 24V to both the ethercat communication bus (E-bus) and the power bus of the ethercat slaves. If the over current protection is not enabled then the ethercat slaves will not receive power.

First time, (and only first time), a system is in use, the overcurrent modules needs to be enabled in order to allow current to flow. Enabling is done by push buttons in the LED area of the module. The long horizontal LEDs are in fact buttons that can be used to activate or tripp the over current protection. 

{{% notice warning %}}
Before pressing the buttons, check the electrical drawings. Make sure it's safe to power on the system.
{{% /notice %}}

#### el9221-5000
The EL9221-5000 has one channel and therefore only the top button is needed to be pressed.

#### el9227-5500 
The EL9227-5500 is a 2 channel module and normally both channels needs to be enabled by pressing both the top and bottom long LED. if only one are pressed it could result in that the power to the communication is fine but the power to the i/o bus is lacking. This can result in starnge issues. Both EL9227-5500 and EL9221-5000 have dedicated panels whre status of the over current protection can be seen.

### el7041 error/warning
If drive is in error or warning state, further information about the reason for the warning/error can be read from the drive terminal by using the ethercat command. See [command line interface](ethercatcli) for more info.

{{% notice info %}}
In order to use the ethercat command, you must first login to the server where the ecmc IOC is running.
{{% /notice %}}


The diagnostic data can be read from register [Index A010 STM Diag data Ch.1](https://infosys.beckhoff.com/english.php?content=../content/1033/el70x1/2286662027.html&id=126846504617985959) with the folowing syntax:

```bash
ethercat upload -m <master_index> -p <slave_index> --type uint8 0xA010 <subindex>
```
Example for master 0, slave position 3:
```bash
# Saturated
ethercat upload -m 0 -p 3 --type uint8  0xA010 0x1

# Over temperature
ethercat upload -m 0 -p 3 --type uint8  0xA010 0x2

# Torque overload
ethercat upload -m 0 -p 3 --type uint8  0xA010 0x3

# Under voltage
ethercat upload -m 0 -p 3 --type uint8  0xA010 0x4

# Over voltage
ethercat upload -m 0 -p 3 --type uint8  0xA010 0x5

# Short circuit A
ethercat upload -m 0 -p 3 --type uint8  0xA010 0x6

# Short circuit B
ethercat upload -m 0 -p 3 --type uint8  0xA010 0x7

# No control power
ethercat upload -m 0 -p 3 --type uint8  0xA010 0x8

# Misc error
ethercat upload -m 0 -p 3 --type uint8  0xA010 0x9
```

The ecmccfg/utils/read_el70xx_diag.sh tool can also be used for reading the diagnostics:
```bash
bash read_el70xx_diag.sh <master_id> <slave_id>
```

Example: master 0, slave 3, drive under voltage warning
```bash
bash read_el7041_diag.sh 0 3

#########################################################
Reading EL70xx status at master id 0 and slave id 3:

Saturated:
0x00 0
Over temperature:
0x00 0
Torque overload:
0x00 0
Under voltage:
0x01 1
Over voltage:
0x00 0
Short circuit A:
0x00 0
Short circuit B:
0x00 0
No control power:
0x00 0
Misc error:
0x00 0

#########################################################

```
Note: The tool ecmccfg/utils/PDO_read can also be used for reading the diagnostics.

#### under voltage
Under voltage could be that the drive voltage setting is 48V but the drive is only powered with 24V.

The nominal voltage setting can be changed by the U_NOM_MV macro when applying the component (ecmccomp).

Example: Set nominal voltage to 24V
```
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccomp_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1000, I_STDBY_MA=500, U_NOM_MV=24000, R_COIL_MOHM=1230'"

```

#### over voltage
Over voltage could be that the drive voltage setting is 24V but the drive is powered with 48V.

The nominal voltage setting can be changed by the U_NOM_MV macro when applying the component (ecmccomp).

Example: Set nominal voltage to 48V
```
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccomp_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1000, I_STDBY_MA=500, U_NOM_MV=48000, R_COIL_MOHM=1230'"

```

{{% notice info %}}
For the EL703x drives the nominal voltage must be set to 24V (ecmccomp handles this automatically).
{{% /notice %}}

### EL70x1 Tuning
For EL70x1 stepper drives the following parameters can be tuned:
* 8011:07 Ka factor 
* 8011:08 Kd factor
* 8011:01 Kp factor
* 8011:02 Ki factor

** 8011:07 Ka and 8011:08 Kd factor: **

8011:07 Ka factor / 8011:08 Kd factor are “current boosts” during acceleration/deceleration.
Default they are set to 100% which is way too high for most applications. Start by setting these parameters to 0.
    
** 8011:01 Kp  and 8011:02 Ki factor: **
This is the current loop settings and this is also what affect the performance. The higher you set these registers, the stiffer the control loop.
For most applications it is important to keep a ration of 40:1.
Default is 400 / 10, if you want a stiffer loop, then change to f ex 800 / 20 and onwards.
Increase until the motor misbehaves and go back to a safe setting.

### latency issues

High latency, more than 10% of the ethercat cycle time, can in worse case result, in lost ethercat frames, which of course is not an ideal situation. High latency of teh ecmc_rt thread can be related to:
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
Theer are some restrictions on the sample rate. Normally, a rate in the range 100Hz-1Khz is a good choice. For other rates, please check the documentation of slaves in use.  
{{% /notice %}}

** Affinity**
Setting the affinity of the ecmc realtiem thread can often improve the performace. First check how many cores the controller has. 
{{% notice warning %}}
At PSI, core 0 is always isolated, do not move any threads to core 0.
{{% /notice %}}

In order to pin teh ecmc thread to a single core, add the following line to the startup script (after setAppMode.cmd):
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

