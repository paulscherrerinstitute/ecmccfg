#-d /**
#-d   \brief hardware script for EP7041-0000
#-d   \details 1 channel BISS-C encoder interface
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EP7041-0000")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b814052")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=${ECMC_SLAVE_RESET=true}"

#- ###########################################################
#- ############ Config PDOS: Channel 1

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,16,encoderStatus01)"
ecmcConfigOrDie "Cfg.EcSetSlavePortWiringCheckEnable(${ECMC_EC_SLAVE_NUM},1)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,64,positionActual01)"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "EP7041-0000")

#- Cleanup
epicsEnvUnset(ECMC_SLAVE_RESET)
