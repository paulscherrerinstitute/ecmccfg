# Blocked motion functions with homing allowed

This IOC exercises one axis with normal position and velocity commands blocked
while homing remains allowed. Disabled commands are ignored at admission, so an
ABS/REL/velocity request cannot clear the execute state of an active home.

`startup.cmd` permanently configures:

```text
Cfg.SetAxisIgnoreDisabledMotionCommands(1,1)
Cfg.SetAxisEnableMotionFunctions(1,1,1)
```

PLC 0 uses its debug input as the test interlock. On its rising edge the PLC:

1. Changes the allowed functions to `(position=0, velocity=0, home=1)`.
2. Disables the axis natively and waits for both `Busy=0` and drive disabled.
3. Re-enables the drive and triggers homing procedure 1.
4. Keeps ordinary moves blocked throughout homing.
5. Disables the drive after completion, abort or timeout.

While homing is busy, repeatedly write motor-record `.VAL` or native
`MtnCmd=3/TgtPosCmd/ExeCmd` requests. They must be ignored and homing must
continue. Native or motor-record STOP and disable requests are deliberately not
filtered; they must abort homing. The PLC recognizes that abort and ends in its
safe disabled state.

When the debug interlock returns low, all motion functions are admitted again.
The ignore-disabled policy remains enabled because it has no effect while all
three function classes are allowed.

## End-to-end spam test

`test_block_motion_funcs.py` runs one continuous worker that spams alternating
motor and native absolute setpoints. The main loop periodically clears and
raises `PLC00-DbgCmd`; command spam never pauses while the PLC starts and runs
homing. Each high transition must produce a home that remains active until
Homed is set.

The test does not enable the axis. It relies on the axis auto-enable
configuration and only observes `EnaAct`. Failure cleanup still requests STOP
and disable as a safety action.

The IOC prefix and two hardware-safe absolute positions are mandatory:

```sh
python3 test_block_motion_funcs.py IOC-PREFIX: SAFE_POSITION_A SAFE_POSITION_B
```

The script commands real motion. On failure or interruption it stops command
spam, requests native STOP and disable, and finally clears the test block. On a
successful run it stops command spam before clearing the block so that no
delayed target becomes newly admissible.

By default it keeps spamming and toggling the debug block until Ctrl-C. Use
`--cycles N` for exactly N debug-trigger/homing cycles, for example:

```sh
python3 test_block_motion_funcs.py IOC-PREFIX: POS_A POS_B --cycles 10
```

Trigger timing rotates through immediate/race, just-enabled, actively-moving
and random-delay phases. Each phase also gets random jitter, so the debug edge
can land while idle or during enable/motion transitions. Use `--seed N` to
reproduce the same jitter sequence after a failure.
