# Soft-limit autosave/restore IOC projects

These subdirectories turn the three configurations in `../softlimits` into
separate PSI `ioc install` projects:

| Project | IOC | Motor restore | ECMC limits | Runtime sync |
| --- | --- | --- | --- | --- |
| `softlimits_motor_only` | `MTEST04-EC-ASR` | `.DLLM/.DHLM` | Disabled after loading | Off |
| `softlimits_motor_and_ecmc` | `MTEST04-EC-ASR` | `.DLLM/.DHLM` | YAML-configured, independent | Off |
| `softlimits_motor_and_ecmc_synced` | `MTEST04-EC-ASR` | `.DLLM/.DHLM` copied to ECMC | Same restored pair | On |

Each project is self-contained. Run `make install` in only the desired project;
all three target the same EL7041-0052 at slave 14 and are alternatives, not
simultaneous axes. All three deliberately use the same `MTEST04-EC-ASR` IOC
identity, so install and run only one at a time. Adapt host, port, module
versions, slave address, electrical settings, scaling, and travel before using
real hardware.

The `_pos.req` files select PSI two-pass restore (passes 0 and 1). The startup
gate keeps motion command producers held until motor-record restoration has
completed. All three projects save only the motor dial-limit fields. In the
independent project, ECMC retains its YAML-configured values; restoring its
writable configuration records in the same request would create a competing
restore path. In the synchronized project, the restored motor pair is copied
to ECMC and remains authoritative.
