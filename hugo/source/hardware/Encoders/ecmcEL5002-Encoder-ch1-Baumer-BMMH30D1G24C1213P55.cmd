#-d /**
#-d   \brief hardware script for EL5002-Encoder-ch1-Baumer-BMMH30D1G24C1213P55
#-d   \details Parmetrization of EL5002  channel 1 for encoder Baumer BMMH30D1G24C12/13P55
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8000")     # CH1=0x8000. CH2=0x8010

#- Call generic config file
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5002-Encoder-Baumer-BMMH30D1G24C1213P55.cmd
