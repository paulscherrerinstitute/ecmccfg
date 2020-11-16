#-d /**
#-d   \brief hardware script for EL3751
#-d   \details single channel 24bit analog input differential (selectable range (SDO), not in this config yet)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: single channel 24bit analog input differential (selectable range (SDO), not in this config yet)
#-
#-  by Niko Kivel, Paul Scherrer Institute, 2018
#-  email: niko.kivel@psi.ch
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3751")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0ea73052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

#- ############ Config PDOS: Channel 1

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x01,16,STATUS)"
#- EthercatMCConfigController ${ECMC_MOTOR_PORT} "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6001,0x01,32,VALUE)"
