# DC:s
Note: this document is a work in progress. Just some notes on DC-clocks and how to setup

Basically there are 3 types of ethercat slaves when it comes to use of DC:
1. Slaves without support for DC which do noit need any DC configuration (normally simple I/O)
2. Slaves that require use of DC (some drives, oversampling cards.. )
3. Slaves that can be used both with and without dc:s. (many analog slaves, some drives..)

This doc will try to describe how to setup slaves of types 2 and 3.

Some good reading here https://etherlab-users.etherlab.narkive.com/hh4O3b9Z/dc-sync1-shift-time#post6:

# Type 2: Slave that must havce DC config (EL3702 example) 
For this kind of slave the dc configuration will be applied dierctly by the addSlave.cmd/configureSlave.cmd in the hardware snippet by issuing the "Cfg.EcSlaveConfigDC(....)" command:
```
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(SlaveId,AssignActivate,CycleTimeSync0,ShiftTimeSync0,CycleTimeSync1,ShiftTimeSync1)"
```

Information for setting most of the parameters can be found in the TwinCAT xml definitions for the slave.

1. Open the xml for the slave you are using (example EL3702, open "Beckhoff EL37xx.xml")
2. Search for the slave name in the file ("EL3702")
3. Search for "AssignActivate"
4. A few OpMode nodes for diffrent dc configurations depending on oversampling rate should then appear (example el3702):

```
<OpMode>
		<Name>DcSync</Name>
		<Desc>2 Channels</Desc>
		<AssignActivate>#x0730</AssignActivate>
		<CycleTimeSync0 Factor="-1">0</CycleTimeSync0>
		<ShiftTimeSync0 Input="true">-10000</ShiftTimeSync0>
		<CycleTimeSync1 Factor="-1">0</CycleTimeSync1>
		<ShiftTimeSync1>0</ShiftTimeSync1>
		<Sm No="0">
			<Pdo>#x1b00</Pdo>
			<Pdo OSFac="1">#x1a00</Pdo>
		</Sm>
		<Sm No="1">
			<Pdo>#x1b01</Pdo>
			<Pdo OSFac="1">#x1a80</Pdo>
		</Sm>
		<VendorSpecific>
			<TwinCAT>
				<Oversampling DefaultFactor="10" MinCycleTime="10000"/>
			</TwinCAT>
		</VendorSpecific>
	</OpMode>
	<OpMode>
		<Name>DcSync2</Name>
		<Desc>2 Ch. - 2 times oversampling</Desc>
		<AssignActivate>#x0730</AssignActivate>
		<CycleTimeSync0 Factor="-2">0</CycleTimeSync0>
		<ShiftTimeSync0 Factor="1" Input="true">-10000</ShiftTimeSync0>
		<CycleTimeSync1 Factor="-1">0</CycleTimeSync1>
		<ShiftTimeSync1>0</ShiftTimeSync1>
		<Sm No="0">
			<Pdo>#x1b00</Pdo>
			<Pdo OSFac="2">#x1a00</Pdo>
		</Sm>
		<Sm No="1">
			<Pdo>#x1b01</Pdo>
			<Pdo OSFac="2">#x1a80</Pdo>
		</Sm>
		<VendorSpecific>
			<TwinCAT IgnoreFromBuildNo="1506"/>
		</VendorSpecific>
	</OpMode>
	<OpMode>
		<Name>DcSync3</Name>
		<Desc>2 Ch. - 3 times oversampling</Desc>
		<AssignActivate>#x0730</AssignActivate>
		<CycleTimeSync0 Factor="-3">0</CycleTimeSync0>
		<ShiftTimeSync0 Factor="1" Input="true">-10000</ShiftTimeSync0>
		<CycleTimeSync1 Factor="-1">0</CycleTimeSync1>
		<ShiftTimeSync1>0</ShiftTimeSync1>
		<Sm No="0">
			<Pdo>#x1b00</Pdo>
			<Pdo OSFac="3">#x1a00</Pdo>
		</Sm>
		<Sm No="1">
			<Pdo>#x1b01</Pdo>
			<Pdo OSFac="3">#x1a80</Pdo>
		</Sm>
		<VendorSpecific>
			<TwinCAT IgnoreFromBuildNo="1506"/>
		</VendorSpecific>
	</OpMode>
    <OpMode>
    	<Name>DcSync4</Name>
		<Desc>2 Ch. - 4 times oversampling</Desc>
		<AssignActivate>#x0730</AssignActivate>
		<CycleTimeSync0 Factor="-4">0</CycleTimeSync0>
		<ShiftTimeSync0 Factor="1" Input="true">-10000</ShiftTimeSync0>
		<CycleTimeSync1 Factor="-1">0</CycleTimeSync1>
		<ShiftTimeSync1>0</ShiftTimeSync1>
		<Sm No="0">
			<Pdo>#x1b00</Pdo>
			<Pdo OSFac="4">#x1a00</Pdo>
		</Sm>
		<Sm No="1">
			<Pdo>#x1b01</Pdo>
			<Pdo OSFac="4">#x1a80</Pdo>
		</Sm>
		<VendorSpecific>
			<TwinCAT IgnoreFromBuildNo="1506"/>
		</VendorSpecific>
	</OpMode>
    ....
    ...

```
For this slave the CycleTimeSync0 depends on the oversampling factor and the ethercat sampling time.

From this xml node the following can be concluded (for this example, EL3702 and oversamplng 4 times):
1. ASSIGN_ACTIVATE = 0x730
2. SYNC_0_CYCLE    = 250000 ethercat cylce time in ns (4 samples per cycle in 1kHz)
3. SYNC_0_SHIFT    = -10000 but have 0 in the ecmcEL3702.cmd configuration and it works well
4. SYNC_1_CYCLE    = 750000 (ethercat_cycle_time-time_for_1_sample)

Example call of applySlaveDCconfig.cmd:
```
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(12,0x730,250000,-10000,750000,0)"

```

# Type 3:Slave that can be used with and without (EL3174 example)
For this type of slave the optional dc settings can be applied with the ecmc/ecmccfg comand applySlaveDCconfig.cmd:
The ecmccfg command "applySlaveDCconfig.cmd" wraps the ecmc command "Cfg.EcSlaveConfigDC(..)". It can be called with the following params:

```
#-d /**
#-d   \brief Script for applying dc config to slave
#-d   \author Anders Sandstroem
#-d   \file
#-d   \param SLAVE_ID Slave Id
#-d   \param ASSIGN_ACTIVATE DC setting. Assign Activate Word from TC xml
#-d   \param SYNC_0_CYCLE (optional) Sync 0 sample time [ns]. Defaults to ethercat cycle time in nanoseconds
#-d   \param SYNC_0_SHIFT (optional) Sync 0 shift time [ns]. Defaults to 0ns
#-d   \param SYNC_1_CYCLE (optional) Sync 1 sample time [ns]. Defaults to 0ns
#-d   \pre A slave must have been added/configured (addSlave.cmd or configureSlave.cmd) immediately before the call of this script (or ECMC_EC_SLAVE_NUM set to correct slave number).
#-d */

```

Note 1: A slave must have been added/configured (addSlave.cmd or configureSlave.cmd) immediately before the call of this script (or ECMC_EC_SLAVE_NUM set to correct slave number).

Note 2: According to etherlab source and forums the parameter "SYNC_1_SHIFT" should never be used and is therefore not added to applySlaveDCconfig.cmd (but is accessible in "Cfg.EcSlaveConfigDC()").

Information for setting most of the parameters can be found in the TwinCAT xml definitions for the slave.

1. Open the xml for the slave you are using (example EL3174, open "Beckhoff EL31xx.xml")
2. Search for the slave name in the file ("EL3174")
3. Search for "AssignActivate"
4. A few OpMode nodes for diffrent dc configuration should then appear (example el3174):

```
<OpMode>
	<Name>DCIN</Name>
	<Desc>DC-Synchron (input based)</Desc>
	<AssignActivate>#x700</AssignActivate>
	<CycleTimeSync0 Factor="1">0</CycleTimeSync0>
	<ShiftTimeSync0 Input="1">-100000</ShiftTimeSync0>
	<CycleTimeSync1 Factor="1">0</CycleTimeSync1>
	<ShiftTimeSync1>25000</ShiftTimeSync1>
</OpMode>

```
From https://etherlab-users.etherlab.narkive.com/hh4O3b9Z/dc-sync1-shift-time#post6:
The ShiftTimeSync1 setting actually modifies the SYNC1 cycle time (which is a parameter of ecrt_slave_config_dc) based on your actual cycle time similarly you need to fill in the real cycle time values for those that have Factor=1 in the XML.

From this xml node the following can be concluded (for this example, EL3174):
1. ASSIGN_ACTIVATE = 0x700
2. SYNC_0_CYCLE    = 1000000 ethercat cylce time in ns (1000000 for 1kHz)
3. SYNC_0_SHIFT    = -100000
4. SYNC_1_CYCLE    = 25000 (When CycleTimeSync1 factor is 1 then ShiftTimeSync1 should be assigned to SYNC_1_CYCLE)

Example call of applySlaveDCconfig.cmd:
```
iocshLoad /home/pi/epics/base-7.0.5/require/3.4.0/siteMods/ecmccfg/develop/applySlaveDCconfig.cmd, "ASSIGN_ACTIVATE=0x700,SYNC_0_SHIFT=-100000,SYNC_1_CYCLE=25000"
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "'0x700'==''", "ecmcExit : Error: ASSIGN_ACTIVATE not defined","#- ")
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/1000*1E6)
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(12,0x700,1000000,-100000,25000,0)"

```

# dc.script test application for 2 EL3702
The dc.script starup file contains configuration for two el3702 slaves. After each addSlave.cmd the follwoing commad is added allowing for changing params:
```
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(11,0x730,1000000,-500000,0,0)"
```

## Test with shift of sync_0_shift

By connecting a signal generator with  low freq signal (9Hz) to AI1 of both these slaves it is possible to see how the sync_0_shift parameter affects the data.

### Log latch time

Test bo sync_0_shift to 50000 for the first EL3702.

EL3702 1:
```
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM_3702_1},0x730,1000000,50000,0,0)"
```

EL3702 2:
```
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM_3702_2},0x730,1000000,0,0,0)"
```

Log latch time to file:
```
camonitor -g10 IOC_TEST:ec0-s11-EL3702-NextTime IOC_TEST:ec0-s12-EL3702-NextTime | tee time.log
IOC_TEST:ec0-s11-EL3702-NextTime 2021-07-07 08:35:47.205566 1589427095  
IOC_TEST:ec0-s12-EL3702-NextTime 2021-07-07 08:35:47.205566 1589377095  
IOC_TEST:ec0-s11-EL3702-NextTime 2021-07-07 08:35:47.206604 1590427095  
IOC_TEST:ec0-s12-EL3702-NextTime 2021-07-07 08:35:47.206604 1590377095  
IOC_TEST:ec0-s11-EL3702-NextTime 2021-07-07 08:35:47.207747 1591427095  
IOC_TEST:ec0-s12-EL3702-NextTime 2021-07-07 08:35:47.207747 1591377095  
IOC_TEST:ec0-s11-EL3702-NextTime 2021-07-07 08:35:47.208643 1592427095  
IOC_TEST:ec0-s12-EL3702-NextTime 2021-07-07 08:35:47.208643 1592377095  
IOC_TEST:ec0-s11-EL3702-NextTime 2021-07-07 08:35:47.209593 1593427095  
IOC_TEST:ec0-s12-EL3702-NextTime 2021-07-07 08:35:47.209593 1593377095  
IOC_TEST:ec0-s11-EL3702-NextTime 2021-07-07 08:35:47.210588 1594427095  
IOC_TEST:ec0-s12-EL3702-NextTime 2021-07-07 08:35:47.210588 1594377095  
IOC_TEST:ec0-s11-EL3702-NextTime 2021-07-07 08:35:47.211582 1595427095  
IOC_TEST:ec0-s12-EL3702-NextTime 2021-07-07 08:35:47.211582 1595377095  

```

Here it can be concluded that the latching of the first EL3702 slave is 50000ns later than the second EL3702 slave.
```
IOC_TEST:ec0-s11-EL3702-NextTime 2021-07-07 08:35:47.211582 1595427095  
IOC_TEST:ec0-s12-EL3702-NextTime 2021-07-07 08:35:47.211582 1595377095  
```

### Log data
Logging data basically shows that keeping the same sync_1_shift results in best performance without phaseshifts (atleast for EL3702 terminals). 
When having to big differnce it seems that sometimes the values will be from previous cycle and not stable.
```
Log values to file with: 
  camonitor IOC_TEST:ec0-s11-EL3702-AI1-Array  IOC_TEST:ec0-s12-EL3702-AI1-Array| tee data.log
plot data with:
  cat data.log | python ~/sources/ecmccomgui/pyDataManip/plotCaMonitor.py &
```
## plc test

```
println('=========================================');
static.time:=ec_get_time_l32()/1000;
static.el3702_1:=ec0.s${S1}.nextSyncTime/1000;
static.el3702_2:=ec0.s${S2}.nextSyncTime/1000;
println('Current time       : ', static.time/1000);
println('EL3702 1 time      : ', static.el3702_1);
println('EL3702 2 time      : ', static.el3702_2);
println('Diff EL3702 1      : ', static.el3702_1-static.time);
println('Diff EL3702 2      : ', static.el3702_2-static.time);
println('Diff EL3702 1 vs 2 : ', static.el3702_2-static.el3702_1);

```
Printouts from plc code of 32 bit time registers [micro seconds]:
```
=========================================
Current time       : 4072.28575
EL3702 1 time      : 4072197.66700
EL3702 2 time      : 4072147.66700
Diff EL3702 1      :  -88.08700
Diff EL3702 2      : -138.08700
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       :  777.25527
EL3702 1 time      : 777230.37100
EL3702 2 time      : 777180.37100
Diff EL3702 1      :  -24.90200
Diff EL3702 2      :  -74.90200
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 1777.25811
EL3702 1 time      : 1777230.37100
EL3702 2 time      : 1777180.37100
Diff EL3702 1      :  -27.73500
Diff EL3702 2      :  -77.73500
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 2777.31342
EL3702 1 time      : 2777230.37100
EL3702 2 time      : 2777180.37100
Diff EL3702 1      :  -83.04800
Diff EL3702 2      : -133.04800
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 3777.31429
EL3702 1 time      : 3777230.37100
EL3702 2 time      : 3777180.37100
Diff EL3702 1      :  -83.91700
Diff EL3702 2      : -133.91700
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       :  482.40323
EL3702 1 time      : 482263.07500
EL3702 2 time      : 482213.07500
Diff EL3702 1      : -140.15600
Diff EL3702 2      : -190.15600
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 1482.35325
EL3702 1 time      : 1482263.07500
EL3702 2 time      : 1482213.07500
Diff EL3702 1      :  -90.17400
Diff EL3702 2      : -140.17400
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 2482.34880
EL3702 1 time      : 2482263.07500
EL3702 2 time      : 2482213.07500
Diff EL3702 1      :  -85.72900
Diff EL3702 2      : -135.72900
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 3482.34478
EL3702 1 time      : 3482263.07500
EL3702 2 time      : 3482213.07500
Diff EL3702 1      :  -81.70900
Diff EL3702 2      : -131.70900
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       :  187.32321
EL3702 1 time      : 187295.77900
EL3702 2 time      : 187245.77900
Diff EL3702 1      :  -27.43100
Diff EL3702 2      :  -77.43100
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 1187.37704
EL3702 1 time      : 1187295.77900
EL3702 2 time      : 1187245.77900
Diff EL3702 1      :  -81.26200
Diff EL3702 2      : -131.26200
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 2187.32784
EL3702 1 time      : 2187295.77900
EL3702 2 time      : 2187245.77900
Diff EL3702 1      :  -32.05700
Diff EL3702 2      :  -82.05700
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 3187.35115
EL3702 1 time      : 3187295.77900
EL3702 2 time      : 3187245.77900
Diff EL3702 1      :  -55.37000
Diff EL3702 2      : -105.37000
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 4187.38235
EL3702 1 time      : 4187295.77900
EL3702 2 time      : 4187245.77900
Diff EL3702 1      :  -86.57200
Diff EL3702 2      : -136.57200
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       :  892.41846
EL3702 1 time      : 892328.48300
EL3702 2 time      : 892278.48300
Diff EL3702 1      :  -89.97800
Diff EL3702 2      : -139.97800
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 1892.38726
EL3702 1 time      : 1892328.48300
EL3702 2 time      : 1892278.48300
Diff EL3702 1      :  -58.77300
Diff EL3702 2      : -108.77300
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 2892.35770
EL3702 1 time      : 2892328.48300
EL3702 2 time      : 2892278.48300
Diff EL3702 1      :  -29.21600
Diff EL3702 2      :  -79.21600
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 3892.41840
EL3702 1 time      : 3892328.48300
EL3702 2 time      : 3892278.48300
Diff EL3702 1      :  -89.91600
Diff EL3702 2      : -139.91600
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       :  597.44975
EL3702 1 time      : 597361.18700
EL3702 2 time      : 597311.18700
Diff EL3702 1      :  -88.56300
Diff EL3702 2      : -138.56300
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 1597.44930
EL3702 1 time      : 1597361.18700
EL3702 2 time      : 1597311.18700
Diff EL3702 1      :  -88.11600
Diff EL3702 2      : -138.11600
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 2597.44923
EL3702 1 time      : 2597361.18700
EL3702 2 time      : 2597311.18700
Diff EL3702 1      :  -88.04000
Diff EL3702 2      : -138.04000
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 3597.42078
EL3702 1 time      : 3597361.18700
EL3702 2 time      : 3597311.18700
Diff EL3702 1      :  -59.59400
Diff EL3702 2      : -109.59400
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       :  302.53078
EL3702 1 time      : 302393.89100
EL3702 2 time      : 302343.89100
Diff EL3702 1      : -136.88700
Diff EL3702 2      : -186.88700
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 1302.60009
EL3702 1 time      : 1302393.89100
EL3702 2 time      : 1302343.89100
Diff EL3702 1      : -206.19800
Diff EL3702 2      : -256.19800
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 2302.56975
EL3702 1 time      : 2302393.89100
EL3702 2 time      : 2302343.89100
Diff EL3702 1      : -175.86300
Diff EL3702 2      : -225.86300
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 3302.53403
EL3702 1 time      : 3302393.89100
EL3702 2 time      : 3302343.89100
Diff EL3702 1      : -140.13900
Diff EL3702 2      : -190.13900
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       :    7.53582
EL3702 1 time      : 7426.59500
EL3702 2 time      : 7376.59500
Diff EL3702 1      : -109.22900
Diff EL3702 2      : -159.22900
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 1007.50556
EL3702 1 time      : 1007426.59500
EL3702 2 time      : 1007376.59500
Diff EL3702 1      :  -78.96800
Diff EL3702 2      : -128.96800
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 2007.57382
EL3702 1 time      : 2007426.59500
EL3702 2 time      : 2007376.59500
Diff EL3702 1      : -147.22300
Diff EL3702 2      : -197.22300
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 3007.61361
EL3702 1 time      : 3007426.59500
EL3702 2 time      : 3007376.59500
Diff EL3702 1      : -187.01600
Diff EL3702 2      : -237.01600
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 4007.56013
EL3702 1 time      : 4007426.59500
EL3702 2 time      : 4007376.59500
Diff EL3702 1      : -133.53300
Diff EL3702 2      : -183.53300
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       :  712.54613
EL3702 1 time      : 712459.29900
EL3702 2 time      : 712409.29900
Diff EL3702 1      :  -86.82700
Diff EL3702 2      : -136.82700
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 1712.56375
EL3702 1 time      : 1712459.29900
EL3702 2 time      : 1712409.29900
Diff EL3702 1      : -104.45300
Diff EL3702 2      : -154.45300
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 2712.66671
EL3702 1 time      : 2712459.29900
EL3702 2 time      : 2712409.29900
Diff EL3702 1      : -207.41100
Diff EL3702 2      : -257.41100
Diff EL3702 1 vs 2 :  -50.00000
=========================================
Current time       : 3712.60573
EL3702 1 time      : 3712459.29900
EL3702 2 time      : 3712409.29900
Diff EL3702 1      : -146.42800
Diff EL3702 2      : -196.42800
Diff EL3702 1 vs 2 :  -50.00000
```

Conclusions:
1. Diff between the two el3702 next latch times are always 50micor seconds (like set in cfg).
2. The next "nextSyncTime" always occur in the past. So it has already been processed in the slave when the data from previous scan arrives in ecmc
3. A bit strange that the "Diff EL3702 1" and "Diff EL3702 2" have such big spread.. 150..200 microseconds related to ec system time. 

NOTE: Teste where performed on not rt patched raspbi 4b (high latency). This could be the explenation for bullt 3 above.

# ELM slaves
Seems they do not need any DC configuration. They work without. Need to look into..

## ethercat tool commands to view dc info

```
ethercat master
ethercat slaves -v -p<id>
ethercat config -v -p<id>
```

