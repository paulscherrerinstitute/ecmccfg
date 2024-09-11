+++  
title = "hardware"   
weight = 11
chapter = false  
+++

### Hardware

### Over current protection EL9227-5500, EL9221-5000
In the standard setup at PSI over current protection modules are used to feed 24V to both the ethercat communication bus (E-bus) and the power bus of the ethercat slaves. If the over current protection is not enabled then the ethercat slaves will not receive power.

First time, (and only first time), a system is in use, the overcurrent modules needs to be enabled in order to allow current to flow. Enabling is done by push buttons in the LED area of the module. The long horizontal LEDs are in fact buttons that can be used to activate or tripp the over current protection. 

{{% notice warning %}}
Before pressing the buttons make sure it's safe to power on the system.
{{% /notice %}}

#### EL9221-5000
The EL9221-5000 has one channel and can therefore only the top button is needed to be pressed.

#### EL9227-5500 
The EL9227-5500 is a 2 channel module and normally both channels needs to be enabled by pressing both the top and bottom long LED. if only one are pressed it could result in that the power to the communication is fine but the power to the i/o bus is lacking. This can result in starnge issues. Both EL9227-5500 and EL9221-5000 have dedicated panels whre status of the over current protection can be seen.

### EL7041
If drive is in error or warning state, further information about the reason for the warning/error can be read from the drive terminal by using the ethercat command.

{{% notice info %}}
In order to use the etehrcat command, you must first login to the server where the ecmc IOC is running.
{{% /notice %}}


The diagnostic data can be read from register [Index A010 STM Diag data Ch.1](https://infosys.beckhoff.com/english.php?content=../content/1033/el70x1/2286662027.html&id=126846504617985959)

The registers can be read with the folowing syntax:
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



