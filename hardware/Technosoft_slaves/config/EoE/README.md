# EoE support
Note: This is WIP to try to configure Technosoft slaves over EoE (Ethernet over EtherCAT) instaed of RS232.

## Etherlab master

Etherlab needs the "unofficial" patchset in order for the EoE to work properly:
See icshwi/etherlabmaster/README.md for instructions:
1. cleanup:
```
$ make clean
```
2. remove dir (if it exists):
```
$ rm -rf /opt/etherlab
```
3. Set WITH_PATCHSET=YES:
```
$ echo "WITH_PATCHSET=YES" >> configure/CONFIG_OPTIONS.local
```
4.  make patchset (instead of make init):
```
$ make patchset
```
5. then same workflow as normal (without patchset):
```
$ make centos7_patch  #If needed
$ make build
$ make install
......
```

## ECMC
* ecmc needs to be recompiled and installed after the patched etherlab master have been installed
