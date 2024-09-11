+++  
title = "hardware"   
weight = 13
chapter = false  
+++

### over current protection el9227-5500, el9221-5000
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
For the EL703x drives the nominal voltage must be set to 24V.
{{% /notice %}}
