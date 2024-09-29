+++  
title = "build at PSI"   
weight = 1
chapter = false  
+++  

{{% notice warning %}}
These instructions only work at PSI!
{{% /notice %}}

## Build at PSI, using driver.makefile
by default this module is only build for Debian 10 and Epics >=R7.0.6

### build on login cluster
```bash
make [LIBVERSION] [clean] [uninstall] install
```

### check a particular version
check the module loads for version `dev`, Epics `R7+` and ECMC version `dev`, note `MASTER_ID=-1` which runs ECMC in master-less mode.
Make proper adjustments to match your needs in terms of versions.
```bash
iocsh -7 -r "ecmccfg,dev 'ECMC_VER=dev,MASTER_ID=-1'"
```
