+++
title = "Examples"
weight = 50
chapter = false
+++

## How to use this page

Prefer `examples/PSI/best_practice/` as the public, reusable starting point for
new configurations. Pick the example that is closest to your hardware or use
case, copy it into your IOC area, and then adapt the macros, component
selection, and YAML files.

## Start from these first

- I want a minimal axis example:
  [Quickstart]({{< relref "/manual/quickstart.md" >}})
- I want stepper motion with common Beckhoff terminals:
  [Stepper BiSS-C](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_bissc)
- I want incremental stepper examples:
  [EL7047 + EL5102](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_incremental/el7047_el5102) or
  [EX7062 CSV](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_incremental/ex7062_CSV) or
  [EL7062 CSP](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_incremental/ex7062_CSP)
- I want PLC examples:
  [basic PLCs](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/plcs/basic) or
  [master-less PLC](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/plcs/masterless)
- I want data storage:
  [data storage buffer](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/general/data_storage)

## Motion examples

- [Stepper BiSS-C](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_bissc)
  EL7041/EL5042 and EL7062/EL5042 examples
- [Stepper incremental, EL7047 + EL5102](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_incremental/el7047_el5102)
- [Stepper incremental, EX7062 CSV](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_incremental/ex7062_CSV)
- [Stepper incremental, EL7062 CSP](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_incremental/ex7062_CSP)
- [SmarAct MCS2](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/smaract/mcs2)
- [PVT profile move, EL7041-0052](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/pvt/el7041_0052)
- [Stepper open loop + autosave restore](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_openloop_asr)
- [Stepper open loop + retries](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_openloop_mr_rtry_bissc)
- [Stepper without motor record](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_bissc_no_mr)
- [Servo CSV](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/servo/csv)
- [Hardware substitution template](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/stepper_bissc_hw_subst)

## Synchronization examples

- [Slit synchronization](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/syncs/slit)
- [Mirror synchronization](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/motion/syncs/mirror)

## PLC and general examples

- [Basic PLC examples](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/plcs/basic)
- [Master-less PLC example](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/plcs/masterless)
- [Motion sequence PLC example](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/plcs/motion/stepper_bissc_forw_back_seq)
- [Data storage buffer](https://github.com/paulscherrerinstitute/ecmccfg/tree/master/examples/PSI/best_practice/general/data_storage)

## Legacy ESS examples

The `examples/ESS/` tree is mainly useful when reading or maintaining older
classic motion configurations based on `.ax`, `.vax`, and `.sax` files.

See [legacy motion]({{< relref "/manual/motion_cfg/legacy.md" >}}) for the
corresponding manual page.

## Notes

- Prefer `addSlave.cmd` together with `applyComponent.cmd` for slave and component setup.
- Prefer `loadYamlAxis.cmd` for axes.
- Prefer `loadYamlPlc.cmd` or `loadPLCFile.cmd` for PLCs.
- Keep drive SDO verification enabled, and configure unused channels with `Generic-Ch-Not-Used`.
