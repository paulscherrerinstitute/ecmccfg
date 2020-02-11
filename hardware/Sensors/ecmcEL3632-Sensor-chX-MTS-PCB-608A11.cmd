#-d /**
#-d   \brief hardware script for EL3632-Sensor-chX-MTS-PCB-608A11
#-d   \details Parmetrization of EL3632 with sensor MTS PCB 608A11
#-d   \author Anders Sandstroem
#-d   \file
#-    \pre Environment variables needed:
#-    \pre ECMC_EC_CHANNEL_ID (0..1)
#-    \pre ECMC_EC_SLAVE_NUM = slave number
#-d */

############################################################
############# Parmetrization of EL3632 with sensor MTS PCB 608A11
#- Type: Accelerometer
#- Range: 0.5-10000Hz
#- Sensitivity (+-15%): 10.2mV/(m/s/s)
#- Connection type : IEPE
#- Resonant freq.: 22kHz
#- Non linearity: +-1%
#- Excitation voltage: 18-28VDC
#- Constant current excitation: 2 to20mA

#- Settings in 0x80n0
epicsEnvSet("ECMC_EC_SDO_INDEX",  "0x80$(ECMC_EC_CHANNEL_ID)0")

#- Enable limit 1:
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x7")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")  # Disabled
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Enable user calibration
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0xA")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")  # Disabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Enable vendor calibration
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0xB")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1")  # Enabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Limit 1:
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x13")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Limit 2:
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x14")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Filter settings:
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x15")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "5")
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- User calibration offset:
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x17")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- User calibration gain:
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x18")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "16384")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Supply current:
#- 0 = 2mA
#- 1 = 4mA
#- 2 = 8mA
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x20")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0") # 2mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Activate offset adjustment:
#- 0 = Disabled
#- 1 = Level 1
#- 2 = Level 2
#- ...
#- 8 = Level 8
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x21")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0") # Disabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#Advanced settings in 0x80n8
epicsEnvSet("ECMC_EC_SDO_INDEX",  "0x80$(ECMC_EC_CHANNEL_ID)8")

#- Input Amplifier
#- 0 = According to 0x80n0:15
#- 1 = ON (fix gain of 20)
#- 2 = OFF

epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x6")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1") #20 amplification
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Cleanup
epicsEnvUnset("ECMC_EC_SDO_INDEX_OFFSET")
epicsEnvUnset("ECMC_EC_SDO_SIZE")
epicsEnvUnset("ECMC_EC_SDO_VALUE")
