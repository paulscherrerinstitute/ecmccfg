#-d /**
#-d   \brief hardware script for EL6624-Sensor-chX_Panasonic-HGC1100L3-P
#-d   \details Parametrization of EL6624 for Panasonic-HGC1100L3-P Laser distance sensor
#-d   \author Anders Sandstroem
#-d   \file
#-d    \pre Environment variables needed:
#-d    \pre ECMC_EC_CH_ID       01..04
#-d    \pre ECMC_EC_SLAVE_NUM   Slave number
#-d    \pre ECMC_EC_VENDOR_ID   EtherCAT vendor ID of EL6224
#-d    \pre ECMC_EC_PRODUCT_ID  EtherCAT product ID of EL6224
#-d */

#- From twincat startup tab
#- 02 80 02 00 42 03 00 00 11 01 0A 00 C3 00 00 00 00 00 23 00
#- Devide into entries based on size 4,4,1,1,1,1,1,1,2,2,2 bytes:
#- 02 80 02 00  => 0x28002 = 163842
#- 42 03 00 00  => 0x342 = 834
#- 11
#- 01
#- 0A
#- 00
#- C3
#- 00
#- 00 00
#- 00 00
#- 23 00

#- Convert to PDO id
ecmcEpicsEnvSetCalc("ECMC_EC_PDO_ID", "${ECMC_EC_CH_ID=01}-1", "%d")

#- Map entries based on twincat config
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A0${ECMC_EC_PDO_ID},0x60${ECMC_EC_PDO_ID}0,0x01,S16,analogInput${ECMC_EC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A0${ECMC_EC_PDO_ID},0x60${ECMC_EC_PDO_ID}0,0x02,S8,scale${ECMC_EC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A0${ECMC_EC_PDO_ID},0x60${ECMC_EC_PDO_ID}0,0x03,U8,sensorStatus${ECMC_EC_CH_ID})"

#- 0x8020:04, rwrwrw, uint32, 32 bit, "Device ID" 163842
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x4")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "4")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "163842")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x8020:05, rwrwrw, uint32, 32 bit, "Vendor ID" 834
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x5")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "4")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "834")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:20, rwrwrw, uint8, 8 bit, "IO-Link Revision" 0x11
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x20")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x11")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:21, rwrwrw, uint8, 8 bit, "Frame capability" 0x01
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x21")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x01")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:22, rwrwrw, uint8, 8 bit, "Min cycle time" 0x0A
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x22")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x0A")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:23, rwrwrw, uint8, 8 bit, "Offset time"
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x23")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:24, rwrwrw, uint8, 8 bit, "Process data in length" 0xC3
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x24")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0xC3")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:25, rwrwrw, uint8, 8 bit, "Process data out length" 0
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x25")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:26, rwrwrw, uint16, 16 bit, "Compatible ID" 0
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x26")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:27, rwrwrw, uint16, 16 bit, "Reserved" 0x00
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x27")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x00")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x80x0:28, rwrwrw, uint16, 16 bit, "Master Control" 0x23
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x28")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x23")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x80${ECMC_EC_PDO_ID}0,$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

dbLoadTemplate(ecmc_analogInput-chX.template,"P=${ECMC_PREFIX},ECMC_P=${ECMC_P},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,MASTER_ID=${ECMC_EC_MASTER_ID},SLAVE_POS=${ECMC_EC_SLAVE_NUM},HWTYPE=${ECMC_EC_HWTYPE},T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},NELM=${NELM=1},CH_ID=$(ECMC_EC_CH_ID)")

epicsEnvUnset(ECMC_EC_PDO_ID)
