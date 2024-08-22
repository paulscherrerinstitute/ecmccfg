#-d /**
#-d   \brief hardware script for EL3314-XXXX
#-d   \details EL3314-XXXX | Generic script for EL3314-XXXX modules.
#-d   \author Markus Kristensson
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */


#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- analog input Ch1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit.cmd "CH_ID=01,ECMC_PDO=0x1a00,ECMC_ENTRY=0x6000"
#- analog input Ch2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit.cmd "CH_ID=02,ECMC_PDO=0x1a01,ECMC_ENTRY=0x6010"
#- analog input Ch3
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit.cmd "CH_ID=03,ECMC_PDO=0x1a02,ECMC_ENTRY=0x6020"
#- analog input Ch4
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit.cmd "CH_ID=04,ECMC_PDO=0x1a03,ECMC_ENTRY=0x6030"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "Ex3xx4")
