#-d /**
#-d   \brief hardware script for EL4008
#-d   \details 8 channel analog output module 0-10V 12 bit
#-d   \author Alvin Acerbo
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d
#-d   \note TODO: Check if entry index is correct (0x1, it is 0x11 in twincat)
#-d
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL4008")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0fa83052")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

ecmcFileExist(${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd,1)

#- ############ Config PDOS: Channel 1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1600,ECMC_ENTRY=0x7000,ECMC_ENTRY_OFFSET=0x1"

#- ############ Config PDOS: Channel 2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=02,ECMC_PDO=0x1601,ECMC_ENTRY=0x7010,ECMC_ENTRY_OFFSET=0x1"

#- ############ Config PDOS: Channel 3
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=03,ECMC_PDO=0x1602,ECMC_ENTRY=0x7020,ECMC_ENTRY_OFFSET=0x1"

#- ############ Config PDOS: Channel 4
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=04,ECMC_PDO=0x1603,ECMC_ENTRY=0x7030,ECMC_ENTRY_OFFSET=0x1"

#- ############ Config PDOS: Channel 5
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1600,ECMC_ENTRY=0x7040,ECMC_ENTRY_OFFSET=0x1"

#- ############ Config PDOS: Channel 6
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1600,ECMC_ENTRY=0x7050,ECMC_ENTRY_OFFSET=0x1"

#- ############ Config PDOS: Channel 7
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1600,ECMC_ENTRY=0x7060,ECMC_ENTRY_OFFSET=0x1"

#- ############ Config PDOS: Channel 8
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1600,ECMC_ENTRY=0x7070,ECMC_ENTRY_OFFSET=0x1"
