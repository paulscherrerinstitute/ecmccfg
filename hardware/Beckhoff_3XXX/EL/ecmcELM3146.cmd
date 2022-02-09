#-d /**
#-d   \brief hardware script for ELM3146
#-d   \details 4 channel analog input module +-10V, 24bit
#-d   \author Niko Kivel
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM3146")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x502176a9")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- analog input Ch1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit_2.cmd "CH_ID=1,PDO_0=0x1a00,PDO_1=0x1a01,ENTRY_0=0x6000,ENTRY_1=0x6001"
#- analog input Ch2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit_2.cmd "CH_ID=2,PDO_0=0x1a0b,PDO_1=0x1a0c,ENTRY_0=0x6010,ENTRY_1=0x6011"
#- analog input Ch3
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit_2.cmd "CH_ID=3,PDO_0=0x1a16,PDO_1=0x1a17,ENTRY_0=0x6020,ENTRY_1=0x6021"
#- analog input Ch4
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit_2.cmd "CH_ID=4,PDO_0=0x1a21,PDO_1=0x1a22,ENTRY_0=0x6030,ENTRY_1=0x6031"
#- analog input Ch5
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit_2.cmd "CH_ID=5,PDO_0=0x1a2c,PDO_1=0x1a2d,ENTRY_0=0x6040,ENTRY_1=0x6041"
#- analog input Ch6
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit_2.cmd "CH_ID=6,PDO_0=0x1a37,PDO_1=0x1a38,ENTRY_0=0x6050,ENTRY_1=0x6051"
