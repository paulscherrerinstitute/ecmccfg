#-d /**
#-d   \brief hardware script for ecmcEL5042-Encoder-ch1-Nanotec-ASA5618M42.cmd
#-d   \details Parametrization of EL5042  channel 2 for encoder ASA5618M42
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8018")     # CH1=0x8008. CH2=0x8018
#- Call generic config file
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5042-Encoder-Nanotec-ASA5618M42.cmd
