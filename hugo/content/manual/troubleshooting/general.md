
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

