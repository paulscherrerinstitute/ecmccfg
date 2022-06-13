+++  
title = "motion"   
weight = 12
chapter = false  
+++

### culprit

From experience, very few issues are related to the EtherCAT hardware itself.
Mostly the cabling or the actual motor/encoder hardware is to blame.

Even more likely is human error, such as:
* wrong scaling of the axis
* writing to the wrong hardware (forgot to select the right slave in the axis config)
* ...

#### check the status
Before anything is restarted or power cycled, check the status of the slaves.
Either from a dedicated shell, or from within the `iocsh`.

If all slaves are in 'OP' state, at least data is exchanged between the hardware and the master. 

Depending on the integrator and overview panel might exist.
Consult this panel for further details.
Remember, `red` is not necessarily a bad sign!
It can also indicate that certain channels are not connected.
Whether those channels _should_ be connected is beyond the scope of this guide.

#### restarting the IOC
{{% notice warning %}}
Blindly restarting the IOC, with only partially working EtherCAT hardware, WILL RESULT IN TOTAL FAILURE OF THE IOC!!!
{{% /notice %}}

Check the hardware BEFORE restarting the IOC!

#### force manual motion
{{% notice warning %}}
This procedure is for experst only. You run the risk of destroying expansive devices! Limit switches are _not_ obeyed! YOU HAVE BEEN WARNED! 
{{% /notice %}}
In case the hardware is fine, the cables are checked, human error is mostly excluded, or the system used to work but doesn't work any longer, directly writing to the drive is possible.

For this however, the IOC needs to be reconfigured to _not_ link the hardware to an axis!
1. Edit the startup script and comment out the axis, just leave the slave configuration.
2. restart the IOC
3. check the PVs for the drive in question (slave 7 in this case)
4. `dbgrep "*s007*"`
5. There should be two PVs ending with, `-Drv01-Cmd` and `-Drv01-Spd`
6. Set `-Drv01-Cmd` to `1` and check the amplifier did enable, if you don't know how to check for an enabled amplifier, you should not use this command!
7. After the amplifier is engaged, write a small number to `-Drv01-Spd`. Dependinf on the scaling, the number might be in the range of 1..1000.
8. Observe the encoder, or in case of open-loop, the device itself.