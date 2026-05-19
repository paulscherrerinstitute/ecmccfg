+++
title = "C++ Logic"
weight = 13
chapter = false
+++

## Scope
This page documents the additive `cpp_logic` interface in `ecmc`.

Use it when:

- you want to run small cyclic user logic written in C/C++
- that logic should bind directly to `ecmc` data items
- and it should expose its own runtime values on a dedicated asyn interface

`cpp_logic` does **not** replace the existing plugin ABI in `ecmcPluginDefs.h`.
It is a second interface in `ecmc`, intended for user-defined cyclic logic
modules rather than full standalone plugins.

## Recommended IOC Startup Interface

The normal IOC-level entry point is:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}scripts/loadCppLogic.cmd, "FILE=/path/to/main.so,REPORT=1"
```

Important defaults in `loadCppLogic.cmd`:

- `FILE`: defaults to `libmain.so`
- `DIR`: defaults to `./bin/`
- `LOGIC_ID`: defaults to the next free id
- `ASYN_PORT`: defaults to `CPP.LOGIC<LOGIC_ID>`
- `MACROS`: optional free-form text passed into user code through `ecmcCpp::getMacrosString()`
- `LOAD_DEFAULT_PVS`: defaults to `1`
- `EPICS_SUBST`: optional custom substitutions file for exported `epics.*` PVs, default `cfg/<FILE>_cpp_logic.subs`
- `DB_PREFIX`: defaults to `$(IOC):`

The wrapper:

1. loads one compiled C++ logic shared library
2. optionally reports the loaded object
3. loads the built-in control/status PVs
4. automatically loads the generated `epics.*` substitutions by default, unless `EPICS_SUBST=EMPTY`

## Underlying ecmc Commands

The underlying parser commands are:

```text
Cfg.LoadCppLogic(<id>,<file>)
Cfg.LoadCppLogic(<id>,<file>,<config>)
Cfg.ReportCppLogic(<id>)
Cfg.AppendCppLogicMacros(<id>)=<text>
```

The IOC wrapper script mainly fills in defaults and handles the EPICS record
loading around those commands.

For long startup macro strings, use the companion helper script:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}scripts/loadCppLogic.cmd, "MACROS='A=1,B=2'"
${SCRIPTEXEC} ${ecmccfg_DIR}scripts/appendCppLogicMacros.cmd, "MACROS='C=3,D=4'"
```

If `LOGIC_ID` is omitted, `appendCppLogicMacros.cmd` targets the current
`ECMC_CPP_LOGIC_ID` set by `loadCppLogic.cmd`.

## Startup Macro Handling

The `MACROS` argument is passed as plain text to the C++ logic instance. It is
not applied by `msi` to the C++ source code. User code reads it at runtime with
the helper functions in `ecmcCppLogic.hpp`.

Example startup:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}scripts/loadCppLogic.cmd, \
  "FILE=libmain.so,MACROS='S_ID=14,AXIS_ID=1,DBG=1,GAIN=2.5'"
```

Example C++ use:

```cpp
const std::string macros = ecmcCpp::getMacrosString();
const int slave_id = ecmcCpp::getMacroValueInt(macros, "S_ID", 14);
const int axis_id = ecmcCpp::getMacroValueInt(macros, "AXIS_ID", 1);
const bool dbg = ecmcCpp::getMacroValueInt(macros, "DBG", 0) != 0;
const double gain = ecmcCpp::getMacroValueDouble(macros, "GAIN", 1.0);
const std::string mode = ecmcCpp::getMacroValueString(macros, "MODE", "normal");

ecmcCpp::setEnableDbg(dbg);
```

Available macro helper functions:

- `ecmcCpp::getMacrosString()`
- `ecmcCpp::getMacroValue(macros, key)`
- `ecmcCpp::getMacroValueString(macros, key, defaultValue)`
- `ecmcCpp::getMacroValueInt(macros, key, defaultValue)`
- `ecmcCpp::getMacroValueDouble(macros, key, defaultValue)`

`getMacroValue(...)` returns an empty string when a key is missing.
`getMacroValueString(...)` returns the caller-provided default when a key is
missing. The numeric helpers return the caller-provided default when the key is
missing or cannot be parsed. Macro text is split on commas outside quotes, and
optional single or double quotes around values are stripped.

Use `appendCppLogicMacros.cmd` when a startup file should add more macro text
after the initial load. The appended text is visible through the same
`ecmcCpp::getMacrosString()` helper.

## C++ Programming Model

The public C++ headers are:

- `ecmcCppLogic.hpp`
- `ecmcCppMotion.hpp`
- `ecmcCppControl.hpp`
- `ecmcCppUtils.hpp`
- `ecmcCppTrace.hpp`
- `ecmcCppPersist.hpp`

For a helper/header-oriented summary, see
[C++ Logic Helpers]({{< relref "/manual/plugins/cpp_logic_helpers.md" >}}).

Typical user code looks like:

```cpp
#include "ecmcCppLogic.hpp"

struct MyLogic : public ecmcCpp::LogicBase {
  int32_t actual_position {0};
  int16_t drive_control {0};
  int16_t velocity_setpoint {1000};

  MyLogic() {
    ecmc.input("ec.s14.positionActual01", actual_position)
        .output("ec.s14.driveControl01", drive_control)
        .output("ec.s14.velocitySetpoint01", velocity_setpoint);

    epics.readOnly("main.actual_position", actual_position)
         .writable("main.velocity_setpoint", velocity_setpoint);
  }

  void run() override {
    drive_control = 1;
  }
};

ECMC_CPP_LOGIC_REGISTER_DEFAULT(MyLogic)
```

The main split is:

- `ecmc...`: live realtime bindings to `ecmc` item names
- `epics...`: values exported on the C++ logic instance's dedicated asyn port

Creation can fail cleanly before realtime starts. With the default registration
macro, add `validateCreation(std::string* errorMessage)` when validation needs the
constructed object:

```cpp
int32_t validateCreation(std::string* errorMessage) {
  if (bad_config) {
    if (errorMessage) {
      *errorMessage = "bad config: missing AXIS_ID";
    }
    return ECMC_CPP_LOGIC_CREATE_INSTANCE_FAIL;
  }
  return 0;
}
```

If this hook returns an error, `Cfg.LoadCppLogic(...)` returns the error code and
message. Use `ecmcConfigOrDie` around `Cfg.LoadCppLogic(...)` when startup
should stop on a fatal C++ logic creation error.

## Supported Binding Styles

For normal scalars, the C++ value type is inferred from the bound variable type.

Supported patterns include:

- scalar input/output:
  - `ecmc.input(...)`
  - `ecmc.output(...)`
- arrays:
  - `ecmc.inputArray(...)`
  - `ecmc.outputArray(...)`
- raw bytes:
  - `ecmc.inputBytes(...)`
  - `ecmc.outputBytes(...)`
- startup-sized vectors:
  - `ecmc.inputAutoArray(...)`
  - `ecmc.outputAutoArray(...)`

On the exported EPICS side, corresponding helpers exist for:

- scalars:
  - `epics.readOnly(...)`
  - `epics.writable(...)`
- arrays:
  - `epics.readOnlyArray(...)`
  - `epics.writableArray(...)`
- raw bytes:
  - `epics.readOnlyBytes(...)`
  - `epics.writableBytes(...)`

## Runtime Interface

Each loaded `cpp_logic` instance gets:

- its own dedicated asyn port
- built-in control, timing, and debug variables on that port
- all exported `epics.*` variables on that same port

The built-in core substitutions are loaded from:

```text
$(ecmccfg_DIR)db/generic/ecmcCppLogicCore.substitutions
```

The generic caQtDM runtime panel is:

```text
$(ecmccfg_DIR)qt/ecmcCppLogic.ui
```

Open it with macros such as:

```bash
caqtdm -macro "IOC=<ioc-name>,CPP_ID=0" $(ecmccfg_DIR)qt/ecmcCppLogic.ui
```

There is also a compact overview panel for several logic instances:

```bash
caqtdm -macro "IOC=<ioc-name>" $(ecmccfg_DIR)qt/ecmcCppLogicOverview.ui
```

That overview shows logic ids `0..7` and opens one instance in
`ecmcCppLogic.ui`.

The built-in runtime names currently include:

- `logic.ctrl.word`
- `logic.stat.word`
- `logic.ctrl.rate_ms`
- `logic.stat.rate_ms`
- `logic.ctrl.update_rate_ms`
- `logic.stat.update_rate_ms`
- `logic.stat.exec_ms`
- `logic.stat.input_ms`
- `logic.stat.output_ms`
- `logic.stat.total_ms`
- `logic.stat.div`
- `logic.stat.count`
- `logic.stat.dbg_txt`

### Record Link Options

The generic C++ logic record templates accept an optional `ASYN_OPT` macro in
front of `PARAM`:

```text
@asyn($(PORT),0,1000)$(ASYN_OPT=)$(PARAM)
```

Existing substitutions that only set `PARAM` continue to work unchanged because
`ASYN_OPT` defaults to an empty string.

Use `ASYN_OPT` when an integer exported variable should be connected through
the `asynFloat64` interface. This is useful for analog records, display tools,
or clients that expect floating-point asyn access:

```text
ASYN_OPT="/TYPE=asynFloat64/CMD=UINT64TOFLOAT64/"
PARAM="my_counter"
```

Supported scalar conversion commands are:

- `INT32TOFLOAT64`
- `UINT32TOFLOAT64`
- `INT64TOFLOAT64`
- `UINT64TOFLOAT64`

For example:

```text
file "$(ecmccfg_DIR)db/generic/ecmcCppLogicAi.template" {
  pattern { P, REC, PORT, ASYN_OPT, PARAM, SCAN }
          { "$(IOC):", "MyCounter", "CPP.LOGIC", "/TYPE=asynFloat64/CMD=UINT64TOFLOAT64/", "my_counter", "I/O Intr" }
}
```

Current control word bits are:

- bit 0: enable execution
- bit 1: enable timing measurements
- bit 2: enable debug text/print publishing

## Generated EPICS Substitutions

User-defined `epics.*` exports can be turned into substitutions offline with:

```bash
python3 examples/PSI/plugins/cpp_logic/utils/ecmcCppLogicSourceSubstGen.py \
  --source src/main.cpp \
  --output cpp_logic.subs
```

The `loadCppLogic.cmd` wrapper then loads:

- built-in core substitutions automatically
- generated custom substitutions automatically from `cfg/<FILE>_cpp_logic.subs` by default
- no custom substitutions when `EPICS_SUBST=EMPTY`

In the IOC-style `cpp_logic` examples, the custom substitutions are normally
generated as:

```text
cfg/libmain.so_cpp_logic.subs
```

The IOC-style examples generate a simple local caQtDM panel with:

```text
qt/<IOC>_cpp_logic.ui
```

Typical example flow:

```bash
make
make pvs
make ui
make install
```

For new IOC projects there is also a scaffold helper in the `cpp_logic` utils
area:

```bash
python3 examples/PSI/plugins/cpp_logic/utils/cpp_logic_new_ioc.py <new-dir>
```

Generated and checked-in startup scripts also include exact `caqtdm` commands
for:

- `ecmcCppLogicOverview.ui`
- `ecmcCppLogic.ui`

If you override `FILE`, keep it as a basename and move the directory into `DIR` so the default substitutions path stays predictable. Example:

```bash
${SCRIPTEXEC} ${ecmccfg_DIR}scripts/loadCppLogic.cmd, \
  "DIR=bin/,FILE=libmain.so,REPORT=1"
```

## Execution Order

The `cpp_logic` execution point is before the safety plugin.

That means user logic can produce values that the safety plugin may still
override afterwards, which is the intended order.

## Examples

IOC-style examples are available in:

```text
examples/PSI/plugins/cpp_logic/
```

Current example families include:

- starter IOC project with one input, two outputs, and two exported PVs
- minimal scalar binding/export
- control/helper usage
- motion wrappers (`MC_*` style)
- array/buffer bindings
- reusable triggered trace capture
- retained parameter/state handling
- EL3702/EL1252-style triggered scope capture

## Related Pages

- [plugins]({{< relref "/manual/plugins/_index.md" >}})
- [C++ Logic Helpers]({{< relref "/manual/plugins/cpp_logic_helpers.md" >}})
- [Plugin Interface]({{< relref "/manual/plugins/interface.md" >}})
- [Script Reference]({{< relref "/manual/general_cfg/script_reference.md" >}})
- [ecmc command reference]({{< relref "/manual/general_cfg/ecmc_command_ref.md" >}})
- [Examples]({{< relref "/manual/examples.md" >}})
