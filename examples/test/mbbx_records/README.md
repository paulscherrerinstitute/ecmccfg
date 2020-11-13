# Test of asynUint32Digital interface

Test of the following records with asynUint32Digital interface:
* mbbi
* mbbo
* mbbiDirect
* mbboDirect
* longin
* longout

## Some camonitor commands

```
$ camonitor IOC_TEST:mbbiDirect IOC_TEST:longin IOC_TEST:mbbi
$ caput IOC_TEST:mbboDirect.B1 0
$ caput IOC_TEST:mbbo 7
$ caput IOC_TEST:longout 10
```

For some reason this will not work (without pv-field):
```
$ caput IOC_TEST:mbboDirect 0
```
Probbaly have something todo with the asyn mask. The better to use:
```
$ caput IOC_TEST:longout 10
```

## asynMask
Need more tests..
