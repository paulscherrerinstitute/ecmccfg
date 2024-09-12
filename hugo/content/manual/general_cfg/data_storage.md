+++  
title = "data storage buffer"   
weight = 16
chapter = false  
+++  

## data storage examples
This dir contains two examples: [here](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/test/dataStorage).

1. Continiously add value to data storage. Push to epics by hw trigger.
2. Continiously add value to data storage. Push to epics by epics pv trigger.
Data buffered data can be accessed by the "IOC_TEST:ds0-Data-Act" waveform pv (NELM 10000)

Custom scale and offset can be applied to the stored values by MACROS (to the plc) in the startup file.

### 1 push to epics by hw trigger

In this example the data stored in dataStorage 0 is pushed to epics at a falling edge of the axis 1 high limit.

Example 1 is started with the following stratup file: "add_data_to_buffer_trigg_push_hw.script" 

```
iocsh.bash add_data_to_buffer_trigg_push_hw.script
```
Trigger writes to epics by toggle of axis 1 high limit switch.

PLC-code:
```
##################################################################################
# PLC to add encoder data to dataStorage and push data on falling edge of higlimit
#
# MACROS:
#   DS_ID    = ID of ds to use as a filter id
#   PLC_ID   = ID of this PLC
#   ENC_S_ID = Slave id of encoder terminal
#   DBG      = Set to empty string to get printouts, set to "#" to avoid printouts
# SCALE          = Encoder scale value, defaults to 1
# OFFSET         = Encoder offset value, defaults to 0
#

# Append data to storage
ds_append_data(${DS_ID},ec0.s${ENC_S_ID}.positionActual01*${SCALE=1}+${OFFSET=0});

# Trigger push of data on falling edge of limit switch
if(static.highlimOld and not(ax1.mon.highlim)) {
  ${DBG=#}println('Pushing data to EPICS....'); 
  ds_push_asyn(${DS_ID});
};

static.highlimOld:=ax1.mon.highlim;

```

### 2 push to epics by epics pv trigger

In this example the data stored in dataStorage 0 is pushed to epics at a rising edge of the "IOC_TEST:Set-PushDataTrigger-RB" pv.

Example 2 is started with the following stratup file: "add_data_to_buffer_trigg_push_hw.script" 
```
iocsh.bash add_data_to_buffer_trigg_push_epics.script
```

Trigger writes to epics by:
```
raspberrypi-16970 > dbpf IOC_TEST:Set-PushDataTrigger-RB 1
DBF_STRING:         "One"     
raspberrypi-16970 > Pushing data to EPICS....
dbpf IOC_TEST:Set-PushDataTrigger-RB 0
DBF_STRING:         "Zero"    
raspberrypi-16970 > dbpf IOC_TEST:Set-PushDataTrigger-RB 1
DBF_STRING:         "One"     
raspberrypi-16970 > Pushing data to EPICS....
```

PLC-code:
```
##################################################################################
# PLC to add encoder data to dataStorage and push data on trigger from epics PV
#
# MACROS:
#   DS_ID    = ID of ds to use as a filter id
#   PLC_ID   = ID of this PLC
#   ENC_S_ID = Slave id of analog input terminal
#   DBG      = Set to empty string to get printouts, set to "#" to avoid printouts
#   SCALE    = Encoder scale value, defaults to 1
#   OFFSET   = Encoder offset value, defaults to 0
#

# Append data to storage
ds_append_data(${DS_ID},ec0.s${ENC_S_ID}.positionActual01*${SCALE=1}+${OFFSET=0});

# Trigger push of data on rising edge of trigger
if(static.trigg and not(static.triggOld)) {
  ${DBG=#}println('Pushing data to EPICS....'); 
  ds_push_asyn(${DS_ID});
};

static.triggOld:=static.trigg;

```
