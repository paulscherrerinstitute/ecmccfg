#-d /**
#-d   \brief hardware script for EL3255
#-d   \details 5 channel potentiometer input
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: 5 channel potentiometer input
#-
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3255")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0cb73052")

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

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "Ex3255")
