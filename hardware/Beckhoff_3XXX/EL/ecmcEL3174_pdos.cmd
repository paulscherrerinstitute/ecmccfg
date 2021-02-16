#-d /**
#-d   \brief hardware script for EL3174 (will only config PDOS)
#-d   \note This file should never be called directlly (this is only for by other EL3174* files)
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- analog input Ch1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1a00,ECMC_ENTRY=0x6000"
#- analog input Ch2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=02,ECMC_PDO=0x1a02,ECMC_ENTRY=0x6010"
#- analog input Ch3
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=03,ECMC_PDO=0x1a04,ECMC_ENTRY=0x6020"
#- analog input Ch4
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=04,ECMC_PDO=0x1a06,ECMC_ENTRY=0x6030"
