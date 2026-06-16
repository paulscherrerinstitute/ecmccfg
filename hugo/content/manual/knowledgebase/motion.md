+++
title = "motion"
weight = 14
chapter = false
+++

## Scope
Use this page when an axis is present in the IOC but motion still behaves
incorrectly, for example due to limits, following errors, enable problems, or
special PLC-based limit logic.

## Related pages
- [motion configuration]({{< relref "/manual/motion_cfg/_index.md" >}})
- [homing]({{< relref "/manual/motion_cfg/homing.md" >}})
- [troubleshooting]({{< relref "/manual/knowledgebase/troubleshooting.md" >}})
- [tuning]({{< relref "/manual/knowledgebase/tuning.md" >}})
- [hardware]({{< relref "/manual/knowledgebase/hardware/_index.md" >}})

## Topics
1. [ERROR_MON_TOL_OUT_OF_RANGE](#error_mon_tol_out_of_range)
2. [both_limits error](#both_limits-error)
3. [position lag error, (following error)](#position-lag-error)
4. [drive refuses to enable](#drive-refuses-to-enable)
5. [force manual motion](#force-manual-motion)
6. [double limit switches](#double-limit-switches)

---

## ERROR_MON_TOL_OUT_OF_RANGE
The `ERROR_MON_TOL_OUT_OF_RANGE` error means that a monitor tolerance, range, or
limit window is invalid. One possible cause is a virtual axis where the
softlimits are calculated dynamically from one or more physical axes.

For example, in a slit system the virtual gap and center axes may depend on the
current physical blade positions and the physical axis softlimits. If the
physical axes and gap are moved to extreme positions, the calculated valid range
for the virtual center axis can become invalid. A typical symptom is that the
calculated low softlimit becomes higher than the calculated high softlimit. This
is not a valid motion range, and ecmc should block motion rather than allow an
unsafe or undefined move.

To recover, check the calculated softlimits for both the physical and virtual
axes. The system must be brought back into a valid operating range. Depending on
the setup, this may require increasing the softlimit range on the physical axes
or moving the physical axes/gap away from the extreme positions so that the
virtual axis limits can be calculated correctly again.

## both_limits error
The `BOTH_LIMITS` error can be related to limit switches not being powered with
24V. At PSI, limits are normally fed from 24V outputs, typically an EL2819
terminal. The outputs therefore need to be set to `1` to power the switches.
Check the schematics to find which output powers the switches for a given axis,
then use one of the following approaches to set it to `1`:

Define the output in the axis YAML file:
```yaml
axis:
  id: 1                                               # Axis id
  ...
  feedSwitchesOutput: ec0.s5.binaryOutput02           # EtherCAT entry for feed switches
  ...
```

By using the command `Cfg.WriteEcEntryEcPath(ec<master_id>.s<slave_id>.binaryOutput<id>,<value>)`:
```bash
ecmcConfigOrDie "Cfg.WriteEcEntryEcPath(ec0.s5>.binaryOutput02,1)"
```

## position lag error
A position lag error (following error) can be generated in the following situations:
1. The motor torque is too low, making it hard for the motor to keep up with the setpoint.
2. The scaling factors are wrong resulting in that the feed forward part of the controller is not working well.
3. The velocity setpoint is too high resulting in motor stall (common for stepper motors).
4. The velocity setpoint is higher than what the drive can achieve (saturated velocity setpoint).

### 1. motor torque too low

1. First ensure that the mechanics are in good condition and not blocked (over the entire working range). If possible, measure required torque with a torque meter.
2. Check motor data, can the motor deliver the required torque at the required speed. If not, then a motor with higher torque is needed.
3. Check the current setting of the motor. If possible increase the current setting to get a higher torque.

{{% notice warning %}}
Before increasing current to the motor, make sure that both motor and drive can handle the higher current. Extra care is needed for vacuum applications.
{{% /notice %}}

### 2. scaling factors are wrong
Check the scaling documentation [here](../../motion_cfg/scaling/).
One way to test if the scaling is correct is to set all controller parameters (except Kff) to 0 and then initiate a move. Basically the actual position of the axis should follow the setpoint closely with the same slope. If the slope differs, then the scaling factors are wrong.

### 3. the velocity setpoint is too high resulting in stall
If a stepper motor stalls because of excessive velocity, there are a few things that can be done to improve the ability to reach higher velocities:
1. Add a damper: This is normally very efficient but not always possible.
2. Tune controller parameters (both position loop in ecmc and the controller loops in the drive), see hardware/tuning
3. If possible, test to increase or reduce current (make sure you do not burn the motor if increasing).

{{% notice warning %}}
Before increasing current to the motor, make sure that both motor and drive can handle the higher current. Extra care is needed for vacuum applications.
{{% /notice %}}

### 4. velocity higher than allowed by driver
The velocity setpoint of drives covers a certain velocity range:
* EL70xx stepper drives default: 16-bit setpoint that corresponds to a velocity range of +-2000 full-steps/s.
* EL72xx servo drives default: 32-bit setpoint that corresponds to a velocity range of either +-6000Hz or +-8000Hz depending on the motor pole count.

If a velocity outside the velocity range is requested, the velocity setpoint will be saturated and the requested velocity will not be reached resulting in a position lag error.

For EL70xx drives the velocity range can be configured to other values than the default +-2000full-steps/s. See
[el70x1 speed range](../hardware/el70x1#speed-range) for setting other velocity range.

## drive refuses to enable
First check the dedicated hardware drive panel for diagnostics and errors/warnings.
For EL70x1 drive diagnostics, check [el70x1](../hardware/el70x1).

Possible reasons:
1. For systems equipped with motion safety (STO or power to the drive removed by contactor): Check status of safety system. Drives with STO:
  * EL72xx-9xxx
  * EP7211-0034
  * Festo CMMT-S
2. Over current protection of motor power (48V) tripped.
3. No motor power connected (48V or 24V).
4. ecmc PLC disabling axis, check PLC sources.
5. Motion axis in error state. Some errors prevent the axis from being enabled. Check axis error state.
6. Drive hardware enable input not set high (valid for EL70xx if special cfgs).
7. Axis object configured with external interlock (`yaml->input.interlock`).
8. Encoder or drive in error state or not ready. If axis is in startup state (see expert panel). Then these errors blocks axis from going into runtime. If, for instance, one encoder is not ready (could be issue with BISS-C), then motion could be possible with other encoder selected as primary (open loop).

## force manual motion
{{% notice warning %}}
This procedure is for experts only. You run the risk of destroying expensive devices. Limit switches are _not_ obeyed. YOU HAVE BEEN WARNED!
{{% /notice %}}
If the hardware looks fine, the cables are checked, normal setup mistakes are
mostly excluded, or the system used to work but no longer does, directly
writing to the drive can be used as a last diagnostic step.

For this however, the IOC needs to be reconfigured to _not_ link the hardware to an axis!
1. Edit the startup script and comment out the axis, just leave the slave configuration.
2. restart the IOC
3. check the PVs for the drive in question (slave 7 in this case)
4. `dbgrep "*s007*"`
5. There should be two PVs ending with, `-Drv01-Cmd` and `-Drv01-Spd`
6. Set `-Drv01-Cmd` to `1` and check the amplifier did enable, if you don't know how to check for an enabled amplifier, you should not use this command!
7. After the amplifier is engaged, write a small number to `-Drv01-Spd`. Depending on the scaling, the number might be in the range of 1..1000.
8. Observe the encoder, or in case of open-loop, the device itself.

## double limit switches
For axes with dual limit switches, or where special logic is needed, limit switches can be overridden by the keyword `plcOverride`:
```yaml
...
input:
  limit:
    forward: 'plcOverride'                            # Overridden, see plc code below
    backward: 'plcOverride'                           # Overridden, see plc code below
...
```
The limits must then be written from PLC code. Any logic can be applied to set the limits, for example:
```txt
...
plc:
  enable: true                                        # Enable axis plc
  externalCommands: true                              # Allow axis to inputs from PLC
  code:                                               # Sync code (appended after code in plc.file)
    - ax${AX_ID=1}.mon.lowlim:=ec_chk_bit(ec0.s$(DRV_SID).binaryInputs01,0) and ec0.s2.analogInput01<1000;
    - ax${AX_ID=1}.mon.highlim:=ec_chk_bit(ec0.s$(DRV_SID).binaryInputs01,1) and ec0.s33.binaryInput02;
...
```
Note that in PLC code, bits must be accessed with the `ec_chk_bit()` command.

## double limit switches legacy (still an option)
Sometimes two limit switches are needed, but only one can be linked in the YAML configuration. One use case is overlapping axis ranges where a switch is used to prevent collisions.

To configure this, add a PLC where the two limit switches are combined with an `and` (for normally closed switches) into one bit by using a simulation entry. For new configurations, prefer a named global simulation entry. Legacy configurations can still use scoped simulation entries such as `ec<mid>.s<sid>.ZERO`.

1. Add a plc
2. Add a global simulation entry, for example `Cfg.EcAddSimEntry(SIM_LIMITS,U32,0)`.
3. Choose an unused bit in the simulation entry.
4. Add code to combine the two switches into one bit ("and"). Use ec_wrt_bit to set the value.
5. Use the selected simulation bit in the YAML config.

Example (use `SIM_LIMITS.31` as combined limit switch):

```txt
ecmcConfigOrDie "Cfg.EcAddSimEntry(SIM_LIMITS,U32,0)"
```

```txt
# Bit 31
# Switch 1: ec0.s5.binaryInput01
# Switch 2: ec0.s5.binaryInput02
SIM_LIMITS:=ec_wrt_bit(SIM_LIMITS,ec0.s5.binaryInput01 and ec0.s5.binaryInput02,31);
```

Then use it as a forward or backward bit in YAML:

```yaml
input:
  limit:
    forward: SIM_LIMITS.31     # In PLC "ec0.s5.binaryInput01 and ec0.s5.binaryInput02"
    backward: ....
```

Legacy example (use `ec0.s2.ZERO.31` as combined limit switch):

1. Choose an unused bit in the simulation entry `ec<mid>.s<sid>.ZERO` (dummy 32-bit memory area in ecmc initialized to 0). Any slave can be chosen, but it probably makes sense to use the drive slave.
2. Add code to combine the two switches into one bit ("and"). Use ec_wrt_bit to set the value.
3. Use the selected simulation bit in the YAML config.

```txt
# Master 0
# Drive slave  3 (can be any slave)
# Bit 31
# Switch 1: ec0.s5.binaryInput01
# Switch 2: ec0.s5.binaryInput02
ec0.s3.ZERO:=ec_wrt_bit(ec0.s3.ZERO,ec0.s5.binaryInput01 and ec0.s5.binaryInput02,31);
```
Then use it as a forward or backward bit in YAML:
```yaml
input:
  limit:
    forward: ec0.s2.ZERO.31     # In PLC "ec0.s5.binaryInput01 and ec0.s5.binaryInput02"
    backward: ....
```

## YAML parser installation error

If you use the default `jinja` backend, YAML loading depends on a Python venv with certain libraries. The venv is created in `/tmp` when the first YAML axis/plc file is loaded.

If the ecmc-server is not allowed to install with `pip` (for example in machine networks), then the error message below is printed in iocsh and axis loading fails:
```
iocshLoad /gfa/.mounts/sls_ioc/modules/ecmccfg/9.6.8/R7.0.8/loadYamlAxis.cmd,     "FILE=cfg/servo-linear.yaml, ID=1, NAME=SERVO1, DESC=test, DRV_SLAVE=9"
#==============================================================================
# loadYamlAxis.cmd
on error halt
# Step 1: Get filename (need to check if filename also contains other macros). Basically run the filename in this iocsh
ecmcFileExist("cfg/servo-linear.yaml",1)
epicsEnvSet(FILE_TEMP_BASE,/tmp/X01DD-CPCL-FEMOT02/EcMaster_2/cfg/servo-linear.yaml)
epicsEnvSet(FILE_TEMP_1,/tmp/X01DD-CPCL-FEMOT02/EcMaster_2/cfg/servo-linear.yaml_1)
system ". /gfa/.mounts/sls_ioc/modules/ecmccfg/9.6.8/R7.0.8/pythonVenv.sh -d /tmp/X01DD-CPCL-FEMOT02/EcMaster_2/; python /gfa/.mounts/sls_ioc/modules/ecmccfg/9.6.8/R7.0.8/ecmcPlcGetFileName.py cfg/servo-linear.yaml /tmp/X01DD-CPCL-FEMOT02/EcMaster_2/cfg/servo-linear.yaml_1"
Collecting wheel
  Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/wheel/
  Retrying (Retry(total=3, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/wheel/
  Retrying (Retry(total=2, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/wheel/
```

PSI specific: The solution is to use the `ecmc_server_cfg` repo as described in its `README.md`. This repo ensures that the correct Python venv is copied after each boot, so installation is not needed at IOC startup.

{{% notice info %}}
As an alternative to the Python backend, ecmccfg can use the C++ tool `ecb` as YAML parser/render backend (`ECMC_CFG_TOOL=ecb`). See [motion_cfg/ecb](../../motion_cfg/ecb/).
{{% /notice %}}
