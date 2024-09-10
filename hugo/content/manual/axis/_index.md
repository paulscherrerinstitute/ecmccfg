+++  
title = "axis"   
weight = 10
chapter = false  
+++  

## axis

ECMC has two types of axes, (1) physical axes, aka joints, and (2) virtual axes, aka end effector.
Both types are classes in ECMC, the physical axis is a super-set of the virtual axes, as the latter lacks the hardware.

### [axis yaml config](axisYaml)
Since v7, axes can be configured with yaml-files.
This is a huge improvement over the classic configuration based on EPICS environment variables.
For backward compatibility the classical configuration is still supported.

#### linting and schema check
From v8+ yaml files are linted for syntactic errors, observe the iocsh for warnings and errors.
Additionally the schema of the yaml file is checked by Cerberus.
This check will point out errors in the structure of the configuration as well as certain type errors.

### [axis plc yaml config](axisPLC)
Syncronization configurations

### [Scaling](scaling)
Configuration of scaling

### [Direction](direction)
Defining the direction of motion

### [Homing](homing)
Configuration of homing

