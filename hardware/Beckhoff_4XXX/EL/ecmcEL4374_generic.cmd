#-d /**
#-d   \brief hardware script for EL4374
#-d   \details 2 channel analog output, 2 ch analog input module +-10V, +-20mA 16 bit
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d
#-d */

epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x11163052")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- Outputs
ecmcFileExist(${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd,1)
#- analog output Ch1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1620,ECMC_ENTRY=0x7020,ECMC_ENTRY_OFFSET=0x11"
#- analog output Ch2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=02,ECMC_PDO=0x1630,ECMC_ENTRY=0x7030,ECMC_ENTRY_OFFSET=0x11"

#- Inputs
ecmcFileExist(${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd,1)
#- analog input Ch1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1a00,ECMC_ENTRY=0x6000"
#- analog input Ch2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=02,ECMC_PDO=0x1a10,ECMC_ENTRY=0x6010"
