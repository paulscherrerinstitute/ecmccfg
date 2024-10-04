# Directory for common plc code snippets

## master_slave scripts
PLC-files for synchronization can be found in the sub-dir "master_slave".
```
axis_kin*plc_inc
axis_sm.plc_inc
```
Examples can be found in examples/PSI/best_practice/motion/master_slave/

## Homing of abs encoder with ONE overflow in range
home_abs_encoder_overflow.plc_inc


With the following main.plc file (macros can also be passed through PLC_MACROS when loading the PLC):
```
substitute "THRESHOLD=30,RANGE=360,DBG='',DIR=-1"
include "home_abs_enc_overflow.plc_inc"
```

the code will look like this:
```
/*
  PLC code to home an axis with an absolute encoder which has ONE overflow in the range.
  Can be configured to handle 2 cases:
   * DIR = -1 : If actual encoder value is lower than THRESHOLD it will be referenced to current actual position + RANGE.
   * DIR = +1 : If actual encoder value is higher or equal to THRESHOLD it will be referenced to current actual position - RANGE.
  
  NOTE: Make sure the default axis encoder scaling offset is correct for the lower or upper part of the raw values (depending on DIR).

  The PLC-code can be included several times in the same file as long as the AX_ID and ENC_ID are unique. 
  However, be careful with PLC_DISABLE=1 since the entire PLC will be disabled (also other included files).

  Macros:
    AX_ID       : ID of axis
    ENC_ID      : ID of encoder (starts from 1)
    THRESHOLD   : Threshold to identify overflow  (in EGU)
    RANGE       : The total range of the encoder both multi turn and single turn (in EGU)
    DBG         : Printout debug messages set to empty (DBG='')
    DIR         : Threshold direction
                   -1 : Reference if value is below threshold (default)
                   +1 : Reference if value is over or equal to threshold
    PLC_DISABLE : Disable PLC when homing is finished. (default 0 = keep PLC running, safest if also other code is included)
*/

if(plc0.firstscan) {  
  var plc:=0;
  println('PLC ',plc,' Initiating homing seq for abs. encoder with overflow.');
};

if(mc_get_enc_ready(1,1) and not(static.encoderHomed_Ax1_Enc1)) {
  var homeNeeded_Ax1_Enc1:=0;
  println('Checking if homing encoder is needed..');
  
  /* Home if below threshold */
  if(-1 < 0){
    homeNeeded_Ax1_Enc1:=mc_get_act_pos(1,1) < 30;
  } else { /* Home if above threshold */
    homeNeeded_Ax1_Enc1:=mc_get_act_pos(1,1) >= 30;
  };

  if(homeNeeded_Ax1_Enc1) {
    println('Homing encoder to: ', mc_get_act_pos(1,1) + -1 *(-1) * 360);
    mc_set_act_pos(1,1,mc_get_act_pos(1,1) + -1 * (-1) * 360);   
  } else {
    println('Homing not needed (axis in region of valid axis scaling).');
  };
  static.encoderHomed_Ax1_Enc1:=1;

  if(0>0) {
    println('Disabling PLC.');
    plc0.enable:=0;
  }
};

/* Do not allow power on axis if encoder is not homed*/
if(not(static.encoderHomed_Ax1_Enc1)) {    
    mc_power(1,0);
};
```