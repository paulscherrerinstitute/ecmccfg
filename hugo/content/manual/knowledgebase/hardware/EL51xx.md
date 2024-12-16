+++  
title = "EL51xx"   
weight = 20
chapter = false  
+++

## Overview
The EL51xx series covers incremental encoder interfaces:
1. EL5101: 1 ch, diff rs422, ttl, 1MHz
2. EL5101-0010: 1 ch, diff rs422, 5MHz
3. EL5101-0011: 1 ch, diff rs422, 5MHz, oversampling 100kHz
4. EL5112: 2 ch ABC or 1 ch AB, rs422, 5MHz, **PSI standard**
5. EL5131: 1 ch, diff rs422, 5MHz, 2 digital outputs for cam/trigger

### General
Normally, the incremental encoder interfaces do not require any SDO configuration. Therefore, the ecmccomp/applyComponent.cmd, which many times are needed after the ecmccfg/addSlave.cmd, is in most cases not needed. 

### Adding the slave
Make sure you use the correct slave type when adding the slave. Some of the slaves have the same product id but totally different process data which can result in that the slave will not go into OP mode and ecmc will fail to start and a timeout will occur.

For example, the EL5101-**0010** and EL5101-**0011** has the same product id but very different process data.
So, if an EL5101-**0011** is added to the configuration but the actual slave connected is an EL5101-**0010**, the initial product id verification will not catch the miss match. However, later the slave will not go online since the process data is wrong. 

The issue can be diagnosed by checking the dmesg logs:
```bash
# first login to host (ecmc server)
sudo dmesg
```
Configuring the wrong process data will lead to an error message  "* EtherCAT * Invalid input configuration" 

The solution is to use the correct configuration script.

### EL5101-0010
This is commonly used at PSI (even though the EL5112 should be teh standard choice). For configuration, use the EL5101-0010 configuration script:
```
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL5101-0010"
```
### EL5101-0011
This is an oversampling slave, use the EL5101-0011 configuration script with an optional NELM which defines the levels of oversampling:
Example: Add an EL5101-0011, with 100 levels of oversampling:
```
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL5101-0011, NELM=100"
```
In the above example, for each ethercat frame, an array of 100 elements will be transferred. If the ethercat rate is 1kHz, then the incremental data will be sampled at 100kHz (which also is the maximum rate for this terminal).

{{% notice note %}}
NELM cannot be freely defined, depending on the ethercat rate different NELM values will be accepted. Consult the EL5101-0011 manual for more information.
Normally, NELM needs to be an integer value, like 10,20,50, 100. 
{{% /notice %}}

### EL5112
This is the PSI standard incremental encoder interface. The terminal can be used as one channel if index pulse needs to be connected or two channel if only A and B pulse trains are needed.

For 1 channel operation with index pulse, use the EL5112_ABC configuration script and for two channel, the EL5112_AB script:
```
# One channel:
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL5112_ABC"

# Two channel:
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL5112_AB"
```

### EL5131
This terminal support setting cam/trigger outputs at certain counter values (for predefined time, and direction).  

8 predefined threshold counter values can be entered and configured switch outputs on or off. These thresholds can also be accessed/updated during runtime.

Depending how the terminal should be used, the following startup scripts exists:
* EL5131: Normal increment encoder operation
* EL5131_DC: Normal incremental encoder and DC clock (access to timestamps)
* EL5131_DC_TRG: Incremental encoder, access to timestamps, access to configuration of thresholds for outputs for triggering.

```
# EL5131: Normal increment encoder operation:
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL5131"

# EL5131_DC: Normal incremental encoder and DC clock (access to timestamps)
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL5131_DC"

# EL5131_DC_TRG: Incremental encoder, access to timestamps and configuration of thresholds for outputs/triggering.
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=16, HW_DESC=EL5131_DC"
```
