#-d /**
#-d   \brief hardware script for ELM3504. Only for one value per cycle
#-d   \details 4-channel analog input for bridge measurement; 24 bit, 10 ksps
#-d   Supported signal types (choose via SDO settings):
#-d   * strain gauge - internal bridge completion and supply adjustable 0…5 V:
#-d      * quarter bridge           1 kOhm + 350 Ohm + 120 Ohm, +-2/4/8/32 mV/V (2-/3-wire connection)
#-d      * half bridge              +-2/4/8/16 mV/V (3-/5-wire connection)
#-d      * full bridge              +-2/4/8/32 mV/V (4-/6-wire connection)
#-d   * Voltage:    	            +-10 V, +-80 mV (actually +-10.737V / +-85.9mV), (2-wire connection)
#-d   * Potentiometer:	            potentiometer > 1 kOhm, supply integrated and adjustable 0…5 V (3-/5-wire connection)
#-d   * Temperature (RTD):          PT1000 (2-/3-/4-wire connection)
#-d
#-d   Minimum sample time          = 100000 ns (oversampling rate of 10 in 1 kHz ec rate)
#-d   Maximum Oversampling factor  = 100       (if ec rate is 100 Hz then a NELM of 100 can be used)
#-d
#-d   \author Anders Sandström
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM3504_Scalar")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x50218d09")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=${ECMC_SLAVE_RESET=true}"

#-  CH 1
epicsEnvSet("ECMC_CH"             "01")

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,U16,status${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x10,U16,gap${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A01,0x6001,0x01,S32,analogInput${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},analogInput${ECMC_CH},AI${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x1,U32,timestamp${ECMC_CH}_l32)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6005,0x2,U32,timestamp${ECMC_CH}_u32)"

#-  CH 2
epicsEnvSet("ECMC_CH"             "02")

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a30,0x6010,0x1,U16,status${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a30,0x6010,0x10,U16,gap${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A31,0x6011,0x01,S32,analogInput${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},analogInput${ECMC_CH},AI${ECMC_CH})"

#-  CH 3
epicsEnvSet("ECMC_CH"             "03")

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1602,0x7020,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a60,0x6020,0x1,U16,status${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a60,0x6020,0x10,U16,gap${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A61,0x6021,0x01,S32,analogInput${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},analogInput${ECMC_CH},AI${ECMC_CH})"

#-  CH 4
epicsEnvSet("ECMC_CH"             "04")

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1603,0x7030,0x01,16,control${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a90,0x6030,0x1,U16,status${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a90,0x6030,0x10,U16,gap${ECMC_CH},0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A91,0x6031,0x01,S32,analogInput${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryAlias(${ECMC_EC_SLAVE_NUM},analogInput${ECMC_CH},AI${ECMC_CH})"

#- Configure DC clock
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,${ECMC_TEMP_PERIOD_NANO_SECS},${ECMC_SYNC_0_OFFSET_NS=0},${ECMC_SYNC_1_PERIOD_NS=0},${ECMC_SYNC_1_OFFSET_NS=0})"

#- Cleanup
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)
epicsEnvUnset(ECMC_CH)

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "ELM3xx4_Scalar")
