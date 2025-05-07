#-d /**
#-d   \brief hardware script for EL3148
#-d   \details 8-channel analog input, multi-function, ±10…±1.25 V, ±20 mA, 24 bit, 1 ksps
#-d
#-d   Minimum sample time          = 1000000 ns (oversampling rate of 1 in 1 kHz ec rate)
#-d   Maximum Oversampling factor  = 20         (if ec rate is 50 Hz then a NELM of 20 can be used)
#-d
#-d   \authors Anders Sandstroem, Alvin Acerbo
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM3148")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x502176c9")
epicsEnvSet("ECMC_OVER_SAMP_MAX"         "20")
epicsEnvSet("ECMC_SAMP_TIME_MIN"         "1000000")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=${ECMC_SLAVE_RESET=true}"

#- Check valid oversampling factor (NELM) and ECMC_EC_SAMPLE_RATE. MAX NELM is 20
ecmcFileExist(${ecmccfg_DIR}chkOverSampFactOrDie.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}chkOverSampFactOrDie.cmd, "OVER_SAMP_MAX=${ECMC_OVER_SAMP_MAX}, OVER_SAMP_REQ=${NELM}, EC_SAMP=${ECMC_EC_SAMPLE_RATE},HW_TYPE=${ECMC_EC_HWTYPE}, SLAVE_ID=${ECMC_EC_SLAVE_NUM}"

#- Check valid minimum sampling time for a certain NELM and ECMC_EC_SAMPLE_RATE. Needs to higher than 1000000
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

#- Ensure that ECMC_PDO_TEMP is set
ecmcEpicsEnvSetCalcTernary(ECMC_PDO_NELM_FOUND, "${ECMC_PDO_TEMP}!=-1", "# NELM and PDO is valid (${ECMC_PDO_TEMP}).","ecmcExit Error: NELM not valid => PDO not set..")
#- Exit if not valid according to
${ECMC_PDO_NELM_FOUND}

epicsEnvSet("PDO_offset", 11)

#-  CH 1
epicsEnvSet("CH_index", 0)
ecmcEpicsEnvSetCalc("ECMC_CH",${CH_index}+1,"%02d")
#- Calculate PDO: ECMC_PDO_TEMP=(CH_index*PDO_offset)+ECMC_PDO_TEMP
ecmcEpicsEnvSetCalc("ECMC_PDO_Ctrl",${CH_index}),"0x16%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Data",${CH_index}*${PDO_offset}+${ECMC_PDO_TEMP},"0x1A%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Stat",${CH_index}*${PDO_offset},"0x1A%02x")
epicsEnvShow(ECMC_PDO_Ctrl)
epicsEnvShow(ECMC_PDO_Stat)
epicsEnvShow(ECMC_PDO_Data)

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,${ECMC_PDO_Ctrl},0x70${CH_index}0,0x01,16,control${ECMC_CH})"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_PDO_Stat},0x60${CH_index}0,0x1,S32,status${ECMC_CH})"
epicsEnvSet("ECMC_EC_ENTRY"       "0x60${CH_index}1")

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_Data}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"

#- time stamp
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a09,0x6005,0x1,U32,timestamp${ECMC_CH}_l32)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a09,0x6005,0x2,U32,timestamp${ECMC_CH}_u32)"

#-  CH 2
epicsEnvSet("CH_index", 1)
ecmcEpicsEnvSetCalc("ECMC_CH",${CH_index}+1,"%02d")
#- Calculate PDO: ECMC_PDO_TEMP=(CH_index*PDO_offset)+ECMC_PDO_TEMP
ecmcEpicsEnvSetCalc("ECMC_PDO_Ctrl",${CH_index}),"0x16%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Data",${CH_index}*${PDO_offset}+${ECMC_PDO_TEMP},"0x1A%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Stat",${CH_index}*${PDO_offset},"0x1A%02x")
epicsEnvShow(ECMC_PDO_Ctrl)
epicsEnvShow(ECMC_PDO_Stat)
epicsEnvShow(ECMC_PDO_Data)

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,${ECMC_PDO_Ctrl},0x70${CH_index}0,0x01,16,control${ECMC_CH})"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_PDO_Stat},0x60${CH_index}0,0x1,S32,status${ECMC_CH})"
epicsEnvSet("ECMC_EC_ENTRY"       "0x60${CH_index}1")

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_Data}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"

#-  CH 3
epicsEnvSet("CH_index", 2)
ecmcEpicsEnvSetCalc("ECMC_CH",${CH_index}+1,"%02d")
#- Calculate PDO: ECMC_PDO_TEMP=(CH_index*PDO_offset)+ECMC_PDO_TEMP
ecmcEpicsEnvSetCalc("ECMC_PDO_Ctrl",${CH_index}),"0x16%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Data",${CH_index}*${PDO_offset}+${ECMC_PDO_TEMP},"0x1A%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Stat",${CH_index}*${PDO_offset},"0x1A%02x")
epicsEnvShow(ECMC_PDO_Ctrl)
epicsEnvShow(ECMC_PDO_Stat)
epicsEnvShow(ECMC_PDO_Data)

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,${ECMC_PDO_Ctrl},0x70${CH_index}0,0x01,16,control${ECMC_CH})"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_PDO_Stat},0x60${CH_index}0,0x1,S32,status${ECMC_CH})"
epicsEnvSet("ECMC_EC_ENTRY"       "0x60${CH_index}1")

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_Data}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"

#-  CH 4
epicsEnvSet("CH_index", 3)
ecmcEpicsEnvSetCalc("ECMC_CH",${CH_index}+1,"%02d")
#- Calculate PDO: ECMC_PDO_TEMP=(CH_index*PDO_offset)+ECMC_PDO_TEMP
ecmcEpicsEnvSetCalc("ECMC_PDO_Ctrl",${CH_index}),"0x16%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Data",${CH_index}*${PDO_offset}+${ECMC_PDO_TEMP},"0x1A%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Stat",${CH_index}*${PDO_offset},"0x1A%02x")
epicsEnvShow(ECMC_PDO_Ctrl)
epicsEnvShow(ECMC_PDO_Stat)
epicsEnvShow(ECMC_PDO_Data)

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,${ECMC_PDO_Ctrl},0x70${CH_index}0,0x01,16,control${ECMC_CH})"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_PDO_Stat},0x60${CH_index}0,0x1,S32,status${ECMC_CH})"
epicsEnvSet("ECMC_EC_ENTRY"       "0x60${CH_index}1")

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_Data}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"

#-  CH 5
epicsEnvSet("CH_index", 4)
ecmcEpicsEnvSetCalc("ECMC_CH",${CH_index}+1,"%02d")
#- Calculate PDO: ECMC_PDO_TEMP=(CH_index*PDO_offset)+ECMC_PDO_TEMP
ecmcEpicsEnvSetCalc("ECMC_PDO_Ctrl",${CH_index}),"0x16%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Data",${CH_index}*${PDO_offset}+${ECMC_PDO_TEMP},"0x1A%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Stat",${CH_index}*${PDO_offset},"0x1A%02x")
epicsEnvShow(ECMC_PDO_Ctrl)
epicsEnvShow(ECMC_PDO_Stat)
epicsEnvShow(ECMC_PDO_Data)

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,${ECMC_PDO_Ctrl},0x70${CH_index}0,0x01,16,control${ECMC_CH})"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_PDO_Stat},0x60${CH_index}0,0x1,S32,status${ECMC_CH})"
epicsEnvSet("ECMC_EC_ENTRY"       "0x60${CH_index}1")

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_Data}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"

#-  CH 6
epicsEnvSet("CH_index", 5)
ecmcEpicsEnvSetCalc("ECMC_CH",${CH_index}+1,"%02d")
#- Calculate PDO: ECMC_PDO_TEMP=(CH_index*PDO_offset)+ECMC_PDO_TEMP
ecmcEpicsEnvSetCalc("ECMC_PDO_Ctrl",${CH_index}),"0x16%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Data",${CH_index}*${PDO_offset}+${ECMC_PDO_TEMP},"0x1A%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Stat",${CH_index}*${PDO_offset},"0x1A%02x")
epicsEnvShow(ECMC_PDO_Ctrl)
epicsEnvShow(ECMC_PDO_Stat)
epicsEnvShow(ECMC_PDO_Data)

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,${ECMC_PDO_Ctrl},0x70${CH_index}0,0x01,16,control${ECMC_CH})"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_PDO_Stat},0x60${CH_index}0,0x1,S32,status${ECMC_CH})"
epicsEnvSet("ECMC_EC_ENTRY"       "0x60${CH_index}1")

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_Data}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"

#-  CH 7
epicsEnvSet("CH_index", 6)
ecmcEpicsEnvSetCalc("ECMC_CH",${CH_index}+1,"%02d")
#- Calculate PDO: ECMC_PDO_TEMP=(CH_index*PDO_offset)+ECMC_PDO_TEMP
ecmcEpicsEnvSetCalc("ECMC_PDO_Ctrl",${CH_index}),"0x16%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Data",${CH_index}*${PDO_offset}+${ECMC_PDO_TEMP},"0x1A%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Stat",${CH_index}*${PDO_offset},"0x1A%02x")
epicsEnvShow(ECMC_PDO_Ctrl)
epicsEnvShow(ECMC_PDO_Stat)
epicsEnvShow(ECMC_PDO_Data)

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,${ECMC_PDO_Ctrl},0x70${CH_index}0,0x01,16,control${ECMC_CH})"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_PDO_Stat},0x60${CH_index}0,0x1,S32,status${ECMC_CH})"
epicsEnvSet("ECMC_EC_ENTRY"       "0x60${CH_index}1")

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_Data}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"

#-  CH 8
epicsEnvSet("CH_index", 7)
ecmcEpicsEnvSetCalc("ECMC_CH",${CH_index}+1,"%02d")
#- Calculate PDO: ECMC_PDO_TEMP=(CH_index*PDO_offset)+ECMC_PDO_TEMP
ecmcEpicsEnvSetCalc("ECMC_PDO_Ctrl",${CH_index}),"0x16%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Data",${CH_index}*${PDO_offset}+${ECMC_PDO_TEMP},"0x1A%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_Stat",${CH_index}*${PDO_offset},"0x1A%02x")
epicsEnvShow(ECMC_PDO_Ctrl)
epicsEnvShow(ECMC_PDO_Stat)
epicsEnvShow(ECMC_PDO_Data)

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,${ECMC_PDO_Ctrl},0x70${CH_index}0,0x01,16,control${ECMC_CH})"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,${ECMC_PDO_Stat},0x60${CH_index}0,0x1,S32,status${ECMC_CH})"
epicsEnvSet("ECMC_EC_ENTRY"       "0x60${CH_index}1")

#- Inflate all pdos with a for loop
ecmcFileExist(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcELM360X_loopStep.cmd,"CH_ID=${ECMC_CH}, PDO=${ECMC_PDO_Data}, ENTRY=${ECMC_EC_ENTRY}",ECMC_LOOP_IDX,1,${NELM=1},1)
ecmcConfigOrDie "Cfg.EcAddMemMapDT(ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.analogInputArray${ECMC_CH}_1,$(ECMC_EC_ARRAY_BYTE_SIZE),2,S32,ec$(ECMC_EC_MASTER_ID).s${ECMC_EC_SLAVE_NUM}.mm.analogInputArray${ECMC_CH})"


#- Cleanup
epicsEnvUnset(ECMC_EC_ARRAY_BYTE_SIZE)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_0_CYCLE_NS)
epicsEnvUnset(ECMC_EC_SLAVE_SYNC_1_CYCLE_NS)
epicsEnvUnset(ECMC_ENTRY_HEX_VALUE)
epicsEnvUnset(ECMC_PDO_HEX_VALUE)
epicsEnvUnset(ECMC_LOOP_IDX)
epicsEnvUnset(ECMC_PDO_Data)
epicsEnvUnset(ECMC_PDO_Ctrl)
epicsEnvUnset(ECMC_PDO_Stat)
epicsEnvUnset(ECMC_OVER_SAMP_MAX)
epicsEnvUnset(ECMC_SAMP_TIME_MIN)

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "ELM3xx8")
