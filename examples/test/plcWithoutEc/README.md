# Example of running IOC without ethercat hardware.

Ioc:s can be executed without configured EtherCAT hardware. The example in this directory shows how to start en ecmc PLC without configured hardware.
Since the realtime loop is started, ecmc PLC:s can be used to generate data or trigger records in EPICS.

## Configuration
Assigning the ethercat MASTER_ID to a value less than 0 will result in that the ethercat master will not be claimed. 
Since "require" differs slightly between ESS and PSI the syntax is slightly different:

```
# ESS syntax
$(ECMCCFG_INIT)$(SCRIPTEXEC) ${ecmccfg_DIR}startup.cmd, "IOC=$(IOC),ECMC_VER=6.2.4,stream_VER=2.8.10, MASTER_ID=-1"

# PSI syntax
require ecmccfg 6.2.4 MASTER_ID=-1

```
