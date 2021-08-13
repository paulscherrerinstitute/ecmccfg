+++  
title = "axis"   
weight = 10
chapter = false  
+++  

## axis

ECMC has two types of axes, (1) physical axes, aka joints, and (2) virtual axes, aka end effector.
Both types are classes in ECMC, the physical axis is a super-set of the virtual axes, as the latter lacks the hardware.

### YAML config
Since v7, axes can be configured with yaml-files.
This is a huge improvement over the classic configuration based on EPICS environment variables.
For backward compatibility the classical configuration is still supported.
