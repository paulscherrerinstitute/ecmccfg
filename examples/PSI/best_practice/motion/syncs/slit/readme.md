# Two examples of a slit system

## dir slit_matrix

Kinematics are defined by "matrices". This is the preferred way of defining kinematics:
```
/* Forward kinematics to calculate virtual axes from real axes
   | CEN    |  = FWD *   | S1_LO |
   | GAP    |            | S2_HI |
   
   Equations:
     ax{AX_CEN}.enc.actpos:=(ax{AX_LO}.enc.actpos+ax{AX_HI}.enc.actpos)/2;
     ax{AX_GAP}.enc.actpos:=ax{AX_HI}.enc.actpos-ax{AX_LO}.enc.actpos;
*/

var FWD1[2] := {0.5, 0.5};
var FWD2[2] := { -1,  1 };

/* Inverse kinematics to calculate real axes from virtal axes
   | S1_LO    |  = INV *   | CEN |
   | S2_HI    |            | GAP |

   Equations:
     ax{AX_LO}.traj.extsetpos:=ax{AX_CEN}.traj.setpos-ax{AX_GAP}.traj.setpos/2;
     ax{AX_HI}.traj.extsetpos:=ax{AX_CEN}.traj.setpos+ax{AX_GAP}.traj.setpos/2;
*/

var INV1[2] := {  1,   -0.5};
var INV2[2] := {  1,    0.5};

####### Kinematics for slit system. 
# Macros cannot be used in an include. In order to find files, the loadPLCFile.cmd parameter "INC" defines the dirs that MSI will look for the file)
include "axis_kin_2DoF.plc_inc"

```

## slit_equations
kinematics are defined by equations (file can be included from ecmccfg/plc_lib):
```
#- forward kinematics
ax${AX_CEN}.enc.actpos:=(ax${AX_LO}.enc.actpos+ax${AX_HI}.enc.actpos)/2;
ax${AX_GAP}.enc.actpos:=ax${AX_HI}.enc.actpos-ax${AX_LO}.enc.actpos;
#- inverse kinematics (Note: use extsetpos to ensure write is to external setpoint)
ax${AX_LO}.traj.extsetpos:=ax${AX_CEN}.traj.setpos-ax${AX_GAP}.traj.setpos/2;
ax${AX_HI}.traj.extsetpos:=ax${AX_CEN}.traj.setpos+ax${AX_GAP}.traj.setpos/2
```
In the example also dynamic softlimits are calcualted

# State machine states

Both example uses a statemachine that ensures seamless use of virtual or physical axes:
* When a physical/slaved axis get an command then commands to the virtual/master axes are blocked
* When a virtaul/master axis gets an command then commands to the phisical/slaved axes are blocked
* Both physical/slave axes accepts commands at the same time.
* Both virtual/master axes accepts commands at the same time.

The state machine has 4 states:
* IDLE: startup state and waiting for commands
* SLAVES: Any physical/slaved axis executing a motion command. After finished commands the state will be set to "IDLE"
* MASTERS: Any virtual/master axis executing a motion command. If a slave is interlocked during a command then the state will automatically be set to "SLAVES". After finished commands and disabling of all virtual/master axes the state will be set to "IDLE".
* RESET: State to disable all axes, reset errors and go to IDLE state

The state machine can be reset by writing to the state PV accesible in the "ecmcMstSlvSMxx.ui" panel:
```
caqtdm -macro "IOC=c6025a-06,ID_2=00,ID=0" ecmcMstSlvSMxx.ui 
```
From this panel the state machien can also be disabled.

In order for the state transisions to work well the ecmc auto-enable/disable needs to be configured. If an axis should be scanned then make sure that the axis.autoDisable time out is long enough tp provent the axis from deisbling at each scan point (this is valid for scanning both the physical/slaves and the virtual/master axes).

# Panel

The main ecmc panel:
```
caqtdm -macro "IOC=c6025a" ecmcMain.ui
```
