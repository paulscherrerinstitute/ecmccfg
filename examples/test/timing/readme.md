# Use system clock as base for motion

Control motion to a specific position/phase at a certain absolute system time. The intention is that this can be used togheter with ptp or mrf sync of system clock (and use of CLOCK_REALTIME in ecmc).

Three axes are defined:
1. timing
2. phys
3. phase

NOTE: In this example CLOCK_REALTIME is not used (CLOCK_MONOTONIC is used).

## timing axis
The timing axis is basically just getting the absoute system time and generates a sawtooth with a period of 1 second:

```
var currtime:=ec_get_time()/1e9;")
ax${ECMC_AXIS_TIME_NUM}.enc.actpos:=(currtime-trunc(currtime))*360;")
```

## phys axis

The pysical asix is coonnected to the actual hardware (stepper motor). 
This axis is configured with external PLC code for setpoint:
```
epicsEnvSet("ECMC_AXIS_EXPR_LINE_5",           "ax${ECMC_AXIS_PHYS_NUM}.traj.setpos:=ax${ECMC_AXIS_TIME_NUM}.enc.actpos-ax${ECMC_AXIS_PHASE_NUM}.traj.setpos|")
```
Right now this code is in the phase.sax since the phys.sax will not execute untill tyhe source have been changed.

## phase axis

This axis defines the distance (phase) between the phys axis and the timing axis:

```
var phase:=ax${ECMC_AXIS_TIME_NUM}.enc.actpos-ax${ECMC_AXIS_PHYS_NUM}.enc.actpos;")
if(phase > 180) {phase:=-(360-phase)|};")
if(phase < -180) {phase:=360+phase|};")
ax${ECMC_AXIS_PHASE_NUM}.enc.actpos:=phase;")
```

## Concept

PLC code controls a few states:
1: Enabling of phys motor
2: Rampup motor to constant velocity (same as timing axis)
3: When velocity stabilized (the phase acttpos should be constant):
- the phase axis is enabled (to fix the phase setpoint).
- The source of the phys axis is switched to PLC (external).

Now the phase axis can be controlled to any desired position/phase (not handled automatically right now).


NOTES:
1. The external PLC setpoint of phys axis is written in phase.sax. The reason is that it needs to be executing all the time and the phys.sax is only executed after the source change.
2. Since the execution flow there will always be an error of 0.360 deg in the phase axis. This corresponds to one cylcle at 360deg/s and is there because of the execution flow. To avoid this it could be possible to add a separate plc containing all syncs that is executed after the axes. Right now, to compensate for this the phase setpoint needs to be compensated with -0.36. So if the desired setpoint is 10 degrees then 9.64 should be entered.
3. This demo does not take full advantage of dc-clocks (copensate for encoder dc time and drive dc-time). Need to look into.

