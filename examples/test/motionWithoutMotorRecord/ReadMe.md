# Motion without Motor Record

## PV:s
* IOC_TEST:Axis1-MtnCmd
* IOC_TEST:Axis1-MtnCmdData
* IOC_TEST:Axis1-TgtPosCmd
* IOC_TEST:Axis1-TgtVelCmd
* IOC_TEST:Axis1-EnaCmd
* IOC_TEST:Axis1-ExeCmd
* IOC_TEST:Axis1-RstCmd
* IOC_TEST:Axis1-StpCmd

### IOC_TEST:Axis1-MtnCmd (Motion Command)
The motion command PV is used to define the type of movement and can take the following values:
* "NO_COMMAND" : No command
* "MOVE_VEL"   : Move constant velocity
* "MOVE_REL"   : Move relative positioning
* "MOVE_ABS"   : Move absolute positioning
* "MOVE_HOME"  : Start homing sequence

Example:
```
dbpf IOC_TEST:Axis1-MtnCmd MOVE_ABS
```

### IOC_TEST:Axis1-MtnCmdData (Motion Command Data)
Parameter used in conjuction with "IOC_TEST:Axis1-MtnCmd".
Currently the parameter have two different meanings.
* In conjuction with "MOVE_ABS":
  * Value 0: Normal absolute motion.
  * Value 1: Go to position defined by external PLC (gear in)
* In conjucntion with "MOVE_HOME" it defines which homing sequence to use.

Example: Prepare homing sequence 3
```
dbpf IOC_TEST:Axis1-MtnCmd MOVE_HOME
dbpf IOC_TEST:Axis1-MtnCmdData 3
```
### IOC_TEST:Axis1-TgtPosCmd (Target Position)
Pv that defines the target position of the next "MOVE_ABS" or "MOVE_REL" command.

Example: Set Target position to 50 
```
dbpf IOC_TEST:Axis1-TgtPosCmd 50
```

### IOC_TEST:Axis1-TgtVelCmd (Target Velocity)
Pv that defines the target velocity of the next "MOVE_ABS", "MOVE_REL" or "MOVE_VEL" command.
The value can be changed while axis is in motion.

Example: Set Target velocity to 10 
```
dbpf IOC_TEST:Axis1-TgtVelCmd 10
```
Note: This velocity is not used for homing sequences.

### IOC_TEST:Axis1-EnaCmd (Enable Command)
Command that will enable/disable the axis (amplifier).

Example: Enable axis 
```
dbpf IOC_TEST:Axis1-EnaCmd 1
```

### IOC_TEST:Axis1-ExeCmd (Execute Command)
A positive edge of exeute bit will start a new motion command based on:
* TgtVelCmd (target velocity)
* TgtPosCmd (target position)
* MtnCmd  (Motion command)
* MtnCmdData (Motion command param)

If the axis is busy then a positive edge of execute bit will update target position and 
target velocity ("on the fly change"):
* TgtVelCmd (target velocity)
* TgtPosCmd (target position)

Example: Trigger motion command
```
dbpf IOC_TEST:Axis1-ExaCmd 0
dbpf IOC_TEST:Axis1-ExaCmd 1
```

### IOC_TEST:Axis1-RstCmd (Reset Command)
Command that will reset any axis-errors.

Example: Reset errors
```
dbpf IOC_TEST:Axis1-RstCmd 1
```

### IOC_TEST:Axis1-StpCmd (Stop Command)
Command that will stop motion

Note: New motion commands will be blocked if Stop bit is high.

Example: Stop axis
```
dbpf IOC_TEST:Axis1-StpCmd 1
```

### More...
There are many more PV:s like status PV:s.. Descriptions will be added...

## Example Move absolute
```
dbpf IOC_TEST:Axis1-TgtPosCmd 50
dbpf IOC_TEST:Axis1-TgtVelCmd 10
dbpf IOC_TEST:Axis1-MtnCmd MOVE_ABS
dbpf IOC_TEST:Axis1-EnaCmd 1
dbpf IOC_TEST:Axis1-ExaCmd 0
# Wait for enabled
dbpf IOC_TEST:Axis1-ExaCmd 1
```
