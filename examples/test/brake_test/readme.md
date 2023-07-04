# Test of brake functionality

## HW and config
* Current config consists of a stepepr drive EL7031 and an EL2819 output.
* Output 1 of the EL2819 is used as a brake output
* Input 1 of EL7031 is configured as HW-enable input (must be high to enable power to motor). 
* Output 2 of EL2819 is connected to input 1 of EL7031 to contol HW-Enable
* Limits are linked to the "ONE" entry of the drive

## Testing
A python test script (ecmcBrakeTest.py) can be used to test brake behaviour during the following scenarios:
* hw-disable while enabled
* drive intrelock while enabled (simulated by setting both limits to 0)
* normal enabling and disabling sequence

Example:
```
# python ecmcBrakeTest.py <prefix> <axis> <brake output> <hw-enable output> <limits output> <drive stat wd> <brake opening time> <brake closing time>
python ecmcBrakeTest.py IOC_TEST: Axis1 m0s002-BO01 m0s002-BO02 m0s001-One m0s001-Drv01-Stat 1.0 2.0
```
