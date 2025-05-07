# TwinSAFE with ecmc

**ecmc has no safety rated features**. 

However, yellow modules can be used with ecmc since the actual safety is implemented in hardware in the twinsafe moduels. ecmc is only used to transfer data between the safety modules. The communication is supervised by the safety modules by crc and watchdog.


The plc file in this dir can be used to establish communication between twinsafe modules (FSoE).

## TwinSAFE project
The twinsafe project itself needs to be downloaded with TwinCAT or TwinSAFE loader

## Restrictions
This plc file is for a simple example transferring just bits. If the safety application requires more data then these PDO:s needs to be added to the hardware cfgs and also to teh plc file.
