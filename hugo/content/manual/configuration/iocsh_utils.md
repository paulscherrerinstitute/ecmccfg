## ECMC Iocsh Utilities

### Iocsh function "ecmcEpicsEnvSetCalc()"
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
                         Strings are used within '<str>': "'test'='test'". Note: expression result must be numeric and 
                         not string (in this case expression result is 1 => <envVarName> will be set to "1").
          <format>     : Optional format string. Example "%lf", "%8.3lf", "%x", "%04d" or "%d", defaults to "%d".
                         Can contain text like "0x%x" or "Hex value is 0x60%x".
                         Must contain one numeric value where result of expression will be written.

      Restrictions:
         - Some flags and/or width/precision combinations might not be supported.
         - Hex numbers in the expression is not allowed (but hex as output by formating is OK).
         - Non floatingpoint values will be rounded to nearest int.

```
#### Examples:
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

#### Comparing strings 1 (use '<string>'):
epicsEnvSet("filename","ecmcEL3002.cmd")
# ecmcEpicsEnvSetCalc("result", "'$(filename)'='test.script'")
ecmcEpicsEnvSetCalc("result", "'ecmcEL3002.cmd'='test.script'")
epicsEnvShow("result")
result=0

#### Comparing strings 2 (if-else):
# ecmcEpicsEnvSetCalc("result", "if('$(filename)'='test.script') {RESULT:=1;}else{RESULT:=0;};")
ecmcEpicsEnvSetCalc("result", "if('ecmcEL3002.cmd'='test.script') {RESULT:=1;}else{RESULT:=0;};")
epicsEnvShow("result")
result=0


```
### Iocsh function "ecmcEpicsEnvSetCalcTernary()"
 "ecmcEpicsEnvSetCalcTernary()" is used o evaluate expressions and set EPCIS environment variables to different strings.
 depending on if the expression evaluates to "true" or "false". Can be usefull for:
 * Choose different files to load like plc-files, axis configurations, db-files or..
 * making conditional ecmc settings
 * ...
  
``` 
ecmcEpicsEnvSetCalcTernary -h

 Test iocsh function "ecmcEpicsEnvSetCalcTernary()" t

        Use "ecmcEpicsEnvSetCalcTernary(<envVarName>,  <expression>, <trueString>, <falseString>)" to evaluate the expression and        assign the variable.
          <envVarName>  : EPICS environment variable name.
          <expression>  : Calculation expression (see exprTK for available functionality). Examples:
                          Simple expression:"5.5+${TEST_SCALE}*sin(${TEST_ANGLE}/10)".
                          Use of "RESULT" variable: "if(${TEST_VAL}>5){RESULT:=100;}else{RESULT:=200;};".
                          Strings are used within '<str>': "'test'='test'". Note: expression result must be numeric and 
                          not string (in this case expression result is 1 => <envVarName> will be set to <trueString>).                          
          <trueString>  : String to set <envVarName> if expression (or "RESULT") evaluates to true.
          <falseString> : String to set <envVarName> if expression (or "RESULT") evaluates to false.

```
#### Examples:
```
### Simple true false
epicsEnvSet("VALUE",10)
# ecmcEpicsEnvSetCalcTernary("test_var", "${VALUE}+2+5/10","True","False")
ecmcEpicsEnvSetCalcTernary("test_var", "10+2+5/10","True","False")
epicsEnvShow("test_var")
test_var=True

### Can be used for choosing different files
# ecmcEpicsEnvSetCalcTernary("filename", "${VALUE}>20","./plc_fast.cfg","./plc_slow.cfg")
ecmcEpicsEnvSetCalcTernary("filename", "10>20","./plc_fast.cfg","./plc_slow.cfg")
epicsEnvShow("filename")
filename=./plc_slow.cfg

### Comparing strings 1 (simple):
# ecmcEpicsEnvSetCalcTernary("result", "'$(filename)'='./plc_slow.cfg'","equal","not_equal")
ecmcEpicsEnvSetCalcTernary("result", "'./plc_slow.cfg'='./plc_slow.cfg'","equal","not_equal")
epicsEnvShow("result")
result=equal

### Comparing strings 2 (with if-else):
# ecmcEpicsEnvSetCalcTernary("result", "if('$(filename)'='test') {RESULT:=1;}else{RESULT:=0;};","use_this_file.cfg","no_use_this_file.cfg")
ecmcEpicsEnvSetCalcTernary("result", "if('./plc_slow.cfg'='test') {RESULT:=1;}else{RESULT:=0;};","use_this_file.cfg","no_use_this_file.cfg")
epicsEnvShow("result")
result=no_use_this_file.cfg


```

### Use return value of ecmcConfig(OrDie):

The return value from ecmcConfig(OrDie) is stored in the EPICS environment variable
"ECMC_CONFIG_RETURN_VAL". This value can be used to make som dynamic configuration.
All ASCII configuration commands for ecmcConfig(OrDie) can be used in the same way.

#### Example: Read firmware version of an EL7037 stepper drive
Note: SDO reads need to be before "SetAppMode(1)"
```
ecmcConfig "EcReadSdo(${ECMC_SLAVE_NUM},0x100a,0x0,2)"
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=14640

```
The variable "ECMC_CONFIG_RETURN_VAL" then can be used to set record fields, name or alias for instance.. 

### Example: Read "ID" PDO from EK1101 (shown in detail in aliasRecordFromPdoData.script)
Note: PDO reads need to be after "SetAppMode(1)" since cyclic value
```
ecmcConfig "ReadEcEntryIDString(${ECMC_SLAVE_NUM},"ID")"
2020/02/28 08:58:03.771 1024
## This is the value of the EK1101 ID switch
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1024

```
The variable "ECMC_CONFIG_RETURN_VAL" then can be used to set record fields, name or alias for instance.. 
