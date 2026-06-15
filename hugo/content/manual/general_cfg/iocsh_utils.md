+++
title = "iocsh utilities"
weight = 14
chapter = false
+++

## Scope

This page documents the ecmc-specific iocsh helper commands that are useful in
startup files and low-level commissioning.

Most users primarily need:

- expression helpers such as `ecmcEpicsEnvSetCalc`
- conditional/script helpers such as `ecmcIf` and `ecmcForLoop`
- direct parser access through `ecmcConfig` / `ecmcConfigOrDie`

### ecmcEpicsEnvSetCalc
`ecmcEpicsEnvSetCalc()` evaluates an expression and writes the result to an
EPICS environment variable.

Typical uses:

- slave offsets
- SDO/PDO addresses, including hexadecimal formatting
- motion scaling
- record fields
- general startup-time calculations

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
         - Hex numbers in the expression is not allowed (but hex as output by formatting is OK).
         - Non floating point values will be rounded to nearest int.

```
#### Examples
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

`ecmcEpicsEnvSetCalcTernary()` evaluates an expression and sets an EPICS
environment variable to one of two strings depending on whether the expression
evaluates to true or false.

Typical uses:

- choosing between alternative PLC, YAML, or DB files
- conditional ecmc settings
- simple startup-time branching without a larger iocsh block

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
#### Examples
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

`ecmcIf()` sets two macros depending on the value of the evaluated expression.

If the expression is true:

1. `IF_TRUE=""` allows execution of a line
2. `IF_FALSE="#-"` comments out a line

If the expression is false:

1. `IF_TRUE="#-"` comments out a line
2. `IF_FALSE=""` allows execution of a line

These are the default macro names, but the last two arguments to `ecmcIf()`
can override them.

### ecmcEndIf
```text
ecmcEndIf()
```
The ecmcEndIf() command unsets the last used macros (for true and false), if different names are passed as arguments then then these macros are unset (for nested if statements).
`ecmcEndIf()` unsets the macros used by the most recent `ecmcIf()` call. If
explicit names are passed as arguments, those names are unset instead. This is
useful for nested `ecmcIf()` blocks.

#### Examples
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
For nested calls to `ecmcIf()` and `ecmcEndIf()`, use explicit macro names.

Example 3, nested:
```text
ecmcIf("$(OUTER)>0",OUTER_TRUE,OUTER_FALSE)
${OUTER_TRUE}ecmcIf("$(INNER)>0",INNER_TRUE,INNER_FALSE)
${INNER_TRUE}epicsEnvSet("RESULT","both_true")
#- else
${INNER_FALSE}epicsEnvSet("RESULT","outer_true_inner_false")
${OUTER_TRUE}ecmcEndIf(INNER_TRUE,INNER_FALSE)
#- else
${OUTER_FALSE}epicsEnvSet("RESULT","outer_false")
ecmcEndIf(OUTER_TRUE,OUTER_FALSE)
```

The important point is that the inner `ecmcIf()` must use different macro names
from the outer one, and the matching `ecmcEndIf()` call should unset those same
names.

### ecmcForLoop

Useful for:

- large systems with many similar subsystems
- repetitive hardware configuration, for example many PDOs or oversampling blocks

```text
Use `ecmcForLoop(<filename>, <macros>, <loopvar>, <from>, <to>, <step>)` to execute one file repeatedly while changing a loop variable.
             <filename> : Filename to execute in for loop.
             <macros>   : Macros to feed to execution of file.
             <loopvar>  : Environment variable to use as index in for loop.
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
where `loopStep.cmd` looks like this:
```text
#- Commands to execute in each loop of the ecmcForLoop example
ecmcEpicsEnvSetCalc("TESTING",${ECMC_LOOP_IDX}*10)
epicsEnvShow("TESTING")
```

### ecmcFileExist

Useful for checking that configuration files really exist before they are loaded.

```text
Use `ecmcFileExist(<filename>, <die>, <check EPICS dirs>, <dirs>)` to check whether a file exists.
              <filename>          : Filename to check.
              <die>               : Exit EPICS if file not exist. Optional, defaults to 0.
              <check EPICS dirs>  : Look for files in `EPICS_DB_INCLUDE_PATH`. Optional, defaults to 0.
              <dirs>              : List of dirs to search for file in (separated with ':').
The result is stored in the EPICS environment variable `ECMC_FILE_EXIST_RETURN_VAL`.
```

#### Examples

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

The return value from `ecmcConfig()` or `ecmcConfigOrDie()` is stored in the
EPICS environment variable `ECMC_CONFIG_RETURN_VAL`.

This is useful for dynamic startup logic. All normal ASCII parser commands can
be used this way.

#### Example: Read firmware version of an EL7037 stepper drive
Note: SDO reads need to be before "SetAppMode(1)"
```text
ecmcConfig "EcReadSdo(${ECMC_SLAVE_NUM},0x100a,0x0,2)"
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=14640

```
`ECMC_CONFIG_RETURN_VAL` can then be used to set record fields, names, aliases,
or other startup macros.

### Example: Read "ID" PDO from EK1101 (shown in detail in aliasRecordFromPdoData.script)
Note: PDO reads need to be after "SetAppMode(1)" since cyclic value
```text
ecmcConfig "ReadEcEntryIDString(${ECMC_SLAVE_NUM},"ID")"
## This is the value of the EK1101 ID switch
epicsEnvShow(ECMC_CONFIG_RETURN_VAL)
ECMC_CONFIG_RETURN_VAL=1024
```
`ECMC_CONFIG_RETURN_VAL` can then be used to set record fields, names, aliases,
or other startup macros.

## Operational iocsh commands

The commands above are mostly macro helpers.

The commands below are the direct operational iocsh layer registered by ecmc
itself. They are useful when:

- bringing up ecmc without the full `ecmccfg` startup flow
- debugging parameter names and records
- running lower-level commissioning commands directly

### ecmcAsynPortDriverConfigure

```text
ecmcAsynPortDriverConfigure(<portName>, <paramTableSize>, <axisCount>, <disableAutoConnect>, <sampleRateMs>)
```

This creates the main ecmc asyn port driver object.

In normal `ecmccfg` usage this is handled for you by `startup.cmd`, so most
users should not call it directly.

Use it only when:

- bringing up raw ecmc manually
- testing direct ecmc integration outside the normal `ecmccfg` startup path
- diagnosing startup issues where the asyn layer itself is the problem

### ecmcConfig and ecmcConfigOrDie

```text
ecmcConfig("<parser command>")
ecmcConfigOrDie("<parser command>")
```

These send one command string to the ecmc command parser.

Difference:

- `ecmcConfig` prints the parser result and continues
- `ecmcConfigOrDie` exits immediately on parser error

Use `ecmcConfigOrDie` in startup scripts when a failed command should stop the
IOC. Use `ecmcConfig` when the command is exploratory, optional, or when you
want to inspect the return value without aborting startup.

The parser return value is stored in:

```text
ECMC_CONFIG_RETURN_VAL
```

#### Runtime parser blocking

Two separate runtime-protection features are available through the parser:

- `Cfg.SetAxisBlockCom(axis,block)` / `GetAxisBlockCom(axis)` block active
  command-parser set commands for one axis.
- `Cfg.SetBlockCfgCmdsInRuntime(block)` / `GetBlockCfgCmdsInRuntime()` block
  most `Cfg.` parser commands globally once ecmc is already in runtime.

Use axis blocking when one axis should remain readable but not accept normal
external motion or configuration commands through the parser. Use the runtime
`Cfg.` block when you want to prevent late structural reconfiguration after the
IOC has entered operational mode.

Notes:

- `Get...` status and readback commands still work while the corresponding block is active.
- Axis blocking is per-axis and does not block all parser traffic.
- Axis blocking still allows stop and stop-with-kill commands such as `StopMotion(axis)` and `StopMotion(axis,1)`.
- `Cfg.SetBlockCfgCmdsInRuntime(...)` must be set before `Cfg.SetAppMode(1)`.
  Once ecmc is already in runtime, changing that flag is itself rejected.

Typical usage:

```text
# Enable global blocking of Cfg.* parser commands before entering runtime
ecmcConfigOrDie("Cfg.SetBlockCfgCmdsInRuntime(1)")

# Later, verify the global runtime block state
ecmcConfig("GetBlockCfgCmdsInRuntime()")

# Block active parser set commands for axis 3
ecmcConfig("Cfg.SetAxisBlockCom(3,1)")

# Read back the per-axis block state
ecmcConfig("GetAxisBlockCom(3)")
```

### ecmcReport

```text
ecmcReport(<level>)
```

This is the ecmc-specific equivalent of an asyn report for the ecmc port.

Use it when you want a quick summary of:

- configured objects
- parameters
- current asyn-facing interface state

Typical usage:

```text
ecmcReport(2)
```

### ecmcGrepParam

```text
ecmcGrepParam(<pattern>, <details>)
```

Lists ecmc parameters whose names match the pattern.

Use it when:

- you know part of an asyn parameter name
- you want to discover the exact runtime name to use in EPICS or PLC logic
- you are checking what a plugin or object actually exported

Typical usage:

```text
ecmcGrepParam("ax1",1)
ecmcGrepParam("plugin",1)
```

### ecmcGrepRecord

```text
ecmcGrepRecord(<pattern>)
```

Lists EPICS record names created by ecmc that match the pattern.

Use it when:

- you know part of the record name but not the full PV
- you want to confirm that a startup step actually created the expected records

### ecmcGetSlaveIdFromEcPath

```text
ecmcGetSlaveIdFromEcPath(<ec_path>, <result_env_var>)
```

Extracts the slave id from an EtherCAT path such as:

```text
ec1.s12.positionActual
```

and stores the result in the chosen EPICS environment variable.

If no slave id can be parsed, the result variable is set to `-2`.

Use it when startup logic needs to derive a slave number from a path macro
instead of being given the slave position explicitly.

### ecmcGetEcEntryChannelFromEcPath

```text
ecmcGetEcEntryChannelFromEcPath(<ec_path>, <result_env_var>)
```

Extracts the channel id from the EtherCAT entry alias in a path such as:

```text
ec0.s7.positionActual01
```

and stores `01` in the chosen EPICS environment variable.

If the channel id cannot be identified, the result variable is set to `-2`.

Use it when startup logic needs to derive the channel from the linked EtherCAT
entry instead of being given the channel explicitly. This is used, for example,
to create slave-local axis-name marker records such as `Drv01-AxName` and
`Enc01-AxName`.

### ecmcExit

```text
ecmcExit(...)
```

Exits the IOC process immediately.

This is mostly useful in defensive startup logic, for example after a failed
condition that should stop the IOC before partial configuration continues.

### Obsolete command

```text
ecmcAsynPortDriverAddParameter(...)
```

This command is still registered for compatibility, but the implementation marks
it as obsolete.

Do not build new startup logic around it. Use `asynReport` / `ecmcReport` /
`ecmcGrepParam` to inspect available parameters instead.
