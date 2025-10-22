# Homing on index
The EL7062 encoders works a bit different compared to EL51xx. For EL7062 the touchProbes needs to be configured.

## SDOs

### Configure latch on index
```
# CH1 Set touch probe to latch on index pulse
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8001,0x11,5,2)"

# CH2 Set touch probe to latch on index pulse
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8101,0x11,5,2)"

```
### Configure which encoder to latch
Default cfg is:
* primary encoder: step counter
* secondary encoder: incremental encoder

```
# CH1 Set touch probe source 01 to secondary encoder
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8001,0x15,1,2)"

# CH2 Set touch probe source 01 to secondary encoder
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8101,0x15,1,2)"
```

## PDOs
In order to enable a homing sequence a few bits in the control word needs to be set. Currently ecmc does not support this, for testing this can be done manually.

The control word is mapped as:
```
c6025a-08:m0s003-Tp01-Cmd
c6025a-08:m0s003-Tp02-Cmd 
```
Make the settings like below to be able to latch a value on positive edge:
|bit| ch  | name | desc| value|
|---| --- |---   | --- |---   |
|0  | 1   |enable| enable TP | TRUE |
|1  | 1   |cont. | cont. latching | FALSE |
|2  | 1   |trigg. mode b1| trig. mode ? | TRUE |
|3  | 1   |trigg. mode b2| trig. mode ? | FALSE |
|4  | 1   |enable pos edge | latch on pos edge| TRUE |
|5  | 1   |enable neg edge | latch on neg edge| FALSE |
|6  | 1   |empty | empty| FALSE |
|7  | 1   |empty | empty| FALSE |
|8  | 2   |enable| enable TP | TRUE |
|9  | 2   |cont. | cont. latching | FALSE |
|10 | 2   |trigg. mode b1| trig. mode ? | TRUE |
|11 | 2   |trigg. mode b2| trig. mode ? | FALSE |
|12 | 2   |enable pos edge | latch on pos edge| TRUE |
|13 | 2   |enable neg edge | latch on neg edge| FALSE |
|14 | 2   |empty | empty| FALSE |
|15 | 2   |empty | empty| FALSE |


# Encoder cfgs
```
encoder:
  desc: Inc RS422
  numerator: 360                                       # Scaling numerator example 1 mm/rev
  denominator: 1048576                                 # Scaling denominator example 4096 ticks per 360 degree
  type: 0                                              # Type: 0=Incremental, 1=Absolute
  bits: 32                                             # Total bit count of encoder raw data
  absBits: 0                                           # Absolute bit count (for absolute encoders) always least significant part of 'bits'
  position: ec0.s$(ENC_SID).positionActual${ENC_CH=01}_2 # Ethercat entry for actual position input (encoder)
  status: ec0.s$(ENC_SID).touchProbeStatus${ENC_CH=01}         # mandatory only if 'warning' or 'error' are used
  control: ec0.s$(ENC_SID).touchProbeControl${ENC_CH=01}
  primary: True
  latch:
    position: ec0.s$(ENC_SID).touchProbePositionPos$(ENC_CH=01)_1 # Link to latched value. Used for some homing seqs
    control:  0                                        # Bit in encoder control word to arm latch. Used for some homing seqs
    status: 1                                          # Bit in encoder status word for latch triggered status. Used for some homing seqs
  homing:
    type: 11                                           # Homing sequence type
    position: 0                                        # Position to reference encoder to
    velocity:
      to: 10                                           # Velocity to cam/sensor (used for some homing seqs)
      from: 5                                          # Velocity from cam/sensor (used for some homing seqs)
    acceleration: 20                                   # Acceleration during homing
    deceleration: 100                                  # Deceleration during homing
    refAtHome: 1                                       # If homing is executed then set position of this encoder
    latchCount: 1                                      # latch number to ref on (1=ref on first latch)
  useAsCSPDrvEnc: True
```

# New functionality in ecmc needed
Need to be able write a value at a certain bit-offset location in teh control word.

```
   encoder:
     ....
     status: ec0.s$(ENC_SID).touchProbeStatus${ENC_CH=01}         # mandatory only if 'warning' or 'error' are used
     control: ec0.s$(ENC_SID).touchProbeControl${ENC_CH=01}
     latch:
       position: ec0.s$(ENC_SID).touchProbePositionPos$(ENC_CH=01)_1 # Link to latched value. Used for some homing seqs
       control:  0                                        # Start bit in encoder control word to arm latch. Used for some homing seqs
       status: 1                                          # Bit in encoder status word for latch triggered status. Used for some homing seqs
NEW    armValue: 21  or 0b10101 or 0x15                   # Value to write at encoder.control.control , see table above 0b00010101 = 21
NEW    armValueBits: 8                                    # bit count to write to encoder.control.control
     homing:
       type: 11                                           # Homing sequence type
       position: 0                                        # Position to reference encoder to
       velocity:
         to: 10                                           # Velocity to cam/sensor (used for some homing seqs)
         from: 5                                          # Velocity from cam/sensor (used for some homing seqs)
       acceleration: 20                                   # Acceleration during homing
       deceleration: 100                                  # Deceleration during homing
       refAtHome: 1                                       # If homing is executed then set position of this encoder
       latchCount: 1                                      # latch number to ref on (1=ref on first latch)
```

# PVs:
```
c6025a-08:m0s003-Tp01-PosLtchPosAct01
c6025a-08:m0s003-Tp01-NegLtchPosAct01
c6025a-08:m0s003-Tp01-Cmd-RB
c6025a-08:m0s003-Tp02-PosLtchPosAct01
c6025a-08:m0s003-Tp02-NegLtchPosAct01
c6025a-08:m0s003-Tp02-Cmd-RB
c6025a-08:m0s003-Tp01-EnaAct01
c6025a-08:m0s003-Tp01-PosLtch01
c6025a-08:m0s003-Tp01-NegLtch01
c6025a-08:m0s003-Tp01-BI01
c6025a-08:m0s003-Tp01-EnaAct02
c6025a-08:m0s003-Tp01-PosLtch02
c6025a-08:m0s003-Tp01-NegLtch02
c6025a-08:m0s003-Tp01-BI02
c6025a-08:m0s003-Tp02-EnaAct01
c6025a-08:m0s003-Tp02-PosLtch01
c6025a-08:m0s003-Tp02-NegLtch01
c6025a-08:m0s003-Tp02-BI01
c6025a-08:m0s003-Tp02-EnaAct02
c6025a-08:m0s003-Tp02-PosLtch02
c6025a-08:m0s003-Tp02-NegLtch02
c6025a-08:m0s003-Tp02-BI02
c6025a-08:m0s003-Tp01-Stat
c6025a-08:m0s003-Tp02-Stat
c6025a-08:m0s003-Tp01-Cmd
c6025a-08:m0s003-Tp02-Cmd
```
