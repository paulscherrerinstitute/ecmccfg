# Brushed DC motor Open loop
Basically just sending voltage setpoint to motor.. Special config.
The setup requires that certain TML code is executed.

NOTE: Different current scaling of the 4808 vs the 8020


## current scaling factor
```
current [A] = 2*Ipeak/65520*current[IO]

```
IU=internalunit (basically the word)

### 8020

Current scaling factor, Ipeak=40A:
```
scaling factor = 2*Ipeak/65520

2*40/65520=0.00122
```
### 4808

Current scaling factor, Ipeak=20A:
```
scaling factor = 2*Ipeak/65520

2*20/65520=0.0006105
```

## Configuration 8020
See dir ipos8020.

### TMLCode.sw
Includes the TML code needed to switch to:
```
EXTREF 0
MODE VES
UPD
```

### DC48V_TRQ_MODE_40A.sw
Basic EasySetup configuration exported as sw file

### DC48V_TRQ_MODE_40A.s.zip
Easy Setup project file to be used if new settings neet to be made. Export of new ".sw" is then needed. 

### DC48V_TRQ_MODE_40A_AND_TML.sw
DC48V_TRQ_MODE.sw and TMLCode.sw concatenated with newline in between
```
DC48V.sw
<newline>
TMLCode.sw
```
NOTE: Make sure only  one newline in the end..

This is the raw configuration for the drive

### DC48V_TRQ_MODE_40A_AND_TML.cmd

DC48ConfigPlusTML.sw converted to ecmc cmd file
```
python3 generateEcmcCmdFromSwSetupFile.py DC48ConfigsPlusTML.sw DC48ConfigsPlusTML.cmd
```
generateEcmcCmdFromSwSetupFile.py can be found in ecmccfg/hardware/Technosoft_slaves/config/CoE/tools

This file can be used to configure the drive over CoE (only needs to be executed once)

1. Edit ecmciPOS8020-Init.cmd to ensure correct versions of ecmc, ecmccfg. Also make sure the master id and slave id is correct.
2. ssh into controller
3. execute : sudo iocsh -7.0.7 ecmciPOS8020-Init.cmd

```
cd drvCfgs
sudo iocsh -7.0.7 ecmciPOS8020-Init.cmd
```
This will load the settings needed and also reset the drive. This is only needed before the first use of the technosoft drive.


## Configuration 4808
See dir ipos4808.

Same procedure as for 8020 but different file names. 

NOTE: Different current scaling of the 4808 vs the 8020


# TODO

 * Make script that uses etehrcat tool to write the settings

