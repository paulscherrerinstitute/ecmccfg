#-d /**
#-d   \brief hardware script for EL3174_4to20mA-Sensor-chX
#-d   \details Parmetrization Default SDO settings for EL3174
#-d   \author Anders Sandstroem
#-d   \file
#-    \pre Environment variables needed:
#-    \pre ECMC_EC_SDO_INDEX "0x80nD" where n is channel 0..3
#-    \pre ECMC_EC_SLAVE_NUM = slave number
#-d */

############################################################
############# Parmetrization Default SDO settings for EL3164

#- Input signal type
#- 0x02 = +-10V (default)
#- 0x0E = 0..10V
#- 0x11 = -20..20mA
#- 0x12 = 0..20mA
#- 0x13 = 4..20mA
#- 0x14 = 4..20mA (NAMUR)
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x11")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x13")  # 4..20mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Scaler
#- 0x00 = Extended range (default)
#- 0x03 = Legacy range
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x12")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0x00")  # Extended Range
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Cleanup
epicsEnvUnset("ECMC_EC_SDO_INDEX_OFFSET")
epicsEnvUnset("ECMC_EC_SDO_SIZE")
epicsEnvUnset("ECMC_EC_SDO_VALUE")
