+++  
title = "iocsh utilities"   
weight = 17
chapter = false  
+++  

## ECMC Iocsh Utilities

### ecmcEpicsEnvSetCalc
 "ecmcEpicsEnvSetCalc()" is used to evaluate expressions and set result to EPCIS environment variables. Useful for calculate:
  * slave offsets
  * sdo/pdo addresses (also in hex)
  * motion scaling
  * record fields
  * ...
  
```text
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
         - Non floating point values will be rounded to nearest int.

```
#### Examples:
```text
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

#### Calculate scaling (floating point)
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
### ecmcEpicsEnvSetCalcTernary
 "ecmcEpicsEnvSetCalcTernary()" is used o evaluate expressions and set EPCIS environment variables to different strings.
 depending on if the expression evaluates to "true" or "false". Can be useful for:
 * Choose different files to load like plc-files, axis configurations, db-files or..
 * making conditional ecmc settings
 * ...
  
```text
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
```text
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

### ecmcIf(\<expression\>,\<optional true macro\>,\<optional false macro\>)
ecmcIf() set two macros depending on the value of the evaluated expression. If it evaluates to true:
1. IF_TRUE=""        Allows execution of a line of code   
2. IF_FALSE= "#-"    Block execution of a line of code

If expression evaluates to false:
1. IF_TRUE="#-"      Block execution of a line of code
2. IF_FALSE= ""      Allows execution of a line of code

Note: These macros are the default names for the macros (but can be changed by assignment of the 2 last params in call to ecmcIf()):
1. IF_TRUE for true
2. IF_FALSE for false

### ecmcEndIf
```text
ecmcEndIf()
```
The ecmcEndIf() command unsets the last used macros (for true and false), if different names are passed as arguments then then these macros are unset (for nested if statements).

#### Example of syntax
Example 1:
```text
ecmcIf("<expression>")
${IF_TRUE} # Code to execute if expression eval true
#- else
${IF_FALSE} # Code to execute if expression eval false
ecmcEndIf()
```
Example 2:
```text
ecmcIf("$(VAL1)=$(VAL2)")
${IF_TRUE}epicsEnvSet(IS_EQUAL,"1")
#- else
${IF_FALSE}epicsEnvSet(IS_EQUAL,"0")
ecmcEndIf()
```
Note: For nested calls to ecmcIf() and ecmcEndIf() optional macros must be used.

### ecmcForLoop
Useful for:
* Large systems with many similar sub systems
* Configuring hardware with many PDOs (oversampling)

```text
"ecmcForLoop(<filename>, <macros>, <loopvar>, <from>, <to>, <step>)" to loop execution of file with a changing loop variable.
             <filename> : Filename to execute in for loop.
             <macros>   : Macros to feed to execution of file.
             <loopvar   : Environment variable to use as index in for loop.
             <from>     : <loopvar> start value.
             <to>       : <loopvar> end value.
             <step>     : Step to increase <loopvar> each loop cycle.

```
Example ("ECMC_LOOP_IDX" as loop variable):

```text
ecmcForLoop(./loopStep.cmd,"",ECMC_LOOP_IDX,1,5,1)
ecmcEpicsEnvSetCalc("TESTING",1*10)
epicsEnvShow("TESTING")
TESTING=10
ecmcEpicsEnvSetCalc("TESTING",2*10)
epicsEnvShow("TESTING")
TESTING=20
ecmcEpicsEnvSetCalc("TESTING",3*10)
epicsEnvShow("TESTING")
TESTING=30
ecmcEpicsEnvSetCalc("TESTING",4*10)
epicsEnvShow("TESTING")
TESTING=40
ecmcEpicsEnvSetCalc("TESTING",5*10)
epicsEnvShow("TESTING")
TESTING=50
```
where "loopStep.cmd" file looks like this (note the use of "ECMC_LOOP_IDX"):
```text
#- Commands tp execute in each loop of example ecmcForLoop.script
ecmcEpicsEnvSetCalc("TESTING",${ECMC_LOOP_IDX}*10)
epicsEnvShow("TESTING")
```

### ecmcFileExist
Useful for checking that configuration files really exist and then can be loaded.
```text
ecmcFileExist(<filename>, <die>, <check EPICS dirs>, <dirs>)" to check if a file exists.
              <filename>          : Filename to check.
              <die>               : Exit EPICS if file not exist. Optional, defaults to 0.
              <check EPICS dirs>  : Look for files in EPICS_DB_INCLUDE_PATH dirs. Optional, defaults to 0.\n");
              <dirs>              : List of dirs to search for file in (separated with ':').
result will be stored in the EPICS environment variable "ECMC_FILE_EXIST_RETURN_VAL"
```
Example:
```text
ecmcFileExist("file_exist.cfg")
epicsEnvShow(ECMC_FILE_EXIST_RETURN_VAL)
ECMC_FILE_EXIST_RETURN_VAL=1

ecmcFileExist("file_not_exist.cfg",1)
Error: File "file_not_exist.cfg" does not exist. ECMC shuts down.

ecmcFileExist("ecmcEK1100.substitutions",1,1)
epicsEnvShow(ECMC_FILE_EXIST_RETURN_VAL)
ECMC_FILE_EXIST_RETURN_VAL=1

ecmcFileExist("ecmcEK1100.substitutions",0,0,"/home/")
epicsEnvShow(ECMC_FILE_EXIST_RETURN_VAL)
ECMC_FILE_EXIST_RETURN_VAL=0
```
### Use return value of ecmcConfig(OrDie):

The return value from ecmcConfig(OrDie) is stored in the EPICS environment variable
"ECMC_CONFIG_RETURN_VAL". This value can be used to make som dynamic configuration.
All ASCII configuration commands for ecmcConfig(OrDie) can be used in the same way.

#### Example: Read firmware version of an EL7037 stepper drive
Note: SDO reads need to be before "SetAppMode(1)"
```text
ecmcConfig "EcReadSdo(${ECMC_SLAVE_NUM},0x100a,0x0,2)"
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=14640

```
The variable "ECMC_CONFIG_RETURN_VAL" then can be used to set record fields, name or alias for instance.. 

### Example: Read "ID" PDO from EK1101 (shown in detail in aliasRecordFromPdoData.script)
Note: PDO reads need to be after "SetAppMode(1)" since cyclic value
```text
ecmcConfig "ReadEcEntryIDString(${ECMC_SLAVE_NUM},"ID")"
## This is the value of the EK1101 ID switch
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1024
```
The variable "ECMC_CONFIG_RETURN_VAL" then can be used to set record fields, name or alias for instance.. 

### Todo
Add docs for:
* ecmcConfigOrDie
* ecmcConfig
* ecmcGrepParam
* ecmcGrepRecord
* ecmcReport
* ecmcAsynPortDriverConfigure
