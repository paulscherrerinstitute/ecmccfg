+++  
title = "tuning"   
weight = 16
chapter = false  
+++

***

### Tuning

There are normally several control loops in an ecmc motion system:
* Position loop (centralized in ecmc if CSV)
* Velocity loop (in drive)
* Current loop (in drive)

#### Position loop
The position loop control parameters can be accessed and tuned by PVs. Normally, a pure P controller is enough (ki and kp set to 0) but sometimes the I and D part can be needed.

**Backlash**

Tuning systems with backlash can be difficult. Sometimes a small D-part helps to reduce spikes in the centralized ecmc position loop controller output.

#### Velocity and Current loop
These control loops need to be tuned in the drive.

For EL70x1, see [EL70x1 tuning](../hardware/el70x1)
For other drives, consult the dedicated manual.
