# Test IOC for open loop stepper motor with auto-save-restore
The example absed on that PSI ioc install tool is used.

## Auto save restore configurations
Auto save/restore of motor position is made through motor record.
At PSI if the tool "ioc install" is used, its enough to add a file \<ioc_name\>_pos.req in the "./cfg/" sub dir listing the DVAL field of the motor record names that need to be auto saved restored.

In order for restore of motor position to succeed, both restore pass 1 and 2 needs to executed (see EPICS hooks).

**NOTE: Auto save restore will only work with incremental encoders (in axis definition yaml file, "encoder.type: 0").**

## Example of a _pos.req file in ./cfg/
ioc install automatically adds restore at both passes ("#ENABLE-PASS=2") if filename ends with  "_pos.req"
```
MTEST04-MTN-ASM:Axis1.DVAL
```
## Example of a x.req file in ./cfg/

If the file is named something else (without ending with "_pos.req") then also "#ENABLE-PASS=2" needs to be added:
```
#ENABLE-PASS=2
MTEST04-MTN-ASM:Axis1.DVAL
```

