+++  
title = "Drive modes CSV, CSP, CSP-PC"
weight = 21
chapter = false  
+++

There's three different modes that can can be used in ecmc toghether with most drives:
* CSV: Cyclic Sync. Velocity, (velocity setpoint sent to drive)
* CSP: Cyclic Sync. Position, (position setpoint sent to drive)
* CSP-PC: Cyclic Sync. Position with centralized position controller, (position setpoint sent to drive)

Other modes also exist, like Cyclic Sync Torque (torque/current setpoint to drive), which also can be used. However, these modes are not supported by the ecmc axis object. Still these modes can be used from PLC code or from logic in EPICS.

### Control loops

The control loops are executed at different locations depending on which mode:

|          | Current loop | Velocity loop | Position loop  |Comment| 
| -------- | ------------ | ------------- |--------------- |-------| 
| CSV      | drive        | drive         | ecmc           |       |
| CSP      | drive        | drive         | drive          | ecmc generates trajectory |
| CSP-PC   | drive        | drive         | drive and ecmc | dual position loop |

#### CSV
This is the most common mode for small drives like stepper-drives.
In CSV the position loop is centralized. That means that any EtherCAT data can be used as feedback (not only a source connected toi the drive directly). This  high flexibility is the main reason why this mode is the most common for small drive solutions. A common usecase for CSV:
* Motion stage driven with a open loop stepper motor connected to EL7041 terminal
* Linear feedback by absolute encoder (BISS-C) connected to EL5042 terminal

ecmccfg configurations normally defaults to CSV with one exception:
* Smaract MCS2 EC. This drive does not support CSV, see "Hardware support below"

In CSV-mode the centralized position controller is normally a simple P controller (only tuning of kp normally needed).
Tuning of the control loops in the drive is sometimes also needed (depending on which hardware).

#### CSP
In pure CSP-mode, the position loop is executed in the drive, this means that the encoder must be connected directly to the drive. the trajectory is still generated centrally in ecmc.

CSP is therefore more common for "bigger" servo drives where the motor are equipped with an encoder or the drive has support for multiple encoders.
CSP normally performs better than CSV, since the position loop is closer to hardware, the drawback with CSP is that it is much less flexible than CSV. As a side note, EL7041 does not support CSP, however, EL7062 does, see "Hardware support below".

In order to configure a drive in CSP or CSP_PC, normally the slave need to be applied with the "_CSP" suffix:
```
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "SLAVE_ID=3,HW_DESC=EL7062_CSP"
```
In CSP, the ecmc position control parameters are not active.
Tuning of the control loops in the drive is sometimes also needed (depending on which hardware).

#### CSP-PC
CSP-PC where PC stands for Position Control, is basically CSP but with the ecmc position loop also enabled. This results in two position control loops, one in the drive and one in ecmc. The idea is that the position loops are working with different encoders. Therefore an configuration for CSP-PC must contain at least 2 encoder (to make sense). For instance the drive position loop could be linked to the open loop counter and the centralized loop could be linked to an linear absolute encoder.

See "Hardware support below" to understand which drives support the different modes.

In order to run in CSP-PC the drive must be configured in CSP mode:

```
axis:
  id: ${AXIS_ID=1}                                    # Axis id
  mode: CSP
```
Additionally the system must know which encoder is connected to the drive, which is configured with the "useAsCSPDrvEnc" setting. This encoder is used for the position loop in the drive.
This could be an any encoder that is available in the drive, example:
* open loop counter
* absolute rotary encoder from an EL72xx/AM81xx encoder 
* incremental encoder connected to EL7062
```
encoder:
  desc: CSP drive encoder
  ...
  useAsCSPDrvEnc: 1    # use this encoder as CSP drive encoder
  ...
```
Finally the encoder for the centralized loop must be defined. This is defined in the normal by adding an encoder that has the encoder.primary bit set. The primary encoder is used for the centralized position loop:
```
encoder:
  desc: Linear encoder
  type: 1
  ...
  primary: 1
  ...
```
In CSP-PC, the ecmc position control loop are active and therefore the ecmc position control parameters needs tuning.
Since a position setpoint is sent to the drive, a PI controller is normally needed (both kp and ki needs tuning).
Tuning of the control loops in the drive is sometimes also needed (depending on which hardware).

#### Hardware support

This is the current supported modes for some common drives used with ecmc:
|          | CSV        | CSP         | CSP-PC      |Comment| 
| -------- | ---------- | ------------|------------ |-------| 
| Ex704x   | yes        | no          | no          |       |
| Ex703x   | yes        | no          | no          ||
| EL7062   | yes        | yes         | yes         |Firmware bug fix needed for CSV.. |
| Ex72xx   | yes        | yes         | yes         ||
| EL7411   | yes        | yes         | yes         |Not used yet..|
| MCS2 EC  | no         | yes         | yes         ||
| iPOS4808 | yes        | no          | no          ||
