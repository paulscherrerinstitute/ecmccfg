#-d /**
#-d   \brief hardware script for EL7037
#-d   \details EL7037 stepper drive (24V,1.5A)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL7037_CSP")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b7d3052")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EL7037")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7000,0x01,16,encoderControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7000,0x11,32,encoderValue01"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1602,0x7010,0x1,16,driveControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1603,0x7010,0x11,32,1,positionSetpoint01)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6000,0x0,16,encoderStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6000,0x11,32,1,positionActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6000,0x12,32,encoderLatchPostion01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6010,0x1,16,driveStatus01)"

#- Ensure drive recives some SDO settings
ecmcConfigOrDie "Cfg.EcSetSlaveNeedSDOSettings(${ECMC_EC_SLAVE_NUM},1,1)"

#- Max full step freq = 2000Hz (setting is 1)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x5,1,1)"

#- Error on loss of steps = 1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0xA,1,1)"

#- Feedback type = Internal counter = 1 (for encoder on terminal set to 0)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x8,1,1)"

#- Invert motor polarity = 0
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x9,0,1)"

#- Activly choose CSP
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x1,3,1)"

#- Set used pdos
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C12")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x1601,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x1602,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x3,0x1603,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,3,1)"

epicsEnvSet("ECMC_SDO_INDEX",              "0x1C13")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x1A01,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x1A03,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "Ex70x7")
