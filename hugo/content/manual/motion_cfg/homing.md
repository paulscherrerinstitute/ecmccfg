+++  
title = "homing"   
weight = 25
chapter = false  
+++  

# homing

The following sequences are available:
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
Additionally, for homing of absolute encoder with **ONE** overflow in the range, please check [here](#homing-of-absolute-encoder-with-one-overflow-in-the-range)

### ECMC_SEQ_HOME_NOT_VALID                = 0
Not a valid homing sequence, can be used if encoder is absolute.

### ECMC_SEQ_HOME_LOW_LIM                  = 1,
1. Axis moves backward until low limit switch and stops
2. Axis moves forward until edge detected in limit switch signal. Position is latched.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

### ECMC_SEQ_HOME_HIGH_LIM                 = 2,
1. Axis moves forward until high limit switch and stops
2. Axis moves backward until edge detected in limit switch signal. Position is latched.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

### ECMC_SEQ_HOME_LOW_LIM_HOME             = 3,
1. Axis moves backward until low limit switch and stops
2. Axis moves forward until edge detected in home switch signal. Position is latched.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

### ECMC_SEQ_HOME_HIGH_LIM_HOME            = 4,
1. Axis moves forward until high limit switch and stops
2. Axis moves backward until edge detected in home switch signal. Position is latched.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

### ECMC_SEQ_HOME_LOW_LIM_HOME_HOME        = 5,
1. Axis moves backward until low limit switch and stops
2. Axis moves forward until edge detected in home switch signal. Position is latched.
3. Axis continues until second edge of home sensor. Motion is stopped.
4. Axis moves backward until edge of home sensor. Position is latched.
5. Homing is performed. ECMC_HOME_POS will be the new position at the center point of the two latched positions in step 2 and 4. 

### ECMC_SEQ_HOME_HIGH_LIM_HOME_HOME       = 6,
1. Axis moves forward until low limit switch and stops
2. Axis moves backward until edge detected in home switch signal. Position is latched.
3. Axis continues until second edge of home sensor. Motion is stopped.
4. Axis moves forward until edge of home sensor. Position is latched.
5. Homing is performed. ECMC_HOME_POS will be the new position at the center point of the two latched positions in step 2 and 4. 

### ECMC_SEQ_HOME_BWD_HOME                 = 7,
1. Axis moves backward until positive edge detected in limit switch signal. Position is latched. (polarity of home sensor can be changed)
2. Axis stops
3. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 1. 

### ECMC_SEQ_HOME_FWD_HOME                 = 8,
1. Axis moves forward until positive edge detected in limit switch signal. Position is latched. (polarity of home sensor can be changed)
2. Axis stops
3. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 1. 

### ECMC_SEQ_HOME_BWD_HOME_HOME            = 9,
1. Axis moves backward until positive edge detected in limit switch signal. Position is latched. (polarity of home sensor can be changed)
2. Axis contiues to move until a negative edge of the home sensor is detected. Axis stops.
3. Axis moves forward until positive edge detected in limit switch signal. Position is latched. (polarity of home sensor can be changed)
4. Homing is performed. ECMC_HOME_POS will be the new position at the center point of the two latched positions in step 2 and 4. 

### ECMC_SEQ_HOME_FWD_HOME_HOME            = 10,
1. Axis moves forward until positive edge detected in limit switch signal. Position is latched. (polarity of home sensor can be changed)
2. Axis contiues to move until a negative edge of the home sensor is detected. Axis stops.
3. Axis moves backward until positive edge detected in limit switch signal. Position is latched. (polarity of home sensor can be changed)
4. Homing is performed. ECMC_HOME_POS will be the new position at the center point of the two latched positions in step 2 and 4. 

### ECMC_SEQ_HOME_LOW_LIM_INDEX            = 11,
1. Axis moves backward until low limit switch and stops
2. Axis moves forward until the predefined index signals (ECMC_HOME_LATCH_COUNT_OFFSET)from the encoder is encountered. Position is latched at the desired index position.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

Some additional parameters need to be defined for this homing sequence should work (Example for el5101 ):
```
epicsEnvSet("ECMC_EC_ENC_LATCHPOS",       "ec0.s3.encoderLatchPostion01")     # Ethercat entry for latch position (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_CONTROL",  "ec0.s3.encoderControl01.0")        # Ethercat entry for latch control (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_STATUS",   "ec0.s3.encoderStatus01.0")         # Ethercat entry for latch status (only valid for home seq 11,12)
epicsEnvSet("ECMC_HOME_LATCH_COUNT_OFFSET","2")                               # Number of latch/over/under-flow for home (home seq 11,12,21,22)
```

yaml-based EL51xx:
```
encoder:
  position: ec$(MASTER_ID).s$(ENC_SID).positionActual$(ENC_CHAN)
  type: 0                                                                 # Type (0=Incremental, 1=Absolute)
  numerator: -3.1415926                                                   #
  denominator: 118000                                                     #
  bits: 32                                                                # Total bit count of encoder raw data
  primary: 0
  control: 'ec$(MASTER_ID).s$(ENC_SID).encoderControl$(ENC_CHAN)'
  status: 'ec$(MASTER_ID).s$(ENC_SID).encoderStatus$(ENC_CHAN)'
  position: 0
  latch:
    position: 'ec$(MASTER_ID).s$(ENC_SID).encoderLatchPostion$(ENC_CHAN)' # Link to latched value. Used for some homing seqs
    control: 0                                                            # Bit in encoder control word to arm latch. Used for some homing seqs
    status: 0                                                             # Bit in encoder status word for latch triggered status. Used for some homing seqs
  homing:
    type: 11                                                              # low limit, encoder index
    latchCount: 1                                                         # latch number to ref on (1=ref on first latch)
```

**Backround to the cfgs (control and status word for latching)**
* bit 0 of control word is: 0x7000:01 - Enable latch on index
* bit 0 of status word is: 0x6000:01 - Latch occured 


### ECMC_SEQ_HOME_HIGH_LIM_INDEX            = 12,
1. Axis moves forward until high limit switch and stops
2. Axis moves backward until the predefined index signals (ECMC_HOME_LATCH_COUNT_OFFSET) from the encoder is encountered. Position is latched at the desired index position.
3. Axis stops
4. Homing is performed. ECMC_HOME_POS will be the new position at the position latched in step 2. 

Some additional parameters need to be defined for this homing sequence should work (Example for el5101 ):
```
epicsEnvSet("ECMC_EC_ENC_LATCHPOS",       "ec0.s3.encoderLatchPostion01")     # Ethercat entry for latch position (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_CONTROL",  "ec0.s3.encoderControl01.0")        # Ethercat entry for latch control (only valid for home seq 11,12)
epicsEnvSet("ECMC_EC_ENC_LATCH_STATUS",   "ec0.s3.encoderStatus01.0")         # Ethercat entry for latch status (only valid for home seq 11,12)
epicsEnvSet("ECMC_HOME_LATCH_COUNT_OFFSET","2")                               # Number of latch/over/under-flow for home (home seq 11,12,21,22)
```

yaml-based EL51xx:
```
encoder:
  position: ec$(MASTER_ID).s$(ENC_SID).positionActual$(ENC_CHAN)
  type: 0                                                                 # Type (0=Incremental, 1=Absolute)
  numerator: -3.1415926                                                   #
  denominator: 118000                                                     #
  bits: 32                                                                # Total bit count of encoder raw data
  primary: 0
  control: 'ec$(MASTER_ID).s$(ENC_SID).encoderControl$(ENC_CHAN)'
  status: 'ec$(MASTER_ID).s$(ENC_SID).encoderStatus$(ENC_CHAN)'
  position: 0
  latch:
    position: 'ec$(MASTER_ID).s$(ENC_SID).encoderLatchPostion$(ENC_CHAN)' # Link to latched value. Used for some homing seqs
    control: 0                                                            # Bit in encoder control word to arm latch. Used for some homing seqs
    status: 0                                                             # Bit in encoder status word for latch triggered status. Used for some homing seqs
  homing:
    type: 12                                                              # high limit, encoder index
    latchCount: 1                                                         # latch number to ref on (1=ref on first latch)
```

**Backround to the cfgs (control and status word for latching)**
* bit 0 of control word is: 0x7000:01 - Enable latch on index
* bit 0 of status word is: 0x6000:01 - Latch occured 


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
2. Axis moves forward until limit switch change state 
3. Axis stops
4. Homing is performed. The multi-turn bits will be homed to the value of ECMC_HOME_POS also considering a offset of turns defined in ECMC_HOME_LATCH_COUNT_OFFSET.

Some additional parameters are important for this homing sequence should work (example):
```
epicsEnvSet("ECMC_ENC_BITS"               "25")                       # Total bit count of encoder raw data
epicsEnvSet("ECMC_ENC_ABS_BITS",          "12")                       # Absolute bit count (for absolute encoders) always least significant part of ECMC_ENC_BITS
epicsEnvSet("ECMC_HOME_LATCH_COUNT_OFFSET","2")                       # Number of over/under-flow for home (home seq 11,12,21,22)
```

### ECMC_SEQ_HOME_HIGH_LIM_SINGLE_TURN_ABS = 22,
1. Axis moves forward until high limit switch and stops
2. Axis moves backward until limit switch change state 
3. Axis stops
4. Homing is performed. The multi turn bits will be homed to the value of ECMC_HOME_POS also considering a offset of turns defined in ECMC_HOME_LATCH_COUNT_OFFSET.

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
1. Optional: set drive mode to homing (and wait for mode read-back)
3. Set trigg of homing (bit)
4. Wait for homing ready (bit). Reference the ecmc encoder object on rising edge of the homing ready bit
5. Optional: Change drive mode back to motion (and wait for mode read-back)
6. Optional: Init post move if configured

Currently used for smaract:
[smaracat example](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/test/smaract)
In this example also the drive modes is automatically handled by ecmc.

## setting polarity of home sensor
For some of the sequences it could be useful to change the polarity of the home sensor. That can be done with the following command:
```
"Cfg.SetAxisMonHomeSwitchPolarity(int axisIndex, int polarity)";
# polarity==0 is NC (default)
# polarity==1 is NO
```

## Homing of absolute encoder with **ONE** overflow in the range


**ALWAYS** adjust the absolute encoder so that no overflows occur within the motion range if possible.
However, for some situations it might be hard to adjust the encoder and then a special homing needs to be performed. No dedicated homing seq exists for this in ecmc but it can be handled in plc code (needs ecmc 9.6.2).

Example: 
```
/*
  PLC code to home an axis with an absoliye encoder which has ONE overflow in the range
  If actual encoder value is higher than ${THRESHOLD} it will be referenced to current actual position - ${RANGE}.

  NOTE: Make sure the default axis encoder scaling offset is made correct for the lower part of the raw values.

  macros:
    AX_ID     : ID of axis
    ENC_ID    : ID of encoder (starts from 1)
    THRESHOLD : Threshold to identfy overflow  (in EGU)
    RANGE     : The total range of the encoder both multi turn and single turn (in EGU)
    DBG       : Printout debug messages set to empty (DBG='')
*/

if(${SELF}.firstscan) {  
  var plc:=${SELF_ID};
  ${DBG=#}println('PLC ',plc,' Initiating homing seq for abs. encoder with overflow');
};

if(mc_get_enc_ready(${AX_ID=1},${ENC_ID=1}) and not(static.encoderHomed)) {
  ${DBG=#}println('Checking if homing encoder is needed');

  /* Set the new position if needed */
  if(mc_get_act_pos(${AX_ID=1},${ENC_ID=1}) > ${THRESHOLD=0}) {
   ${DBG=#}println('Homing encoder to: ', mc_get_act_pos(${AX_ID=1},${ENC_ID=1})-${RANGE=0});
   mc_set_act_pos(${AX_ID=1},${ENC_ID=1},mc_get_act_pos(${AX_ID=1},${ENC_ID=1})-${RANGE=0});
  } else {
    ${DBG=#}println('Homing not needed!');
  };

  static.encoderHomed${AX_ID=1}_${ENC_ID=1}:=1;
}

/* Do not allow power on axis if encoder is not homed*/
if(not(static.encoderHomed${AX_ID=1}_${ENC_ID=1})) {
    ${DBG=#}println('Waiting for encoder ready and homing...')
    mc_power(${AX_ID=1},0);
};
```
