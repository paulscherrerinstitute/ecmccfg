+++
title = "Motor Record"
weight = 23
chapter = false
+++

## Scope

This page covers motion topics related to the EPICS motor record in ecmccfg.

Read this page when:

- you use the motor record on a motion axis
- you want auto save restore of motor position
- you want retry behavior based on another readback source
- you want to disable the motor record for a specific axis

For YAML configuration of the motor record itself, see
[yaml configuration]({{< relref "/manual/motion_cfg/axisYaml.md" >}}).
For example-driven setups, see
[motor record examples]({{< relref "/manual/motion_cfg/best_practice/motor.md" >}}).

<a id="native-target-write-mode"></a>

For the independent native ECMC target-position interface, see [Native target-write mode]({{< relref "/manual/motion_cfg/native_target_write.md" >}}).

## Common use cases

### Auto save restore

See [Motor position and soft-limit autosave]({{< relref "/manual/motion_cfg/autosave.md" >}}) for incremental-encoder position restoration, request files and startup ordering.

### Open-loop retries based on another readback

Another common use case is open-loop motion with retries based on an absolute
encoder or another EPICS readback source.

Typical setup:

- one encoder is used for the axis control path
- another readback PV is connected to the motor record retry logic
- the motor record retries until the readback is within the retry deadband

This is the pattern used in the open-loop retry examples.

## Useful motor-record fields

These fields are often relevant in retry-based setups:

1. `RTRY`: max retry count
2. `RMOD`: retry mode
3. `UEIP`: use encoder if present
4. `RDBD`: retry deadband
5. `URIP`: use RDBL link if present
6. `RDBL`: readback link

### `RTRY`

Maximum retry count. Must be greater than zero to enable retry behavior.

### `RMOD`

Retry mode:

- `0`: Unity
- `1`: Arithmetic
- `2`: Geometric
- `3`: In-Position

For retry tests, modes `1` and `2` are the normal choices.

### `UEIP`

Use encoder if present. In the retry example this is normally set to `0`.

### `RDBD`

Retry deadband. If the readback is outside this band, another move is started.

### `URIP`

Use `RDBL` if present. Set this to `1` when the retry logic should use the
linked readback PV.

### `RDBL`

Readback link used by the motor record retry logic. This can be any EPICS PV.
In practice it is often linked to another encoder readback.

## Setting fields from YAML

Additional motor-record fields can be set through
`epics.motorRecord.fieldInit`.

Example:

```yaml
epics:
  name: ${AX_NAME=M1}
  precision: 3
  description: Test cfg
  unit: mm
  motorRecord:
    fieldInit: 'FOFF=Frozen,RRES=1.0,RTRY=2,RMOD=1,UEIP=0,RDBD=0.1,URIP=1,RDBL=$(IOC):${AX_NAME=M1}-Enc${RTRY_ENC_CH=01}-PosAct'
```

{{% notice warning %}}
Do not use `CP` on the `RDBL` link in this workflow.
{{% /notice %}}

## Running a retry-based test

Typical sequence:

1. start the IOC
2. write a target position to the motor record
3. observe the move and retry behavior until the linked readback is within
   deadband

Example:

```text
dbpf IOC_TEST:Axis1 10
```

Expected result in the retry example:

1. ecmc axis actual position ends at the open-loop equivalent value
2. motor record position ends at the requested target

Jogging is generally not supported in this retry-based setup.

## Low-level motor-controller iocsh commands

Most `ecmccfg` users do not need to call the low-level motor-record iocsh
commands directly, because the startup scripts and YAML loaders do that work.

The underlying motor layer in `ecmc` also registers:

```text
ecmcMotorRecordCreateController(<port>, <not_used>, <not_used>, <movingPollMs>, <idlePollMs>, <options>)
ecmcMotorRecordCreateAxis(<controllerPort>, <axisNo>, <axisFlags>, <axisOptions>)
```

These are relevant mainly when:

- bringing up raw `ecmc` without the normal `ecmccfg` startup flow
- debugging the motor-record layer itself
- working directly with custom controller/axis creation outside the YAML and classic wrappers

For PVT/profile-move specific direct commands, see [PVT]({{< relref "/manual/motion_cfg/pvt.md" >}}).

## Alarm behavior on `RDBL`

If the `RDBL` PV goes into `MAJOR` or `INVALID` alarm, the motor record stops
motion independent of severity propagation settings.

This is useful for protective interlocking, but it also means that badly chosen
alarm limits on the linked readback can stop motion unexpectedly.

This is especially relevant if the linked value is derived from an incremental
encoder or a calculated signal that can leave the normal operating range during
homing or switch events.

## Temporarily bypassing the `RDBL` interlock

If motion is blocked by the `RDBL` alarm path, the retry link can be disabled by
setting `URIP` to `0`:

```text
dbpf IOC_TEST:Axis1.URIP 0
```

Motion can then continue, but retries based on `RDBL` are disabled while this
setting is active.

## Disabling the motor record

Set `epics.motorRecord.enable: false` in the axis YAML to use the native interface without a motor record. For PLC access to the motor record `OFF` and `DIR` fields and binding status, see [PLC variables]({{< relref "/manual/plc_cfg/variables.md" >}}).

## Related examples

- auto save restore:
  `examples/PSI/best_practice/motion/stepper_openloop_asr/`
- open loop retries:
  `examples/PSI/best_practice/motion/stepper_openloop_mr_rtry_bissc/`
- no motor record:
  `examples/PSI/best_practice/motion/stepper_bissc_no_mr/`
