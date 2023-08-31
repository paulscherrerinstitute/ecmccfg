#-d /**
#-d   \brief hardware script for EL3751 FOR
#-d   \details single channel 24bit analog input differential. 
#-d   Special cfg script for one scalar per scan, no oversampling 
#-d   The normal ecmcEL3751.cmd will return waveform.
#-d
#-d   \author Anders Sandstroem
#-d
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3751_Scalar")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0ea73052")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#-  CH 1
epicsEnvSet("ECMC_CH"             "01")

#-  Configuration for sync manager 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x01,16,control${ECMC_CH})"

#-  Configuration for sync manager 3
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,S32,status${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1A01,0x6001,0x01,S32,analogInput${ECMC_CH})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0xF600,0x1,U32,timestamp${ECMC_CH}_l32)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0xF600,0x2,U32,timestamp${ECMC_CH}_u32)"

#- Cleanup
epicsEnvUnset(ECMC_CH)

