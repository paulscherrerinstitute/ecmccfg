#-d /**
#-d   \brief hardware script for CH1 and CH2 ecmcEL5042-Encoder-Posital-KCD-BC03B-1617-XXXX-XXX.cmd
#-d   \details Posital Biss-C 33-bit encoder
#-d   \author Anders Sandström
#-d   \file
#-d   \pre Need the following varibales:
#-d   \pre ECMC_EC_SLAVE_NUM    Slave index
#-d   \note Supply:     5 V
#-d   \note Resolution: 24 bit
#-d */

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8008")     # CH1=0x8008. CH2=0x8018

#- Call generic config file
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5042-Encoder-Posital-KCD-BC03B-1617-XXXX-XXX.cmd

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8018")     # CH1=0x8008. CH2=0x8018

#- Call generic config file
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5042-Encoder-Posital-KCD-BC03B-1617-XXXX-XXX.cmd
