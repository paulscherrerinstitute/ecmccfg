# Introduction dual loop CSP
## Description of use-case:
    Normally, in CSP-mode, no centralized position control will be executed,
    instead, the position control loop is moved to the drive. It's however
    possible to activate the centralized ecmc position loop also if needed.
    A use case could be a rotary servo motor (in CSP-mode) driving a stage equipped with 
    a linear encoder.

# Details:
    CSP normally must be based on the encoder connected to the drive/motor, in this 
    case the position control loop is only performed in the drive and ecmc
    will only send position setpoints. In order to enable (ecmc) position control
    on the linear encoder, then, also the linear encoder needs to be configured.
    In this example, the linear encoder is simulated with the same rotary encoder but 
    with a different scaling (in order for the two encoders to show different 
    values). The simulated linear encoder should be selected as primary (for control).
    The drive object still needs to know the drive actual position in order to send
    accurate position setpoints. This is done by selecting the encoder with 
    "ecmcConfigOrDie "Cfg.SelectAxisEncCSPDrv(<axis id>,<enc_id>)" or ecmccfg or in yaml 
    "encoder.useAsCSPDrvEnc=True".
    This encoder needs to have the proper scaling for the drive.
    The system will now also use the centralized ecmc position control loop,
    resulting in 2 position loops are activated, one in ecmc and one in the drive.
    In this case, the ecmc-PID parameters needs to be defined and then also tuned.
    Normally a PI controller is needed. The control output to the drive will be 
    a position setpoint that is controlled by the normal ecmc PID controller.
    If the "Cfg.SelectAxisEncCSPDrv(<axis id>,<enc_id>)" is not executed or if the 
    primary encoder is selected, then the drive object will by default use the
    the primary encoder and the position loop in ecmc will be disabled (normal CSP).
    So, in order to use dual loops, the primary encoder and the CSP drive encoder 
    needs to be different.

# Configuration for Ex72xx-xxxx
* Lab test stage (1mm/rev)
* Motor : AM8111-0F20

## Scalings
Config for scaling in mm, mm/s, mm/s2

## Motor AM8111-XFX0
Data about the motor can be found here:
https://infosys.beckhoff.com/english.php?content=../content/1033/am8100/index.html&id=

Important for scaling factors in axis.yaml is the motor pole count. For the AM8111-XFX0 motor the pole count is 6.

## Encoder scaling
Only the encoder integrated encoder is configured in this example. The specification of the encoder for a AM8111-0F20 motor:

```
One Cable Technology for power and feedback: feedback transmission via motor cable, no feedback cable necessary, electronic nameplate, multi-turn, absolute position within 4096 revolutions, 18 bit resolution.
```
However, when connecting to an Ex72xx drive the single turn count will be 20bits and 12bits multiturn, resulting in a total of 32bits absolute bits.

* encoder.numerator: Travels 1 mm/rev
* encoder.denominator: Resolution: 1048576 counts (20bits) per = 1mm
* encoder.absBits: 32 bits (20bits+12bits)
* encoder.type: Absolute (type 1)
* ecnoder.absOffset: Offset to 0 position of linear stage (-1000 in this example)

```
# The encoder on most motors are 20bit single turn and 12 bit multiturn (4096 turns)
encoder:
  type: 1
  position: ec0.s$(DRV_ID).positionActual01
  numerator: 1
  denominator: 1048576
  bits: 32
  absBits: 32
  absOffset: -1000
```

### Drive scalings CSP
Should be the same as for the motor encoder
```
drive:
  numerator: 1  # mm/s, Max speed is 8000 rev/sec for drive (6 pole motor)
  denominator: 1048576
  type: 1                            # Stepper: 0, DS402: 1 (servos)
  control: ec0.s$(DRV_ID).driveControl01
  status: ec0.s$(DRV_ID).driveStatus01
  setpoint: ec0.s$(DRV_ID).velocitySetpoint01
  reset: 7
```

## Switches
In standard setup switches are feed from 24V output, for the lab 4ax motion crate this is not the case.
However, the configuration for feeding switches (axis.feedSwitchesOutput) have been added anyway:
```
axis:
  id: ${AX_ID=1}
  feedSwitchesOutput: ec0.s$(BO_ID).binaryOutput01.0 # Ethercat entry for feed switches
```

