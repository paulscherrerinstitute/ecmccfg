#-d /**
#-d   \brief hardware script for EL6624-Sensor-chX_input
#-d   \details Parametrization of chX of EL6624 as a generic input
#-d   \author Anders Sandstroem
#-d   \file
#-d    \pre Environment variables needed:
#-d    \pre ECMC_EC_CH_ID       01..04
#-d    \pre ECMC_EC_SLAVE_NUM   Slave number
#-d    \pre ECMC_EC_VENDOR_ID   EtherCAT vendor ID of EL6224
#-d    \pre ECMC_EC_PRODUCT_ID  EtherCAT product ID of EL6224
#-d */

#- Convert to PDO id
ecmcEpicsEnvSetCalc("ECMC_EC_PDO_ID", "${ECMC_EC_CH_ID=01}-1", "%d")

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A0${ECMC_EC_PDO_ID},0x60${ECMC_EC_PDO_ID}0,0x01,U16,binaryInput${ECMC_EC_CH_ID})"

#- Device ID 0
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x4")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "4")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Vendor ID 0
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x5")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "4")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:20, rwrwrw, uint8, 8 bit, "IO-Link Revision"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x20")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:21, rwrwrw, uint8, 8 bit, "Frame capability"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x21")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:22, rwrwrw, uint8, 8 bit, "Min cycle time"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x22")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:23, rwrwrw, uint8, 8 bit, "Offset time"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x23")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:24, rwrwrw, uint8, 8 bit, "Process data in length"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x24")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:25, rwrwrw, uint8, 8 bit, "Process data out length"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x25")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:26, rwrwrw, uint16, 16 bit, "Compatible ID"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x26")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:28, rwrwrw, uint16, 16 bit, "Master Control"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x28")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

dbLoadTemplate(ecmc_binaryInput-chX.template,"P=${ECMC_PREFIX},ECMC_P=${ECMC_P},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,MASTER_ID=${ECMC_EC_MASTER_ID},SLAVE_POS=${ECMC_EC_SLAVE_NUM},HWTYPE=${ECMC_EC_HWTYPE},T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},NELM=${NELM=1},CH_ID=$(ECMC_EC_CH_ID)")

epicsEnvUnset(ECMC_EC_PDO_ID)
