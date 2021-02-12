#-d /**
#-d   \brief hardware script for EL6624-Sensor-Murr-emparro67
#-d   \details Parmetrization of EL6624 for Murr emparro67 power supply
#-d   \author Niko Kivel
#-d   \file
#-d    \pre Environment variables needed:
#-d    \pre ECMC_EC_SDO_INDEX "0x80n0" where n is channel 0..3
#-d    \pre ECMC_EC_SLAVE_NUM = slave number
#-d */

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A0${ECMC_EC_CH_ID},0x60${ECMC_EC_CH_ID}0,0x01,U8,CH${ECMC_EC_CH_ID}_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A0${ECMC_EC_CH_ID},0x60${ECMC_EC_CH_ID}0,0x09,U8,CH${ECMC_EC_CH_ID}_UA_CURR)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A0${ECMC_EC_CH_ID},0x60${ECMC_EC_CH_ID}0,0x0A,U8,CH${ECMC_EC_CH_ID}_US_CURR)"
#- twice 4 bit current limit, not sure about the data type
# ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A0${ECMC_EC_CH_ID},0x60${ECMC_EC_CH_ID}0,0x0B,U4,CH${ECMC_EC_CH_ID}_UA_CURR_LIM)"
# ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A0${ECMC_EC_CH_ID},0x60${ECMC_EC_CH_ID}0,0x0C,U4,CH${ECMC_EC_CH_ID}_US_CURR_LIM)"

#- 0x8020:04, rwrwrw, uint32, 32 bit, "Device ID" 524800
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x4")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "4")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "524800")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x8020:05, rwrwrw, uint32, 32 bit, "Vendor ID" 303
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x5")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "4")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "303")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:20, rwrwrw, uint8, 8 bit, "IO-Link Revision" 0x11
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x20")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x11")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:21, rwrwrw, uint8, 8 bit, "Frame capability" 0x01
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x21")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x01")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_CH_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:22, rwrwrw, uint8, 8 bit, "Min cycle time" 0x62
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x22")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x62")
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

#- 0x80x0:25, rwrwrw, uint8, 8 bit, "Process data out length" 0xC2
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x25")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0xC2")
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
