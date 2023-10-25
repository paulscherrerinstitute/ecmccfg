## EL7041-0052
Test "high speed" with EL7041-0052 and a phytron motor.
The setup uses el7041:s highest speed range (32000 fullsteps/s)

# Conclusion
Running a stepper without mechnics with EL7052-0052 over 600 fullsteps/s is almost impossible. An inertia is needed and damper is needed.
Attaching a damper and inertia allows very high speeds, tested up to 26000 fullsteps/s (130Hz (turns/s)).

## suggested tuning workflow for EL7041 (from beckhoff)

Note: that some of the default values mentioned in the below text is not correct:
* nominal voltage should be 48000 
* current integartor 4 (this leads to a default ratio of 1/100 instead of the mentioned 1/40)

```
    Setup the following basic motor data
    8010:01 Maximal Current
    Set this to the current found on the motor label / datasheet

    8010:02 Reduced Current
    If vertical application, this needs to be at least the current required to hold the motor.
    If horisontal, then you can reduce this a lot, to emit less heat when the motor is standby. How low? It depends on how fast you want to be able to build up torque when it needs to move. Do not set to zero.

    8010:03 Nominal Voltage
    For EL7041 this is always 24000 (24V)

    8010:04 Motor coil resistance
    This is the resistance between motor windings.
    Get the value from the motor datasheet, if you don’t know then leave the default value

    8010:05, Motor EMF
    This is the inductance of the motor
    Get the value from the motor datasheet, if you don’t know then leave the default value.

 

    If you are using TwinCAT NC, then set the module to use operating mode Velocity Control.
    If you are not using TwinCAT NC, then set the module to use Position Interface.
    NEVER use Position Control in the drive, the simulated internal position loop of the EL70x1 is…. not good.

 

    If you are using TwinCAT NC and don’t have any feedback for the stepper from another module, then don’t forget to set Kv=0 to disable the position loop.

 

    Tuning
    Tuning for a stepper motor is always performed with the motor connected to a load.

    8011:07 Ka factor / 8011:08 Kd factor
    These are “current boosts” during acceleration/deceleration.
    Default they are set to 100% which is way too high for most applications.
    In fact, they are rarely used at all, so set them to 0%.
    In some revisions, Kd doesn’t seem to work either so just forget about them.

    8011:01 Kp factor / 8011:02 Ki factor
    This is the current loop settings and this is also where the magic happens.
    The higher you set these, the stiffer the control loop.
    Here's the trick for most applications:
    MAINTAIN THE 40:1 RATIO BETWEEN THESE WHEN CHANGING THEM!
    Default is 400 / 10, if you want a stiffer loop, then change to f ex 800 / 20 and onwards.
    Increase until the motor misbehaves and go back to a safe setting.
    Done.
    But as always, as soon as the motor runs fine with then there’s no need to super duper fine tune and adjust the current loop. You will only end up with a system that works now but stalls in the future as the mechanical parts get worn.
```
```
IOC_TEST:m0s010-Drv01-Stat     2023-02-09 09:03:53.342976 100001000101  
ec0.s10.driveStatus01
```
