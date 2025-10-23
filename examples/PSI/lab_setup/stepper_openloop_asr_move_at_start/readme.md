# Test IOC for stepper motor with auto-save-restore move to position
A move absoulte command is triggered to a auto-save-restore position at startup. Only makes sense for axes with  absolute encoder. The move is triggered from PLC-code.

## Auto save restore configurations
Auto save/restore of motor position is made through motor record.
At PSI if the tool "ioc install" is used, its enough to add a file \<ioc_name\>_pos.req in the "./cfg/" sub dir listing the DVAL field of the motor record names that need to be auto saved restored.

In order for restore of motor position to succeed, both restore pass 1 and 2 needs to executed (see EPICS hooks).

**NOTE: Auto save restore will only work with incremental encoders (in axis definition yaml file, "encoder.type: 0").**

## Example of a _pos.req file in ./cfg/
ioc install automatically adds restore at both passes ("#ENABLE-PASS=2") if filename ends with  "_pos.req"
```
MTEST04-MTN-ASM:SetRestorePos-RB
```

## PLC code
The plc variable "static.restorePos" is linked to the PV "MTEST04-MTN-ASM:SetRestorePos-RB" which is added to the auto-save-restore file:
```
if(${SELF}.firstscan) {
  static.restorePos:=-1000;
}

#- Ensure auto save restore values have been written (PLC starts before epics is completely started):
if(not(epics_running())) {
  return [];
}

if(not(mc_get_busy(${AX_ID=1})) and not(static.restoreDone)) {
  mc_move_abs(${AX_ID=1},0,static.restorePos,360,360,360);
  mc_move_abs(${AX_ID=1},1,static.restorePos,360,360,360);
  static.restoreDone:=1;
  println('Move triggered to: ',static.restorePos );
};

if(static.restoreDone) {
  static.restorePos:=ax${AX_ID=1}.enc.actpos;
};

if(static.restorePos <> static.restorePosOld and not(mc_get_busy(${AX_ID=1}))) {
  println('New restore pos: ',static.restorePos);
  static.restorePosOld := static.restorePos;
};
```

NOTE: Auto enable is configured in ecmc:
```
  autoEnable:
    atStartup: yes
    enableTimeout: 2
    disableTimeout: 5
```

