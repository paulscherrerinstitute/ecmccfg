# Test scripts for EL7041


## EL7041-0052
The two inputs on the terminal is accessible in the drive status word:
* Input 1 bit 11
* Input 2 bit 12

The status word is exposed in the "Drv01-Stat" PV of the drive and the "driveStatus01" asyn param:

Examples:
```
IOC_TEST:m0s010-Drv01-Stat     2023-02-09 09:03:53.342976 100001000101  
ec0.s10.driveStatus01
```
