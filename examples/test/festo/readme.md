
# Download config to drive over foe
ethercat foe_write -m0 --position 10 paramPCK 


# Scalings 
Scalings are reverse engineered and could be tuned better.

# new drive
1. Connect with teh festo tool
2. Connect directlly to drive with ethernet cable.
3. The festo tool will find teh drive if within subnet (example for this drive 192.168.0.1)
4. Set ip of your computer to similar ip
5. Connect to drive in festo tool inside an open project
6. Press resart
7. Answer yes to download parameters
8. wait for restart, now etehrcat should be visible (etehrcat slaves)

# Open loop
Tghe drive will not update the openloop position if configured in CSV also confirmed by festo (support from festo in progress). However the eact velo updates.


#  BISS
* Seems will only work with 6MHz..
* Bit count divided into single turn and multiturn..

# RLS LA11 test
* Real scaling of LA11 is 1/4096mm, leadscrew pitch 1mm/rev 
* Bit count = 26
* This means that the drive will see 4096 ticks per rev => ST_BITS=12bits,ST_BITS=14bits, 
* Seems to work!

    



# Todo test generic scalings
* 256 levels of microsetp=>51200 microsteps/rev for a 200 stepper
* Set single tun count as close as possible = 16bits = 65536



# Closed loop
Get error about "closed loop not permissable" reasomn should be that commutation angle is unknown..



# GUI

caqtdm -macro "IOC=c6025a-04,MasterID=1,SlaveID=000" ecmcCMMT-ST.ui 





