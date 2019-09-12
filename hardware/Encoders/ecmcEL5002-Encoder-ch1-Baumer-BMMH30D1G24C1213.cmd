#-d /**
#-d   \brief hardware script for EL5002-Encoder-ch1-Baumer-BMMH30D1G24C1213
#-d   \details
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- set SDO for channel 1
epicsEnvSet("ECMC_EC_SDO_INDEX"   "0x8000")
#- load generic EL500X for Baumer-BMMH30D1G24C1213
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL500X-Encoder-Baumer-BMMH30D1G24C1213.cmd
