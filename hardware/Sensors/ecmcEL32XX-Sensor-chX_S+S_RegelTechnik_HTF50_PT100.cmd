#-d /**
#-d   \brief hardware script for EL32XX-Sensor-chX_S+S_RegelTechnik_HTF50_PT100
#-d   \details Parametrization of EL32X4 for S+S Regeltechnik HFT50 PT100 sensor
#-d   \author Anders Sandstroem
#-d   \file
#-d */

############################################################
############# Parametrization of EL32X4 for S+S Regeltechnik HFT50 PT100 sensor
#- Type: PT100
#- Range: -35 to 105 degC
#- Connectiontype : 2 wire
#- Cable length: 1.5m
#- Cable area: 0.25mm²
#
#- Environment variables needed:
#- -ECMC_EC_SDO_INDEX "0x80n0" where n is channel 0..3
#- -ECMC_EC_SLAVE_NUM = slave number
#-

#- Enable user scale (default 0=disabled)
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x1")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")  # Disabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Presentation:
#- 0 = Signed (Default)
#- 1 = Absolute, MSB as sign
#- 2 = High precision (only available for certain terminals)
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x2")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")  # Signed
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Enable Siemens S5 bits:
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x5")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")  # Disabled
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Enable filter (not available for EL3208 and 3214-00x0):
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x6")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1")  # Enabled
#- NOTE: According to documentation the filter is always enabled independent of setting since needed for measure process. So rely on default value.
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Enable limit 1 (not available for EL3208 and 3214-00x0):
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x7")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")  # Disabled
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Enable limit 2 (not available for EL3208 and 3214-00x0):
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x8")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")  # Disabled
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Enable auto calibration (not available for EL3208 and 3214-00x0):
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x9")
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

#- User scale offset
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x11")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- User scale gain (Represented in fixed point format with factor 2^⁻16=> 1 corresponds to  65535)
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x12")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "4")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "65535")  # Gain 1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Limit 1 (not available for EL3208 and 3214-00x0):
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x13")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Limit 2 (not available for EL3208 and 3214-00x0):
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x14")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- 0x15 is set in the common snippet since these settings are valid for all channels

#- User calibration offset
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x17")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- User calibration gain (Represented in fixed point format with factor 2^⁻16=> 1 corresponds to  65535)
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x18")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "65535")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- RTD Element:
#- 0 = Pt100
#- 1 = Ni100
#- 2 = Pt1000
#- 3 = Pt500
#- 4 = Pt200
#- 5 = Ni1000 (-60 to 250 degC)
#- 6 = Ni1000 (-30 to 160 degC)
#- 7 = Ni120
#- 8 = Ohm (resolution 1/16ohm, 10..4095ohm)
#- 9 = Ohm (resolution 1/64ohm, 10..1047ohm)
#- 10-32 =  KT* see documentation
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x19")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")  # PT100
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Connection technology:
#- 0 = Two wire
#- 1 = Three wire
#- 2 = Four wire
#- 0x80n0:1A
#- Default setting is different depending on which terminal.
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x1A")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")  # Two wire
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Calibration of supply lines (1/32 Ω):
#- Cable length = 1.5m
#- Wire area: 0.25mm²
#- Specific resistance of copper is 0.0175 Ω mm²/m
#- R=0.0175*1.5/0.25=0.1Ω
#- Settings = 0.1/(1/32)=3
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x1B")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "3")  # 0.1Ω
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Cleanup
epicsEnvUnset("ECMC_EC_SDO_INDEX_OFFSET")
epicsEnvUnset("ECMC_EC_SDO_SIZE")
epicsEnvUnset("ECMC_EC_SDO_VALUE")
