# Example: Extra feedback linked to motor RDBL field

Bug fixes was needed in both ecmc and motor before this was working.
* ecmc commit needed     : 1b971da8a  (version 6.2.4 will not work)
* motor commit needed    : 7a25fed51  (version 7.0.3.1 will not work)
* ecmccfg commmit needed : 66c04b72f  (version 6.2.4 will not work)

## Configuration

Important fields are: 
1. RTRY : Max retry count
2. RMOD : Retry Mode
3. UEIP : Use encoder if present
4. RDBD : Readtry deadband 
5. URIP : Use RDBL Link If Present
6. RDBL : Readback link (position form EPICS variable)
7. MRES : Need to be 1.0 

### RTRY : Max retry count
Needs to be set to a number higher than 0

### RMOD : Retry Mode
Can be set to:
0: "Unity"
1: "Arthmetic"
2: "Geometric"
3: "In-Position"

Use setting 1 or 2 for this test

### UEIP : Use encoder if present
Not used in this test. Set to 0.

### RDBD : Readtry deadband 
Set to 0.1 in this test.

### URIP : Use RDBL Link If Present
Not used in this test. Set to "".

### RDBL : Readback link (position form EPICS variable)
This should be a record holding the value. In this test the a simulates position was generated through a CALC record multiplying the actual position by 0.95.

### MRES
Need to be set to 1.0.

## Feed settings to motor record by ECMC_AXISFIELDINIT var:

Any vars added to "ECMC_AXISFIELDINIT" will be forwared to motor record at init:

```
epicsEnvSet("ECMC_MRES",                  "1.0")
##### Pass extra parameters to motor record:
# RTRY : Max retry count
# RMOD : Retry Mode
# UEIP : Use encoder if present
# RDBD : Readtry deadband 
# URIP : Use RDBL Link If Present
# RDBL : Readback link (position form EPICS variable)
epicsEnvSet("ECMC_AXISFIELDINIT",  "RRES=1.0,RTRY=2,RMOD=1,UEIP=0,RDBD=0.1,URIP=1,RDBL=$(IOC):$(ECMC_MOTOR_NAME)-PosActSim")
```
NOTE: Do not use "CP" on the RDBL link...

## Running the test

1. Start:
```
iocsh.bash feedbackFromRecord.script
```

2. Make a homing:
```
dbpf IOC_TEST:Axis1.HOMR 1
```

3. Run positioning commands:
```
dbpf IOC_TEST:Axis1 10
```
Now the motion should be going step whise (depending on RTRY) and end up in:
1. ecmc act pos = 10/0.95
2. motor record act pos = 10

NOTE: JOGGING is not supported (motor record will stop any started JOGGING cmd)


## Stop on RDBL pv alarms
Motor record stops motion if the RDBL linked PV is in alarm state (MAJOR or INVALID) independet on if severity propagation is set (disregarding NMS,MS,MSS...)

The simulated position is configured like this:
```
  field(LOW,  "-50")
  field(LOLO, "-60")
  field(HIGH, "50")
  field(HIHI, "60")
```
IMPORTANT: If you use an incremental encoder linked to calc record, like in this example. You can sometimes experience stops during homing sequence since then the motion axis might go outside of the alarm limits defined. Normally motor record driver will not update the posiion during homing but I will happen for instance when activating limit switch or homing switch. Then a stop could occur.
This is ofcource no problem if the RDBL linked value is absolute like intended.

## How to move when RDBL alarm interlock 

If motion is interlocked by the RDBL alarm then motion can be executed by setting the URIP to 0 (disabling RDBL).
```
dbpf IOC_TEST:Axis1.URIP 0
```
Motion can now be executed. 
Note: The RDBL link are now not used (retries based on RDBL will not be executed)
