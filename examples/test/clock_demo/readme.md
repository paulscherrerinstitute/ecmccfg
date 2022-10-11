# Clock demo

Control motion to a specific position/phase at a certain absolute system time. 
The intention is that this configuration can be used togheter with ptp or mrf sync of system clock (and use of CLOCK_REALTIME in ecmc).

In total 8 axes are defined (4 physical and 4 virtual).

Physical axes (running in modulo mode):

1. Hour 0..12h
3. Minute 0..60min
5. Second 0..60s
7. Parts of second 0..1s

The virtual axes are used for calculating phase error between the actual time and the physical axis angle (actual position):

2. Hour phase error [h]
4. Minute phase error [min]
6. Second phase error [s]
8. Parts of second phase error [s]

NOTE: In this example CLOCK_REALTIME is not currently used (CLOCK_MONOTONIC is used).

## time source

The time source that all axes are controlled to are calculated in the time.plc PLC-program:
```
global.currtime:=ec_get_time();

global.nano    := (global.currtime-trunc(global.currtime/1e9)*1e9)/1E9;
global.second  := ec_get_time_local_sec(global.currtime)+global.nano;
global.minute  := ec_get_time_local_min(global.currtime)+global.second/60;
global.hour    := ec_get_time_local_hour(global.currtime)+global.minute/60;

if(global.hour>12) {
  global.hour:=global.hour-12;
};

if(global.mode=1) {
  global.second:=trunc(global.second);
  global.minute:=trunc(global.minute);
};
```

The four global variables are used as setpoints for the control.


## phys axis

The pysical asix is connected to the actual hardware (stepper motor). 
This axis is configured with external PLC code for setpoint.

## phase axis

This axis defines the distance (phase) between the phys axis and the timing.

The caluclation of the phase is made in 4 instances of the below PLC code:
```
# MACROS needed:
#  AX_PHYS     : Axis index for physical axis
#  AX_PHASE    : Axis index for virtual axis phase
#  TIME_SOURCE : Global variable for time source
#  AX_MOD      : Range of motion (ex. 60 for minutes)


var phase:=${TIME_SOURCE}-ax${AX_PHYS}.enc.actpos;

if(phase > ${AX_MOD}/2) {
  phase:=-(${AX_MOD}-phase);
};

if(phase < -${AX_MOD}/2) {
  phase:=${AX_MOD}+phase;
};

ax${AX_PHASE}.enc.actpos:=phase;
ax${AX_PHYS}.traj.setpos:=${TIME_SOURCE}-ax${AX_PHASE}.traj.setpos;
```

## Concept

A startup sequence is implemented in PLC code for each axis pair (physical and virtual):
1. Enabling of phys motor
2. Ref the phystcal axis to 0 
3. Rampup motor to constant velocity (same as timing axis)
4. When velocity stabilized (the phase acttpos should be constant):
- the phase axis is enabled (to fix the phase setpoint).
- The source of the phys axis is switched to PLC (external).
5. The PLC disables itself.

Now the phase axis can be controlled to any desired position/phase (not handled automatically right now).

Implementation of startup seq:
```
# MACROS needed:
#  PLC_ID        : ID of this PLC
#  AX_PHYS       : Axis index for physical axis
#  AX_PHASE      : Axis index for virtual axis phase
#  AX_VELO       : Nominal velo
#  AX_ACC        : Acc and dec
#  VELO_RAMP_ENA : Enable velo ramp. Only needed for nanos

if(plc${PLC_ID}.firstscan) {
  println('State 0: trying to enable physical axis');
}

#State 0: Power physical axis and home to 0
if(static.state = 0) {  
  mc_power(${AX_PHYS},1);
}

if(ax${AX_PHYS}.drv.enabled and static.state = 0) {
  println('State 1: Home and then Move vel');
  mc_home_pos(${AX_PHYS},1,15,1,1,0);  
  static.state:=1;
}

# State 1: Start move velo ${AX_VELO}
if(static.state = 1) {
  if(${VELO_RAMP_ENA=0}) {
    # Toggle execute bit
    mc_move_vel(${AX_PHYS},0,${AX_VELO},${AX_ACC},${AX_ACC});
    mc_move_vel(${AX_PHYS},1,${AX_VELO},${AX_ACC},${AX_ACC});
  }
}

if(${VELO_RAMP_ENA=0}) {
  if(static.counter<1000 and ax${AX_PHYS}.enc.actvelo<${AX_VELO}*0.995 and ax${AX_PHYS}.enc.actvelo<${AX_VELO}*1.005) {
    static.counter:=static.counter+1;
  } else {
    static.counter:=0;
  }
} else {
  static.counter:=100;
}

# Enable phase axis to get stable setpoint
if(static.counter>=100 and static.state=1) {
  println('State 2: Power phase axis (axis ${AX_PHASE})');
  static.state:=2;
  mc_power(${AX_PHASE},1)
}

if(ax${AX_PHASE}.drv.enabled and static.state=2) {
  println('State 3: Phase axis enabled.. Change source of phys axis to ext');
  ax${AX_PHYS}.traj.source:=1;
  static.state:=3;
}

# Move to phase 0
if(static.state=3) {
  println('State 4: Move to 0 phase error');
  mc_move_abs(${AX_PHASE},0,0,${AX_VELO},${AX_ACC}, ${AX_ACC});
  mc_move_abs(${AX_PHASE},1,0,${AX_VELO},${AX_ACC}, ${AX_ACC});
  static.state:=4;
  # disable this plc
  plc${PLC_ID}.enable:=0;
}
```

## Mode

The clock can move in two modes:
* Smooth (default)
* Ticks of seconds and minutes

Set mode to ticks:
```
dbpf IOC_TEST:Set-Mode-RB 1
```

Set mode to smooth:
```
dbpf IOC_TEST:Set-Mode-RB 0
```

## NOTES (TODO):
1. This demo does not take full advantage of dc-clocks (compensate for encoder dc time and drive dc-time). Need to look into....
2. In this example CLOCK_REALTIME is not currently used (CLOCK_MONOTONIC is used). Consider switch to CLOCK_REALTIME.
