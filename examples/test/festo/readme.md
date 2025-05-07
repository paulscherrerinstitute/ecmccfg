# Download config to drive over foe
ethercat foe_write -m0 --position 10 paramPCK 

# Scalings 
Scalings are set in the CIA part of festo software. Deafult scalings:
*  Position : 1E6
*  Velocity : 1E3

```
drive:
  numerator: 1                                        # Fastest speed in engineering units
  denominator: 1000                                   # I/O range for ECMC_EC_ALIAS_DRV_VELO_SET
...
encoder:
  numerator: 4                                        # Scaling numerator example 360 deg/rev
  denominator: 1000000                                # Scaling denominator example 4096 ticks per 360 degree
```
# new drive
1. Connect with the festo tool
2. Connect directlly to drive with ethernet cable.
3. The festo tool will find teh drive if within subnet (example for this drive 192.168.0.1)
4. Set ip of your computer to similar ip
5. Connect to drive in festo tool inside an open project
6. Press resart
7. Answer yes to download parameters
8. wait for restart, now etehrcat should be visible (ethercat slaves)


NOTE can also set the dip switch S2 to one (teh centre dip switch on top of the drive should be moved twoards the din-rail/wall direction)

# Other

* The sdo subindex in festo tool is in decimal!! 0x1234:13   => 0x1234:0xD .. However in manual its all in hex..
* Sometimes when the drive refuses to enable (stuck in enable state and not going to enabled state). This could be related to that festo softwarev has taken over control of the drive ("Plugin PLC-Control" is activated).
* The Drive will not complain if a addSDO has a wrong size in some situations. Then the setting will just be ignored.  (UINT in festo tool is U16 in ecmc syntax)
* Etehrcat as default can also set the dip switch S2 to one (teh centre dip switch on top of the drive should be moved twoards the din-rail/wall direction)
* Sometimes the drive refuses to start because of reinitialization needed..

# Inputs
```
ec0.s0.binaryInputWd01

```
Linked to epics records:
* bit 16: Ctrl enable input X1A.6
* bit 24: STO02 X1A.3
* bit 25: STO01 X1A.2
* bit 26: BI02 X1A.8
* bit 27: BI01 X1A.7

# Outputs
```
ec0.s0.binaryOutputWd01

```
Not linked to epics-records
* bit 0: brake output
* bit 16: Digital output 01
* bit 17: Digital output 02

# Open loop

## CSV Open loop 
The drive will not update the openloop position if configured in CSV without encoder. Also confirmed by festo (support from festo in progress). However the actual velo updates.

## CSV Open loop with incremental encoder
Works in CSV.

Test with festo motor EMMS-ST:
```
sudo iocsh festo_CSV_OL_EMMS-ST.script
```
Festo cfgs:  WORKS_CSV_OL_OWIS_BISS.fsp

## CSV Open loop with BISS-C OWIS stage (Single turn bits match rotation 12bits)

RLS encoder:
* ST_BITS=12  (4096 per turn==1mm travel)
* MT_BITS=14

Test with Owis stage:
```
sudo iocsh festo_CSV_OL_OWIS_BISS.script 
```
Festo cfgs: WORKS_CSV_OL_OWIS_BISS.fsp

## CSV Open loop with BISS-C OWIS stage (Single turn bits _DON'T_ match rotation 14bits)

RLS encoder:
* ST_BITS=14  (4 times more than obe rev)
* MT_BITS=12

So actually the scaling factor needs to be 4 times as high.
This means that the axis then also need another scaling:

```
drive:
  numerator: 1                                        # Fastest speed in engineering units
  denominator: 1000                                   # I/O range for ECMC_EC_ALIAS_DRV_VELO_SET
...
encoder:
  numerator: 4                                        # Scaling numerator example 360 deg/rev
  denominator: 1000000                                # Scaling denominator example 4096 ticks per 360 degree
```

Test with Owis stage:
```
sudo iocsh festo_CSV_OL_OWIS_BISS_ST_BITS_WRONG.script
```
Festo cfgs: WORKS_CSV_OL_OWIS_BISS.fsp

The velocity monitoring in Festo needs to be disabled to run in this mode:
P14624.0.0
0x2166.25 =  0x2166:0x19 set to 2 (ignore)

#  BISS
* Seems will only work with 6MHz..
* Bit count divided into single turn and multiturn

# RLS LA11 test
* Real scaling of LA11 is 1/4096mm, leadscrew pitch 1mm/rev 
* Bit count = 26
* This means that the drive will see 4096 ticks per rev => ST_BITS=12bits,ST_BITS=14bits, 
* Seems to work!

# Todo test generic scalings
* 256 levels of microsetp=>51200 microsteps/rev for a 200 stepper
* Set single tun count as close as possible = 16bits = 65536

# Closed loop
Get error about "closed loop not permissable" reasomn should be that commutation angle is unknown..

# GUI
```
caqtdm -macro "IOC=c6025a-04,MasterID=1,SlaveID=000" ecmcCMMT-ST.ui 
```
