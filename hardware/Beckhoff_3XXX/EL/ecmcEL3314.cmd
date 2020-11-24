#-d /**
#-d   \brief hardware script for EL3314
#-d   \details EL3314 | 4-channel thermocouple input terminal with open-circuit recognition
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */


epicsEnvSet("ECMC_EC_HWTYPE"             "EL3314")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0cf23052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

#- ############ Config PDOS: Channel 1
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "1")
epicsEnvSet("ECMC_EC_PDO"                "0x1a00")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6000")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-chX-analogInput.cmd

#- ############ Config PDOS: Channel 2
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "2")
epicsEnvSet("ECMC_EC_PDO"                "0x1a01")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6010")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-chX-analogInput.cmd

#- ############ Config PDOS: Channel 3
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "3")
epicsEnvSet("ECMC_EC_PDO"                "0x1a02")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6020")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-chX-analogInput.cmd

#- ############ Config PDOS: Channel 4
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "4")
epicsEnvSet("ECMC_EC_PDO"                "0x1a03")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6030")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-chX-analogInput.cmd

epicsEnvUnset("ECMC_EC_CHANNEL_ID")
epicsEnvUnset("ECMC_EC_PDO")
epicsEnvUnset("ECMC_EC_PDO_ENTRY")
