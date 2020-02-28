# Test iocsh function "ecmcEpicsEnvSetCalc()"
 "ecmcEpicsEnvSetCalc()" is used to evaluate expressions and set result to EPCIS environment variables. Usefull for calculate:
  * slave offsets
  * sdo/pdo adresses (also in hex)
  * scalings in motion
  * record fields
  * ...
  
``` 
ecmcEpicsEnvSetCalc -h

      Use "ecmcEpicsEnvSetCalc(<envVarName>,  <expression>, <format>)" to evaluate the expression and assign the variable.
          <envVarName> : EPICS environment variable name.
          <expression> : Calculation expression (see exprTK for available functionality). Examples:
                         Simple expression:"5.5+${TEST_SCALE}*sin(${TEST_ANGLE}/10)".
                         Use of "RESULT" variable: "if(${TEST_VAL}>5){RESULT:=100;}else{RESULT:=200;};".
          <format>     : Optional format string. Example "%lf", "%8.3lf", "%x", "%04d" or "%d", defaults to "%d".
                         Can contain text like "0x%x" or "Hex value is 0x60%x".
                         Must contain one numeric value where result of expression will be written.

      Restrictions:
         - Some flags and/or width/precision combinations might not be supported.
         - Hex numbers in the expression is not allowed (but hex as output by formating is OK).
         - Non floatingpoint values will be rounded to nearest int.

```
## Examples:
```
#### Calculate addresses in HEX with specified width
# ecmcEpicsEnvSetCalc("test2", "$(test1)+1+2+3+4+5*10.1", "%03x")
ecmcEpicsEnvSetCalc("test2", "061+1+2+3+4+5*10.1", "%03x")
epicsEnvShow("test2")
test2=07a

#### Hex + text in format string
# ecmcEpicsEnvSetCalc("test2", "$(test1)+1+2+3+4+5*10.1", "This is the number: 0x%06x")
ecmcEpicsEnvSetCalc("test2", "061+1+2+3+4+5*10.1", "This is the number: 0x%06x")
epicsEnvShow("test2")
test2=This is the number: 0x00007a

#### Calculate scalings (floating point)
epicsEnvSet("IORange",32768)
# ecmcEpicsEnvSetCalc("scaling", "$(test1)/$(IORange)*10", "%lf")
ecmcEpicsEnvSetCalc("scaling", "061/32768*10", "%lf")
epicsEnvShow("scaling")
scaling=0.018616

#### Offset slave numbers (format defaults to "%d")
epicsEnvSet("ECMC_SLAVE_NUM",10)
epicsEnvSet("ECMC_SLAVE_NUM_OFFSET",25)
# ecmcEpicsEnvSetCalc("ECMC_SLAVE_NUM", "$(ECMC_SLAVE_NUM)+$(ECMC_SLAVE_NUM_OFFSET)")
ecmcEpicsEnvSetCalc("ECMC_SLAVE_NUM", "10+25")
epicsEnvShow("ECMC_SLAVE_NUM")
ECMC_SLAVE_NUM=35

#### if-statement syntax (use "RESULT" variable)
epicsEnvSet("VALUE",10)
# ecmcEpicsEnvSetCalc("IF_TEST", "if(${VALUE}>5){RESULT:=100;}else{RESULT:=200;};")
ecmcEpicsEnvSetCalc("IF_TEST", "if(10>5){RESULT:=100;}else{RESULT:=200;};")
epicsEnvShow("IF_TEST")
IF_TEST=100

```

# Use return value of ecmcConfig(OrDie):

The return value from ecmcConfig(OrDie) is stored in the EPICS environment variable
"ECMC_CONFIG_RETURN_VAL". This value can be used to make som dynamic configuration.
All ASCII configuration commands for ecmcConfig(OrDie) can be used in the same way.

## Example: Read firmware version of an EL7037 stepper drive (sdo read must be before serAppMode(1))
Note: SDO reads need to be before "SetAppMode(1)"
```
ecmcConfig "EcReadSdo(${ECMC_SLAVE_NUM},0x100a,0x0,2)"
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=14640

```
The variable "ECMC_CONFIG_RETURN_VAL" then can be used to set record fields,name or alias for instance.. 

## Example: Read "ID" PDO from EK1101 (shown in detail in aliasRecordFromPdoData.script)
Note: PDO reads need to be after "SetAppMode(1)" since cyclic value
```
ecmcConfig "ReadEcEntryIDString(${ECMC_SLAVE_NUM},"ID")"
2020/02/28 08:58:03.771 1024
## This is the value of the EK1101 ID switch
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1024

```
The variable "ECMC_CONFIG_RETURN_VAL" then can be used to set record fields,name or alias for instance.. 
