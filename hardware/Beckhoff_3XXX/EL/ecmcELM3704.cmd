#-d /**
#-d   \brief hardware script for EL3704
#-d   \details 4-channel 24bit analog input terminal for many different signal types
#-d
#-d   Minimum sample time          = 100000ns  (oversampling rate of 10 in 1kHz ec rate)
#-d   Maximum Oversampling factor  = 100       (if ec rate is 100Hz then a NELM of 100 can be used)
#-d
#-d   Supported signal types (choose via SDO settings):
#-d   * strain gauge:
#-d      * quarter bridge           (350 Ohm + 120 Ohm, +-2/4/8/32 mV/V), half bridge (+-2/16 mV/V),
#-d      * full bridge              (+-2/4/32 mV/V), internal bridge completion and supply adjustable 0…5 V (2-/3-/4-/5-/6-wire connection)
#-d   * Voltage:    	            +-60/10/5/2.5/1.25 V, +-640/320/160/80/40/20 mV, 0…5/10 V (2-wire connection)
#-d   * Current:	                +-20 mA, 0/4…20 mA, NAMUR NE43 (2-wire connection)
#-d   * IEPE:	                    +-2,5/5/10 V, current feed 2 mA, acquisition of the modulated AC voltage, AC/DC coupling (parameterisable high-pass), (2-wire connection)
#-d   * Potentiometer:	            potentiometer > 1 kOhm, supply integrated and adjustable 0…5 V (3-/5-wire connection)
#-d   * Resistance:	                0…50 Ohm, 0…200 Ohm, 0…500 Ohm, 0…2 kOhm, 0…5 kOhm (2-/3-/4-wire connection)
#-d   * Temperature (RTD):          PT100, PT200, PT500, PT1000, Ni100, Ni120, Ni1000, diverse KT/KTY (types see documentation) (2-/3-/4-wire connection)
#-d   * Temperature (thermocouple):	type A1, A2, A3, B, C, D, E, G, J, K, L, N, P, R, S, T, U; internal cold junction measurement (2-wire connection)
#-d
#-d   NOTE: Some differences between this and ELM3604:
#-d    * The Pdo offset between the channels is 32 (not 33 as ELM3604 so the configs are not the same)
#-d    * Not same Status PDOs
#-d    * Not same Control PDOs
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM3704")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x50219989")
epicsEnvSet("ECMC_OVER_SAMP_MAX"         "100")
epicsEnvSet("ECMC_SAMP_TIME_MIN"         "100000")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=${ECMC_SLAVE_RESET=true}"

#- Check valid oversampling factor (NELM) and ECMC_EC_SAMPLE_RATE. MAX NELM is 100
ecmcFileExist(${ecmccfg_DIR}chkOverSampFactOrDie.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}chkOverSampFactOrDie.cmd, "OVER_SAMP_MAX=${ECMC_OVER_SAMP_MAX}, OVER_SAMP_REQ=${NELM}, EC_SAMP=${ECMC_EC_SAMPLE_RATE},HW_TYPE=${ECMC_EC_HWTYPE}, SLAVE_ID=${ECMC_EC_SLAVE_NUM}"

#- Check valid minimum sampling time for a certain NELM and ECMC_EC_SAMPLE_RATE. Needs to higher than 50000
ecmcFileExist(${ecmccfg_DIR}chkOverSampTimeOrDie.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}chkOverSampTimeOrDie.cmd, "SAMP_TIME_MIN=${ECMC_SAMP_TIME_MIN}, OVER_SAMP_REQ=${NELM}, EC_SAMP=${ECMC_EC_SAMPLE_RATE},HW_TYPE=${ECMC_EC_HWTYPE}, SLAVE_ID=${ECMC_EC_SLAVE_NUM}"

#- ############ Calc memmap size (each element is 4 bytes (32bits))
ecmcEpicsEnvSetCalc("ECMC_EC_ARRAY_BYTE_SIZE",${NELM=1}*4)

#- Different pdo index depending on sampling rate..
#- NELM    PDO index dec
#- 1       0xA01     1
#- 2       0xA02     2
#- 4       0xA03     3
#- 5       0xA04     4
#- 8       0xA05     5
#- 10      0xA06     6
#- 16      0xA07     7
#- 20      0xA08     8
#- 25      0xA09     9
#- 32      0xA0A     10
#- 40      0xA0B     11
#- 50      0xA0C     12
#- 64      0xA0D     13
#- 80      0xA0E     14
#- 100     0xA0F     15
#- Check if valid NELM and set ECMC_PDO_TEMP to correct value according to list
#- Try to simulate switch statement

epicsEnvSet(ECMC_PDO_TEMP,"-1")
epicsEnvSet(ECMC_PDO_NELM_FOUND,"")
ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=1 and ${ECMC_PDO_TEMP}==-1", "1","-1")
ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=2 and ${ECMC_PDO_TEMP}==-1", "2","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=4 and ${ECMC_PDO_TEMP}==-1", "3","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=5 and ${ECMC_PDO_TEMP}==-1", "4","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=8 and ${ECMC_PDO_TEMP}==-1", "5","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=10 and ${ECMC_PDO_TEMP}==-1", "6","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=16 and ${ECMC_PDO_TEMP}==-1", "7","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=20 and ${ECMC_PDO_TEMP}==-1", "8","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=25 and ${ECMC_PDO_TEMP}==-1", "9","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=32 and ${ECMC_PDO_TEMP}==-1", "10","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=40 and ${ECMC_PDO_TEMP}==-1", "11","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=50 and ${ECMC_PDO_TEMP}==-1", "12","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=64 and ${ECMC_PDO_TEMP}==-1", "13","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=80 and ${ECMC_PDO_TEMP}==-1", "14","-1")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM valid => stop look for other valid NELM matches. ","")
${ECMC_PDO_NELM_FOUND}ecmcEpicsEnvSetCalcTernary(ECMC_PDO_TEMP, "${NELM=1}=100 and ${ECMC_PDO_TEMP}==-1", "15","-1")

#- Ensure that ECMC_PDO_TEMP is set
ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM and PDO is valid (${ECMC_PDO_TEMP}).","ecmcExit Error: NELM not valid => PDO not set..")
#- Exit if not valid according to
${ECMC_PDO_NELM_FOUND}

#- Convert to hex
ecmcEpicsEnvSetCalc("ECMC_PDO_CH1",${ECMC_PDO_TEMP},"0x1A%02x")
epicsEnvShow(ECMC_PDO_CH1)

#-  CH 1
epicsEnvSet("ECMC_CH"             "01")

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7001,0x1,F32,tc_coldCH${ECMC_CH})"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,S32,status${ECMC_CH})"
#- Inflate all pdos with a for loop
epicsEnvSet("ECMC_EC_ENTRY"       "0x6001")
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_CH1}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x1,U32,timestamp${ECMC_CH}_l32)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x2,U32,timestamp${ECMC_CH}_u32)"

#-  CH 2
epicsEnvSet("ECMC_CH"             "02")

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1602,0x7010,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1603,0x7011,0x1,F32,tc_cold${ECMC_CH})"

#-  Configuration for sync manager 3
#- Calculate PDO of ch2. ECMC_PDO_TEMP=ECMC_PDO_TEMP+48
#ecmcEpicsEnvSetCalc("ECMC_PDO_CH2",${ECMC_PDO_TEMP}+48,"0x1A%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_CH2","${ECMC_PDO_TEMP}+48*(${ECMC_CH}-1)","0x1A%02x")
epicsEnvShow(ECMC_PDO_CH2)
epicsEnvSet("ECMC_EC_ENTRY"       "0x6011")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a30,0x6010,0x1,S32,status${ECMC_CH})"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_CH2}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"

#-  CH 3
epicsEnvSet("ECMC_CH"             "03")

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7020,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7021,0x1,F32,tc_cold${ECMC_CH})"

#-  Configuration for sync manager 3
#- Calculate PDO of ch3. ECMC_PDO_TEMP=ECMC_PDO_TEMP+96
ecmcEpicsEnvSetCalc("ECMC_PDO_CH3","${ECMC_PDO_TEMP}+48*(${ECMC_CH}-1)","0x1A%02x")
epicsEnvShow(ECMC_PDO_CH3)
epicsEnvSet("ECMC_EC_ENTRY"       "0x6021")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a60,0x6020,0x1,S32,status${ECMC_CH})"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_CH3}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"

#-  CH 4
epicsEnvSet("ECMC_CH"             "04")

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1606,0x7030,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1607,0x7031,0x1,F32,tc_cold${ECMC_CH})"

#-  Configuration for sync manager 3
#- Calculate PDO of ch4. ECMC_PDO_TEMP=ECMC_PDO_TEMP+96
ecmcEpicsEnvSetCalc("ECMC_PDO_CH4","${ECMC_PDO_TEMP}+48*(${ECMC_CH}-1)","0x1A%02x")
epicsEnvShow(ECMC_PDO_CH4)
epicsEnvSet("ECMC_EC_ENTRY"       "0x6031")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a90,0x6030,0x1,S32,status${ECMC_CH})"

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_CH4}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"

#- Configure DC clock
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,${ECMC_TEMP_PERIOD_NANO_SECS},${ECMC_SYNC_0_OFFSET_NS=0},${ECMC_SYNC_1_PERIOD_NS=0},${ECMC_SYNC_1_OFFSET_NS=0})"
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)

#- Cleanup
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_0_CYCLE_NS)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_1_CYCLE_NS)
epicsEnvUnset(ECMC_ENTRY_HEX_VALUE)
epicsEnvUnset(ECMC_PDO_HEX_VALUE)
epicsEnvUnset(ECMC_LOOP_IDX)
epicsEnvUnset(ECMC_PDO_CH1)
epicsEnvUnset(ECMC_PDO_CH2)
epicsEnvUnset(ECMC_PDO_CH3)
epicsEnvUnset(ECMC_PDO_CH4)
epicsEnvUnset(ECMC_OVER_SAMP_MAX)
epicsEnvUnset(ECMC_SAMP_TIME_MIN)
