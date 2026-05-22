+++
title = "C++ Logic Helpers"
weight = 14
chapter = false
+++

## Scope
This page documents the helper headers that come with the additive
`cpp_logic` interface in `ecmc`.

Use it when:

- you already know how to load a `cpp_logic` module
- and you want a quick reference for the helper classes/functions available in
  the C++ headers

For the IOC loading and runtime model, start with
[C++ Logic]({{< relref "/manual/plugins/cpp_logic.md" >}}).

## Main Headers

The current helper headers are:

- `ecmcCppLogic.hpp`
  Includes the core binding/export API, host-service helpers, and startup
  macro helpers.
- `ecmcCppMotion.hpp`
- `ecmcCppControl.hpp`
- `ecmcCppUtils.hpp`
- `ecmcCppTrace.hpp`
- `ecmcCppPersist.hpp`

These are additive helper layers on top of the `cpp_logic` ABI. They do not
replace the original plugin ABI in `ecmcPluginDefs.h`.

## ecmcCppLogic.hpp

This is the core C++ programming layer.

It provides:

- `ecmcCpp::LogicBase`
- registration macros such as:
  - `ECMC_CPP_LOGIC_REGISTER(...)`
  - `ECMC_CPP_LOGIC_REGISTER_DEFAULT(...)`
- host-service access helpers
- the `ecmc...` item-binding builder
- the `epics...` export builder

Typical pattern:

```cpp
struct MyLogic : public ecmcCpp::LogicBase {
  int32_t actual_position {0};
  int16_t velocity_setpoint {1000};

  MyLogic() {
    ecmc.input("ec.s14.positionActual01", actual_position);
    epics.writable("main.velocity_setpoint", velocity_setpoint);
  }

  void run() override {}
};

ECMC_CPP_LOGIC_REGISTER_DEFAULT(MyLogic)
```

### Creation error handling

`ECMC_CPP_LOGIC_REGISTER_DEFAULT(...)` uses the C++ logic ABI create callback:

```c
int32_t createInstance(void** instance);
```

The callback returns `0` on success and an ecmc error code on failure. On
success, `*instance` contains the created logic object. On failure, the instance
is `nullptr` and `Cfg.LoadCppLogic(...)` returns the error.

For checks that need the constructed object, add an optional `validateCreation(...)`
member function:

```cpp
struct MyLogic : public ecmcCpp::LogicBase {
  MyLogic() {
    // Build bindings and local state.
  }

  int32_t validateCreation(std::string* errorMessage) {
    if (bad_config) {
      if (errorMessage) {
        *errorMessage = "bad config: missing AXIS_ID";
      }
      return ECMC_CPP_LOGIC_CREATE_INSTANCE_FAIL;
    }
    return 0;
  }
};
```

If `validateCreation(...)` returns an error, the default adapter deletes the object,
returns the error code over the ABI, and passes the message to
`Cfg.LoadCppLogic(...)`.

Use `ecmcConfigOrDie "Cfg.LoadCppLogic(...)"` in startup scripts when a failed
creation should stop IOC startup.

### Binding/export helpers

For scalar values:

- `ecmc.input(...)`
- `ecmc.output(...)`
- `epics.readOnly(...)`
- `epics.writable(...)`

For arrays:

- `ecmc.inputArray(...)`
- `ecmc.outputArray(...)`
- `ecmc.inputAutoArray(...)`
- `ecmc.outputAutoArray(...)`
- `epics.readOnlyArray(...)`
- `epics.writableArray(...)`

For raw buffers:

- `ecmc.inputBytes(...)`
- `ecmc.outputBytes(...)`
- `epics.readOnlyBytes(...)`
- `epics.writableBytes(...)`

### Runtime/service helpers

The core header also exposes small helper functions backed by ECMC host
services:

- `ecmcCpp::getCycleTimeS()`
- `ecmcCpp::getEcTimeNs()`
- `ecmcCpp::getEcTimeOffsetNs()`
- `ecmcCpp::getEcDomainState(...)`
- `ecmcCpp::getEcStatusOK()`
- `ecmcCpp::getEcMasterStateWord(...)`
- `ecmcCpp::getEcSlaveStateWord(...)`
- `ecmcCpp::lutExists(...)`
- `ecmcCpp::lutGetValue(...)`
- `ecmcCpp::getIocState()`
- `ecmcCpp::requestIocExit(...)`
- `ecmcCpp::setEnableDbg(...)`
- `ecmcCpp::publishDebugText(...)`

Typical use cases:

- read the configured realtime cycle time without hard-coding it
- read EtherCAT application time, monotonic offset, domain status, and consolidated status
- inspect EtherCAT master/slave state words from logic code
- read values from ecmc lookup tables loaded during IOC startup
- request IOC shutdown when logic detects an unrecoverable condition
- enable cpp-logic debug publishing from code
- publish one-line runtime debug/status messages to the built-in debug text path

Lookup table access uses the same LUT objects as the PLC `lut_get_value(...)`
helper:

```cpp
double correction = 0.0;
if (ecmcCpp::lutExists(0)) {
  correction = ecmcCpp::lutGetValue(0, position);
}
```

The first argument is the LUT id. The second argument is the input/index value.
The helper returns `0.0` if the LUT id is out of range or if the LUT object has
not been loaded. Use `ecmcCpp::lutExists(...)` when logic should check for an
optional LUT without logging an error. See [Lookup Tables]({{< relref "/manual/general_cfg/lut.md" >}})
for loading and file format details.

IOC exit requests are deferred through the main realtime loop. The helper only
sets an exit request flag:

```cpp
if (fatal_condition) {
  ecmcCpp::requestIocExit(1);
}
```

Do not call `exit()` or `epicsExit()` directly from `run()`. Use
`requestIocExit(...)` for fatal conditions where the whole IOC should stop. The
main realtime loop observes the request and leaves through the ecmc cleanup path.

### Startup macro helpers

The IOC `loadCppLogic.cmd` `MACROS` argument is available to user code as a
plain text string. It is intended for small configuration values such as slave
ids, axis ids, feature flags, and simple numeric tuning constants.

Available helpers:

- `ecmcCpp::getMacrosString()`
- `ecmcCpp::getMacroValue(macros, key)`
- `ecmcCpp::getMacroValueString(macros, key, defaultValue)`
- `ecmcCpp::getMacroValueInt(macros, key, defaultValue)`
- `ecmcCpp::getMacroValueDouble(macros, key, defaultValue)`

Typical use:

```cpp
const std::string macros = ecmcCpp::getMacrosString();
const int slave_id = ecmcCpp::getMacroValueInt(macros, "S_ID", 14);
const int axis_id = ecmcCpp::getMacroValueInt(macros, "AXIS_ID", 1);
const bool dbg = ecmcCpp::getMacroValueInt(macros, "DBG", 0) != 0;
const double gain = ecmcCpp::getMacroValueDouble(macros, "GAIN", 1.0);
const std::string mode = ecmcCpp::getMacroValueString(macros, "MODE", "normal");

ecmcCpp::setEnableDbg(dbg);
```

`getMacroValue(...)` returns an empty string when the key is missing.
`getMacroValueString(...)` returns the default value when the key is missing.
The numeric helpers return the default value when the key is missing or when
parsing fails. The parser accepts comma-separated `KEY=VALUE` text and ignores
commas inside single or double quoted values. Optional matching quotes around a
value are removed.

### Axis host-service helpers

`ecmcCppLogic.hpp` also exposes direct axis-oriented helpers backed by ECMC host
services. These are separate from the `MC_*` wrappers in `ecmcCppMotion.hpp`.

Trajectory and encoder source selection:

- `ecmcCpp::axisUseInternalTraj(...)`
- `ecmcCpp::axisUseExternalTraj(...)`
- `ecmcCpp::axisUseInternalEnc(...)`
- `ecmcCpp::axisUseExternalEnc(...)`

Axis state readback:

- `ecmcCpp::axisGetActualPos(...)`
- `ecmcCpp::axisGetSetpointPos(...)`
- `ecmcCpp::axisGetActualVel(...)`
- `ecmcCpp::axisGetSetpointVel(...)`
- `ecmcCpp::axisIsEnabled(...)`
- `ecmcCpp::axisIsBusy(...)`
- `ecmcCpp::axisHasError(...)`
- `ecmcCpp::axisGetErrorId(...)`

External source value injection:

- `ecmcCpp::axisSetExternalSetpointPos(...)`
- `ecmcCpp::axisSetExternalEncoderPos(...)`

Use these helpers when the logic should work directly with ECMC axis source
selection or external trajectory/encoder feeds, instead of using the higher
level PLCopen-style `MC_*` blocks.

## ecmcCppControl.hpp

Current control helper:

- `ecmcCpp::Pid`

It supports:

- `Kp`, `Ki`, `Kd`
- feed-forward with `FF` and `Kff`
- output limiting with `OutMin` / `OutMax`
- integral limiting with `IMin` / `IMax`
- optional derivative filtering with `DFilterTau`

Outputs include:

- `Output`
- `Error`
- `PPart`
- `IPart`
- `DPart`
- `FFPart`
- `Limited`

## ecmcCppMotion.hpp

This header provides `MC_*` style wrappers on top of the existing `ecmc`
motion backend.

Current wrappers include:

- `ecmcCpp::McAxisRef`
- `ecmcCpp::McPower`
- `ecmcCpp::McReset`
- `ecmcCpp::McMoveAbsolute`
- `ecmcCpp::McMoveRelative`
- `ecmcCpp::McHome`
- `ecmcCpp::McMoveVelocity`
- `ecmcCpp::McStop`
- `ecmcCpp::McReadStatus`
- `ecmcCpp::McReadActualPosition`
- `ecmcCpp::McReadActualVelocity`

Use it when you want PLCopen-style motion patterns from native C++ logic
without writing the lower-level axis API calls directly.

## ecmcCppUtils.hpp

This header contains the small reusable helpers that are most often used in
scan-based logic.

### Triggers and timers

- `ecmcCpp::RTrig`
- `ecmcCpp::FTrig`
- `ecmcCpp::Ton`
- `ecmcCpp::Tof`
- `ecmcCpp::Tp`

These are intended to feel familiar to users coming from IEC/ST helper blocks.

### Latches and toggles

- `ecmcCpp::Sr`
- `ecmcCpp::Rs`
- `ecmcCpp::FlipFlop`

### Small runtime/state helpers

- `ecmcCpp::Blink`
- `ecmcCpp::StateTimer<T>`
- `ecmcCpp::DebounceBool`
- `ecmcCpp::StartupDelay`
- `ecmcCpp::RateLimiter`
- `ecmcCpp::FirstOrderFilter`
- `ecmcCpp::HysteresisBool`
- `ecmcCpp::Integrator`
- `ecmcCpp::MoveAverage`
- `ecmcCpp::MinMaxHold`

### Scalar helper functions

- `ecmcCpp::applyDeadband(...)`
- `ecmcCpp::clampValue(...)`
- `ecmcCpp::inWindow(...)`
- `ecmcCpp::readBit(...)`
- `ecmcCpp::writeBit(...)`
- `ecmcCpp::setBit(...)`
- `ecmcCpp::clearBit(...)`
- `ecmcCpp::toggleBit(...)`

The bit helpers work on integer word types such as `uint8_t`, `uint16_t`,
`int32_t`, and `uint64_t`. They return a value and do not modify the input by
reference.

Example:

```cpp
uint16_t drive_control {0};

drive_control = ecmcCpp::setBit(drive_control, 0);
drive_control = ecmcCpp::writeBit(drive_control, 3, enable_brake);
const bool brake_enabled = ecmcCpp::readBit(drive_control, 3);
```

Out-of-range bit indexes are handled without undefined shifts:
`readBit(...)` returns `false`, while the write-style helpers return the
unchanged input value.

### EtherCAT status wrappers

- `ecmcCpp::getEcTimeNs()`
- `ecmcCpp::getEcTimeOffsetNs()`
- `ecmcCpp::getEcDomainState(...)`
- `ecmcCpp::getEcStatusOK()`
- `ecmcCpp::EcMasterStatus`
- `ecmcCpp::EcSlaveStatus`

## ecmcCppTrace.hpp

Current trace helper:

- `ecmcCpp::TriggeredTrace<T, Capacity>`

It provides:

- rolling pre-trigger history
- capture of pre-trigger, trigger, and post-trigger samples
- fixed-capacity waveform-style output arrays
- explicit arming and capture-ready state

## ecmcCppPersist.hpp

Current persistence helper:

- `ecmcCpp::RetainedValue<T>`

It provides:

- binary load/save of trivially copyable values
- explicit `restore()` and `store()` calls
- a simple retained-parameter pattern for startup/manual save actions
- a design intended for infrequent persistence, not per-cycle file I/O

## Examples

The main example families are:

- starter IOC project
- minimal scalar binding/export
- control/helper usage
- motion wrappers
- array/buffer bindings
- reusable triggered trace capture
- retained parameter/state handling
- triggered EL3702/EL1252-style scope capture

See the IOC-style examples in:

```text
examples/PSI/plugins/cpp_logic/
```

The best example for container and array bindings is the array-oriented
example. The best example for timers/triggers/filtering is the control example.
The best examples for the new helpers are the dedicated trace and retained
examples.

## Related Pages

- [C++ Logic]({{< relref "/manual/plugins/cpp_logic.md" >}})
- [Plugin Interface]({{< relref "/manual/plugins/interface.md" >}})
- [Script Reference]({{< relref "/manual/general_cfg/script_reference.md" >}})
- [ecmc command reference]({{< relref "/manual/general_cfg/ecmc_command_ref.md" >}})
- [Examples]({{< relref "/manual/examples.md" >}})
