# Notes related to homing

## Parameters available for defining homing behaviour
```
epicsEnvSet("ECMC_HOME_PROC",             "3")                              # Homing sequence
epicsEnvSet("ECMC_HOME_POS",              "0.0")                            # New desired position after homing
epicsEnvSet("ECMC_HOME_VEL_TO",           "5")                              # Velocity used when seraching for first cam 
epicsEnvSet("ECMC_HOME_VEL_FRM",          "4")                              # Velocity used when seraching for cams (during position latching)
epicsEnvSet("ECMC_HOME_ACC",              "21")                             # Acceleration used during homing
epicsEnvSet("ECMC_HOME_DEC",              "100")                            # Deceleration used during homing
epicsEnvSet("ECMC_HOME_POS_MOVE_ENA",     "0")                              # Enable move to position after successfull homing 
epicsEnvSet("ECMC_HOME_POS_MOVE_TARG_POS","0")                              # Target position to go to after successfull homing
epicsEnvSet("ECMC_EC_ENC_LATCHPOS",       "ec0.s3.encoderLatchPostion01")   # Ethercat entry for latch position (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_CONTROL",  "ec0.s3.encoderControl01.0")      # Ethercat entry for latch control (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_STATUS",   "ec0.s3.encoderStatus01.0")       # Ethercat entry for latch status (only valid for home seq 11,12)
epicsEnvSet("ECMC_HOME_LATCH_COUNT_OFFSET","2")                             # Index of latch/over/under-flow for home (home seq 11,12,21,22)
```

## ECMC_HOME_PROC

The follwoing sequences are available:
```
ECMC_SEQ_HOME_NOT_VALID                = 0,
ECMC_SEQ_HOME_LOW_LIM                  = 1,
ECMC_SEQ_HOME_HIGH_LIM                 = 2,
ECMC_SEQ_HOME_LOW_LIM_HOME             = 3,
ECMC_SEQ_HOME_HIGH_LIM_HOME            = 4,
ECMC_SEQ_HOME_LOW_LIM_HOME_HOME        = 5,
ECMC_SEQ_HOME_HIGH_LIM_HOME_HOME       = 6,
ECMC_SEQ_HOME_BWD_HOME                 = 7,
ECMC_SEQ_HOME_FWD_HOME                 = 8,
ECMC_SEQ_HOME_BWD_HOME_HOME            = 9,
ECMC_SEQ_HOME_FWD_HOME_HOME            = 10,
ECMC_SEQ_HOME_LOW_LIM_INDEX            = 11,
ECMC_SEQ_HOME_HIGH_LIM_INDEX           = 12,
ECMC_SEQ_HOME_SET_POS                  = 15,
ECMC_SEQ_HOME_LOW_LIM_SINGLE_TURN_ABS  = 21,
ECMC_SEQ_HOME_HIGH_LIM_SINGLE_TURN_ABS = 22,
ECMC_SEQ_HOME_SET_POS_2                = 25,
ECMC_SEQ_HOME_TRIGG_EXTERN             = 26,
```

### ECMC_SEQ_HOME_NOT_VALID                = 0
Not a valid homing sequence, can be used if encoder is absolute.

### ECMC_SEQ_HOME_LOW_LIM                  = 1,
1. Axis moves backward until low limit switch and stops
2. Axis moves forward untill edge detected in limit switch signal. Position is latched.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

### ECMC_SEQ_HOME_HIGH_LIM                 = 2,
1. Axis moves forward until high limit switch and stops
2. Axis moves backward untill edge detected in limit switch signal. Position is latched.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

### ECMC_SEQ_HOME_LOW_LIM_HOME             = 3,
1. Axis moves backward until low limit switch and stops
2. Axis moves forward untill edge detected in home switch signal. Position is latched.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

### ECMC_SEQ_HOME_HIGH_LIM_HOME            = 4,
1. Axis moves forward until high limit switch and stops
2. Axis moves backward untill edge detected in home switch signal. Position is latched.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

### ECMC_SEQ_HOME_LOW_LIM_HOME_HOME        = 5,
1. Axis moves backward until low limit switch and stops
2. Axis moves forward untill edge detected in home switch signal. Position is latched.
3. Axis continues untill second edge of home sensor. Motion is stopped.
4. Axis moves backward untill edge of home sensor. Position is latched.
5. Homing is performed. ECMC_HOME_POS will be the new position at the center point of the two latched positions in step 2 and 4. 

### ECMC_SEQ_HOME_HIGH_LIM_HOME_HOME       = 6,
1. Axis moves forward until low limit switch and stops
2. Axis moves backward untill edge detected in home switch signal. Position is latched.
3. Axis continues untill second edge of home sensor. Motion is stopped.
4. Axis moves forward untill edge of home sensor. Position is latched.
5. Homing is performed. ECMC_HOME_POS will be the new position at the center point of the two latched positions in step 2 and 4. 

### ECMC_SEQ_HOME_BWD_HOME                 = 7,
1. Axis moves backward untill positive edge detected in home switch signal. Position is latched. (polarity of home sensor can be changed)
2. Axis stops
3. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 1. 

### ECMC_SEQ_HOME_FWD_HOME                 = 8,
1. Axis moves forward untill positive edge detected in home switch signal. Position is latched. (polarity of home sensor can be changed)
2. Axis stops
3. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 1. 

### ECMC_SEQ_HOME_BWD_HOME_HOME            = 9,
1. Axis moves backward untill positive edge detected in limit switch signal. Position is latched. (polarity of home sensor can be changed)
2. Axis contiues to move until a negative edge of the home sensor is detected. Axis stops.
3. Axis moves forward untill positive edge detected in limit switch signal. Position is latched. (polarity of home sensor can be changed)
4. Homing is performed. ECMC_HOME_POS will be the new position at the center point of the two latched positions in step 2 and 4. 

### ECMC_SEQ_HOME_FWD_HOME_HOME            = 10,
1. Axis moves forward untill positive edge detected in limit switch signal. Position is latched. (polarity of home sensor can be changed)
2. Axis contiues to move until a negative edge of the home sensor is detected. Axis stops.
3. Axis moves backward untill positive edge detected in limit switch signal. Position is latched. (polarity of home sensor can be changed)
4. Homing is performed. ECMC_HOME_POS will be the new position at the center point of the two latched positions in step 2 and 4. 

### ECMC_SEQ_HOME_LOW_LIM_INDEX            = 11,
1. Axis moves backward until low limit switch and stops
2. Axis moves forward untill the predefined index signals (ECMC_HOME_LATCH_COUNT_OFFSET)from the encoder is encountered. Position is latched at the desired index position.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

Some additional parameters need to be defined for this homing sequence should work (Example for el5101 ):
```
epicsEnvSet("ECMC_EC_ENC_LATCHPOS",       "ec0.s3.encoderLatchPostion01")     # Ethercat entry for latch position (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_CONTROL",  "ec0.s3.encoderControl01.0")        # Ethercat entry for latch control (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_STATUS",   "ec0.s3.encoderStatus01.0")         # Ethercat entry for latch status (only valid for home seq 11,12)
epicsEnvSet("ECMC_HOME_LATCH_COUNT_OFFSET","2")                               # Number of latch/over/under-flow for home (home seq 11,12,21,22)
```

### ECMC_SEQ_HOME_HIGH_LIM_INDEX            = 12,
1. Axis moves forward until high limit switch and stops
2. Axis moves backward untill the predefined index signals (ECMC_HOME_LATCH_COUNT_OFFSET) from the encoder is encountered. Position is latched at the desired index position.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

Some additional parameters need to be defined for this homing sequence should work (Example for el5101 ):
```
epicsEnvSet("ECMC_EC_ENC_LATCHPOS",       "ec0.s3.encoderLatchPostion01")     # Ethercat entry for latch position (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_CONTROL",  "ec0.s3.encoderControl01.0")        # Ethercat entry for latch control (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_STATUS",   "ec0.s3.encoderStatus01.0")         # Ethercat entry for latch status (only valid for home seq 11,12)
epicsEnvSet("ECMC_HOME_LATCH_COUNT_OFFSET","2")                               # Number of latch/over/under-flow for home (home seq 11,12,21,22)
```

### ECMC_SEQ_HOME_SET_POS                  = 15, (setPosition)
Sequence 15 is resereved for save/restore functionality.  
Use ECMC_SEQ_HOME_SET_POS_2 instead (same but not blocked by motor record).

However the sequence 15 can be triggered like the following:
```
# Turn off amplifier
caput IOC_TEST:Axis1.CNEN 0

# Homing using seq 15 (cannot be triggered from HOMR/HOMF since blocked in motor record)
caput IOC_TEST:Axis1.FOFF 1
caput IOC_TEST:Axis1.SET 1
caput IOC_TEST:Axis1.VAL  <new position value>
caput IOC_TEST:Axis1.FOFF 0
caput IOC_TEST:Axis1.SET 0
```

### ECMC_SEQ_HOME_LOW_LIM_SINGLE_TURN_ABS  = 21,
Indented use for resolvers (single turn absolute). Similar to seq 11 and 12.
1. Axis moves backward until low limit switch and stops
2. Axis moves forward untill limit switch change state 
3. Axis stops
4. Homing is performed. The multi turn bits will be homed to the value of ECMC_HOME_POS also consiering a offset of turns defined in ECMC_HOME_LATCH_COUNT_OFFSET.

Some additional parameters are important for this homing sequence should work (example):
```
epicsEnvSet("ECMC_ENC_BITS"               "25")                       # Total bit count of encoder raw data
epicsEnvSet("ECMC_ENC_ABS_BITS",          "12")                       # Absolute bit count (for absolute encoders) always least significant part of ECMC_ENC_BITS
epicsEnvSet("ECMC_HOME_LATCH_COUNT_OFFSET","2")                       # Number of over/under-flow for home (home seq 11,12,21,22)
```

### ECMC_SEQ_HOME_HIGH_LIM_SINGLE_TURN_ABS = 22,
1. Axis moves forward until high limit switch and stops
2. Axis moves backward untill limit switch change state 
3. Axis stops
4. Homing is performed. The multi turn bits will be homed to the value of ECMC_HOME_POS also consiering a offset of turns defined in ECMC_HOME_LATCH_COUNT_OFFSET.

Note: Only the multi turn bits are updated!

Some additional parameters are important for this homing sequence should work (example):
```
epicsEnvSet("ECMC_ENC_BITS"               "25")                       # Total bit count of encoder raw data
epicsEnvSet("ECMC_ENC_ABS_BITS",          "12")                       # Absolute bit count (for absolute encoders) always least significant part of ECMC_ENC_BITS
epicsEnvSet("ECMC_HOME_LATCH_COUNT_OFFSET","2")                       # Number of over/under-flow for home (home seq 11,12,21,22)
```

### ECMC_SEQ_HOME_SET_POS_2                  = 25, (setPosition)
Sequence 25 is the same as 15 but not blocked by motor record. The sequence will just set a new position of the encoder without any movement.

### ECMC_SEQ_HOME_TRIGG_EXTERN               = 26
Trigger external homing sequence in drive. 
1. Optional: set drive mode to homing (and wait for mode readback)
3. Set trigg of homing (bit)
4. Wait for homing ready (bit). Reference the ecmc encoder object on rising edge of the homing reday bit
5. Optional: Change drive mode back to motion (and wait for mode readback)
6. Optional: Init post move if configured

Currently used for smaract:
[smaracat example](../smaract/smaract.script)
In this exmaple also the drive modes is automatically handled by ecmc.

## Setting polarity of home sensor
For some of the sequenceses it could be usefull to change the polarity of the home sensor. That can be done with the follwoing command:
```
"Cfg.SetAxisMonHomeSwitchPolarity(int axisIndex, int polarity)";
# polarity==0 is NC (default)
# polarity==1 is NO
```
