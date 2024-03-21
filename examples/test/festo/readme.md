
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
