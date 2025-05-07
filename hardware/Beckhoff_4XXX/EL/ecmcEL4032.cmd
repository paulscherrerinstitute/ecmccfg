#-d /**
#-d   \brief hardware script for EL4032
#-d   \details 2 channel analog output module +-10V 12 bit
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d
#-d   \note TODO: Check if PDO index is correct (0x1100, it is 0x1600 in twincat)
#-d   \note TODO: Check if entry index is correct (0x1, it is 0x11 in twincat)
#-d
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL4032")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0fc03052")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

ecmcFileExist(${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd,1)

#- ############ Config PDOS: Channel 1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1100,ECMC_ENTRY=0x7000,ECMC_ENTRY_OFFSET=0x1"

#- ############ Config PDOS: Channel 2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogOutput_16bit.cmd "CH_ID=02,ECMC_PDO=0x1100,ECMC_ENTRY=0x7010,ECMC_ENTRY_OFFSET=0x1"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "Ex4xx2")
