+++
title = "motion best practice"
weight = 30
chapter = false
+++

## Purpose

This section points to the public best-practice motion examples under
`examples/PSI/best_practice/motion/`.

Use these examples when you want a starting point for a new IOC or when you
want to compare your own YAML configuration with a known working structure.

## Start with these

- I want a general closed-loop stepper example:
  [stepper and BISS-C]({{< relref "/manual/motion_cfg/best_practice/stepper_biss_c.md" >}})
- I want a servo example:
  [servo]({{< relref "/manual/motion_cfg/best_practice/servo.md" >}})
- I want motor-record-specific examples:
  [motor record examples]({{< relref "/manual/motion_cfg/best_practice/motor.md" >}})
- I want SmarAct MCS2:
  `examples/PSI/best_practice/motion/smaract/mcs2/`
- I want profile move / PVT:
  `examples/PSI/best_practice/motion/pvt/el7041_0052/`

## Stepper examples

### stepper and BISS-C

Closed-loop stepper examples with linear BiSS-C encoder:

Guide page:
[stepper and BISS-C]({{< relref "/manual/motion_cfg/best_practice/stepper_biss_c.md" >}})

1. EL7041-0052 and EL5042 in CSV
2. EL7062_CSP and EL5042 in CSP with ecmc position loop enabled

Example tree:
`examples/PSI/best_practice/motion/stepper_bissc/`

### Stepper and incremental

Closed-loop stepper examples with incremental encoder:

1. EX7062/ED7062 in CSV with integrated incremental encoder
2. EL7062_CSP with integrated incremental encoder
3. EL7047 and EL5102

Example trees:

- [EX7062/ED7062 CSV](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_incremental/ex7062_CSV)
- [EL7062 CSP](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_incremental/ex7062_CSP)
- [EL7047 and EL5102](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_incremental/el7047_el5102)

## Special motion examples

### SmarAct

Drive-triggered homing and CSP example for SmarAct MCS2:

- `examples/PSI/best_practice/motion/smaract/mcs2/`

### PVT

Single-axis profile-move / PVT example:

- `examples/PSI/best_practice/motion/pvt/el7041_0052/`

### servo

Servo example based on Ex72xx drive and AM8xxx motor.

Guide page:
[servo]({{< relref "/manual/motion_cfg/best_practice/servo.md" >}})

Example tree:
`examples/PSI/best_practice/motion/servo/`

## Motor-record-related examples

### Auto save restore

Guide page:
[motor record examples]({{< relref "/manual/motion_cfg/best_practice/motor.md" >}})

- `examples/PSI/best_practice/motion/stepper_openloop_asr/`

### Open loop retries

Guide page:
[motor record examples]({{< relref "/manual/motion_cfg/best_practice/motor.md" >}})

- `examples/PSI/best_practice/motion/stepper_openloop_mr_rtry_bissc/`

### No motor record

Guide page:
[motor record examples]({{< relref "/manual/motion_cfg/best_practice/motor.md" >}})

- `examples/PSI/best_practice/motion/stepper_bissc_no_mr/`

## Related pages

- [yaml configuration]({{< relref "/manual/motion_cfg/axisYaml.md" >}})
- [homing]({{< relref "/manual/motion_cfg/homing.md" >}})
- [motor record]({{< relref "/manual/motion_cfg/motor.md" >}})
- [examples]({{< relref "/manual/examples.md" >}})
