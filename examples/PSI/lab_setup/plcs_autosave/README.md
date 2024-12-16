# PLC best practice
* Macros
* MSI include, substitute
* Printouts

## Macros
Use of macros makes the code more generic. When loading a PLC file with "loadPLCFile.cmd", custom macros can be defined in "PLC\_MACROS":
```
${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd,    "FILE=./cfg/main.plc, INC=.:./cfg/, SAMPLE_RATE_MS=1000, PLC_MACROS='BO_S_ID=${ECMC_EC_SLAVE_NUM}'"
```
NOTE: ECMC\_EC\_SLAVE\_NUM expands to the ID of the last added slave.

In addition to the custom macros, a few macros, that are often needed, are predefined:
1. SELF\_ID : Id of current PLC
2. SELF     : plc<SELF\_ID>
3. M\_ID    : EtherCAT master ID
4. M        : ec<M\_ID>

### SELF_ID and SELF example
A common usecase is that some initiation is needed, could be triggering of a custom homing sequence:

```
if(${SELF}.firstscan) {
  var plc:=${SELF_ID};
  ${DBG=#}println('PLC ',plc,' is starting up');
};

```
After macro expansion the code would look like this (for PLC id=0,DBG=''):
```
if(plc0.firstscan) {
 var plc:=0;
 println('PLC ',plc,' is starting up');
};

```
### M_ID and M example
All EtherCAT related information/data is accessible through the pattern "ec<master_id>.s<slave_id>.<name>".
To allow the same code to be loaded on different masters it's a good idea to use the predefined macros,"M" and "M_ID".

Toggle an output:
```
${M}.s${BO_S_ID}.binaryOutput${BO_CH=01}:=not(${M}.s${BO_S_ID}.binaryOutput${BO_CH=01});
${DBG=#}println('State: ', ${M}.s${BO_S_ID}.binaryOutput${BO_CH});
```
After macro expansion with the following macros the code would look like this:
* BO\_S\_ID = 10
* BO\_CH    = Not defined (defaults to "01")
* DBG       = Not defined (defaults to "#")
```
ec0.s10.binaryOutput01:=not(ec0.s10.binaryOutput01);
#println('State: ', ec0.s10.binaryOutput01);
```

## Include and substitute
Since all PLC files and PLC libs are parsed through MSI the "include" and "substitute" commands can be used.

When using the include command, the file location dir of the file must be added in the INC parameter when loading the PLC:
```
${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd,    "FILE=./cfg/main.plc, INC=.:./cfg/, SAMPLE_RATE_MS=1000, PLC_MACROS='BO_S_ID=${ECMC_EC_SLAVE_NUM}'"
```
The "INC" parameter can contain several directories separated with a ":", making it possible to include PLC files from several locations/modules.

### Example: Toggle a few outputs 
As a demo usecase let's consider that a few outputs needs to be toggled.
NOTE: There are simpler ways to write this specifc code but it's used to demo how code can be divided.

Lets first define some code that toggles a bit (toggle\_output.plc\_inc):
```
# Example of simple include file that toggles an binary output
${M}.s${BO_S_ID}.binaryOutput${BO_CH}:=not(${M}.s${BO_S_ID}.binaryOutput${BO_CH});
${DBG=#}println('State: ', ${M}.s${BO_S_ID}.binaryOutput${BO_CH});

```
This code snippet then can be included in a main plc-file by using the "include" keyword.
Each include can then be included with different macros by using the "substitute" keyword:
```
substitute "BO_CH=01"
include "toggle_output.plc_inc"

substitute "BO_CH=02, DBG="
include "toggle_output.plc_inc"
```
The above code would expand to:
```
ec0.s10.binaryOutput01:=not(ec0.s10.binaryOutput01);
#println('State:', ec0.s10.binaryOutput01);

ec0.s10.binaryOutput02:=not(ec0.s10.binaryOutput02);
println('State: ', ec0.s10.binaryOutput02);
```
The resulting code will toggle two different outputs, the state of the last output will be printed.

NOTE: Macros cannot be used in the filename when including a file. Instead the dir should be defined in the INC param when loading the PLC, see above.

## Printouts
Adding a DBG macro can be usefull to be able to turn on/off printouts. Typically during commsioning it can be usefull to have many printouts but later when system goes into production, it could be a good idea to turn (some) printouts off.

Example of a printout that can be turned on/off (default off)
```
${DBG=#}println('Value: ', ${M}.s${BO_S_ID}.binaryOutput${BO_CH});
```
Will result in the below if setting the DBG='' (and some other macros, see above):
```
println('Value: ', ec0.s10.binaryOutput01);
```

