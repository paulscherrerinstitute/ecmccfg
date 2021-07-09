#-d /**
#-d   \brief hardware script for EL2502
#-d   \details 2 channel pulse width modulation output 24V
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL2502")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x09c63052")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=1"

#- ############ Config PDOS: Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x11,16,pwmOutput01)"

#- ############ Config PDOS: Channel 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x11,16,pwmOutput02)"
