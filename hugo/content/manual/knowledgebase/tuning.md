+++  
title = "tuning"   
weight = 16
chapter = false  
+++

### Tuning

There are normally several control loops in an ecmc motion system:
* Position loop (centralized in ecmc if CSV)
* Velocity loop (in drive)
* Current loop (in drive)

#### Position loop
The position loop control parameters can be accessed and tuned by PVs. Normally, a pure P controller is enough (ki and kp set to 0) but sometimes the I and D part can be needed for instance if the drive is running in CSP mode with ecmc position loop enabled (ecmc mode CSP_PC).

**Backlash**

Tuning systems with backlash can be difficult. Sometimes a small D-part helps to reduce spikes in the centralized ecmc position loop controller output.

#### Velocity and Current loop
These control loops need to be tuned in the drive.

For EL70x1, see [EL70x1 Tuning](../hardware/el70x1/#tuning)
For other drives, consult the dedicated manual.

#### EL7062
EL7062 have an autotune feature that works well. For more info see knowledge-base/hardware/el7062.
