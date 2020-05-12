# Simple example how to read and write to ecmc plc variables from other non-ecmc records.
Example shows how to:
1. read a value from an external PV and feed into an ecmc PLC (IOC_TEST:FromExternal to IOC_TEST:ToPLC)
2. write an ecmc plc value to an external PV (IOC_TEST:FromPLC to IOC_TEST:ToExternal)

## Run example
´´´
$ iocsh.bash external.script
´´´

## Records
* IOC_TEST:FromPLC      : AI record reading a plc variable ("plcs.plc0.static.toEpics")
* IOC_TEST:FromExternal : AI record reading a value from external system
* IOC_TEST:ToPLC        : AO record writing "IOC_TEST:FromExternal.VAL" to a plc variable "plcs.plc0.static.fromEpics"
* IOC_TEST:ToExternal   : AI record writing a value to external system

## camonitor
´´´
camonitor IOC_TEST:FromPLC IOC_TEST:FromExternal IOC_TEST:ToPLC IOC_TEST:ToExternal
´´´

## caput
´´´
caput IOC_TEST:FromExternal 10
´´´
