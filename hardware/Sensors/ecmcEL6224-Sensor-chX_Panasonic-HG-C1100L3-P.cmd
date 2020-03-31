#-d /**
#-d   \brief hardware script for EL6624-Sensor-chX_Panasonic-HGC1100L3-P
#-d   \details Parmetrization of EL6624 for Panasonic-HGC1100L3-P Laser distance sensor
#-d   \author Anders Sandstroem
#-d   \file
#-d    \pre Environment variables needed:
#-d    \pre ECMC_EC_SDO_INDEX "0x80n0" where n is channel 0..3
#-d    \pre ECMC_EC_SLAVE_NUM = slave number
#-d */

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A0${ECMC_EC_CH_ID},0x60${ECMC_EC_CH_ID}0,0x01,S32,AI_${ECMC_EC_CH_ID_TEXT})"

#- 0x8020:04, rwrwrw, uint32, 32 bit, "Device ID" 163842
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x4")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "4")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "163842")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x8020:05, rwrwrw, uint32, 32 bit, "Vendor ID" 834
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x5")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "4")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "834")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:20, rwrwrw, uint8, 8 bit, "IO-Link Revision" 0x11
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x20")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x11")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:21, rwrwrw, uint8, 8 bit, "Frame capability" 0x2B
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x21")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x2B")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:22, rwrwrw, uint8, 8 bit, "Min cycle time" 0x0A
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x22")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x0A")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:23, rwrwrw, uint8, 8 bit, "Offset time"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x23")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:24, rwrwrw, uint8, 8 bit, "Process data in length" 0xC3
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x24")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0xC3")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:25, rwrwrw, uint8, 8 bit, "Process data out length"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x25")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:26, rwrwrw, uint16, 16 bit, "Compatible ID"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x26")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:28, rwrwrw, uint16, 16 bit, "Master Control" 0x23
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x28")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x23")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

dbLoadRecords(ecmcEL6224-Analog-chX.template,"P=${ECMC_PREFIX},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,MASTER_ID=${ECMC_EC_MASTER_ID},SLAVE_POS=${ECMC_EC_SLAVE_NUM},HWTYPE=${ECMC_EC_HWTYPE},T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},CH_ID=$(ECMC_EC_CH_ID_TEXT)")
