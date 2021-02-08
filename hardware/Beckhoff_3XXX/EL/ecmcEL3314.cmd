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

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- analog input Ch1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=1,ECMC_PDO=0x1a00,ECMC_ENTRY=0x6000"
#- analog input Ch2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=2,ECMC_PDO=0x1a01,ECMC_ENTRY=0x6010"
#- analog input Ch3
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=3,ECMC_PDO=0x1a02,ECMC_ENTRY=0x6020"
#- analog input Ch4
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=4,ECMC_PDO=0x1a03,ECMC_ENTRY=0x6030"
