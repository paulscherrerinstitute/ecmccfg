#-d /**
#-d   \brief hardware script for EL5002-Encoder-Posital-OCD-S101G-1416-S060-PRL
#-d   \details
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- Set SDO for channel 1
epicsEnvSet("ECMC_EC_SDO_INDEX"   "0x8000")
#- load generic EL5002 for Posital-OCD-S101G-1416-S060-PRL
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5002-Encoder-Posital-OCD-S101G-1416-S060-PRL.cmd
