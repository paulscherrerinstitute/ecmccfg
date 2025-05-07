#-d /**
#-d   \brief hardware script for EL3068
#-d   \details 8 channel analog input module 0-10V, 12bit
#-d   \author Alvin Acerbo
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3068")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0bfc3052")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- analog input Ch1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1a00,ECMC_ENTRY=0x6000"
#- analog input Ch2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=02,ECMC_PDO=0x1a02,ECMC_ENTRY=0x6010"
#- analog input Ch3
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=03,ECMC_PDO=0x1a04,ECMC_ENTRY=0x6020"
#- analog input Ch4
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=04,ECMC_PDO=0x1a06,ECMC_ENTRY=0x6030"
#- analog input Ch5
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=05,ECMC_PDO=0x1a08,ECMC_ENTRY=0x6040"
#- analog input Ch6
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=06,ECMC_PDO=0x1a0a,ECMC_ENTRY=0x6050"
#- analog input Ch7
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=07,ECMC_PDO=0x1a0c,ECMC_ENTRY=0x6060"
#- analog input Ch8
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=08,ECMC_PDO=0x1a0e,ECMC_ENTRY=0x6070"
