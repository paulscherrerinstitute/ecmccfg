# EL7041-0052 open-loop soft-limit examples

Select one startup file per IOC, with this directory as the working directory.
Each configures axis 4, motor `$(IOC)M1`, on slave 14 (override DRV_SID).
These are alternative configurations of one terminal, not three simultaneous axes.

| Startup | Motor limits | ECMC limits | Synchronization |
| --- | --- | --- | --- |
| startup_motor_only.cmd | -100 to +100 deg | Disabled | Off |
| startup_motor_and_ecmc.cmd | -100 to +100 deg | -100 to +100 deg | Off |
| startup_motor_and_ecmc_synced.cmd | -100 to +100 deg | -100 to +100 deg | On |

The independent configuration starts with equal limits; later motor-limit edits
do not update ECMC limits. The synced configuration uses
`epics.motorRecord.syncSoftLimits: true` to link the limits through the driver.
Motor-only limits constrain motor-record commands; native commands bypass them.

The motor-only YAML first initializes both limit sets, then its startup disables
both ECMC soft-limit enables. Load the startup, not that YAML alone.

Feedback uses the terminal's internal step counter (12800 counts/revolution),
not a mechanical encoder. Scaling assumes a 200-full-step/revolution motor and
SPEED_RANGE=2, using the existing stepper_openloop example's scaling; verify against your hardware.
Adjust motor current, supply voltage, slave address and mechanical travel before
use. Limit/home/interlock inputs are tied to ONE as in the open-loop example;
they do not provide physical switch protection. No motion is requested at startup.

