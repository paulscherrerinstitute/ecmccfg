#-d /**
#-d   \brief hardware script for ecmcEL5042-Encoder-ch12-RL32BVS001C30V.cmd
#-d   \details Parmetrization of EL5042  channel 1 for encoder RESOLUTE RL 32B VS 001C 30V
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8008")     # CH1=0x8008. CH2=0x8018

#- Call generic config file
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5042-Encoder-Renishaw_32-bit.cmd

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8018")     # CH1=0x8008. CH2=0x8018

#- Call generic config file
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5042-Encoder-Renishaw_32-bit.cmd


