#-d /**
#-d   \brief hardware script for ecmcEL5042-Encoder-ch1-RLS-LA11-24bit.cmd
#-d   \details Parametrization of EL5042  channel 1 for encoder RLS LA11
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8008")     # CH1=0x8008. CH2=0x8018

#- Call generic config file
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5042-Encoder-RLS-LA11DCB2D0KB.cmd
