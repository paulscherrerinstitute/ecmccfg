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

Note: For some reason this will not work (without pv-field):
```
$ caput IOC_TEST:mbboDirect 10
```
however this will work:
```
$ caput IOC_TEST:longout 10
```

Note: The mbbi, mbbo records can only handle values in the range 0..15

## asynMask
All these tests were performed with a mask of 0xFFFFFFF (32bits). Need more tests with different masks to see that it works properly.
