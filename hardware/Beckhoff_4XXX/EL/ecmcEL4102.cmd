#-d /**
#-d   \brief hardware script for EL4102
#-d   \details 2 channel analog output module 0-10V 16 bit
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d
#-d   \note TODO: Check if entry index is correct (0x6411:01, it is 0x7000:11 in twincat)
#-d
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL4102")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x10063052")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

ecmcFileExist(${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd,1)

#- ############ Config PDOS: Channel 1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1600,ECMC_ENTRY=0x6411,ECMC_ENTRY_OFFSET=0x1"

#- ############ Config PDOS: Channel 2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=02,ECMC_PDO=0x1601,ECMC_ENTRY=0x6411,ECMC_ENTRY_OFFSET=0x2"
