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
# ELM slaves
Seems they do not need any DC configuration. They work without. Need to look into..

## ethercat tool commands to view dc info

```
ethercat master
ethercat slaves -v -p<id>
ethercat config -v -p<id>
```

