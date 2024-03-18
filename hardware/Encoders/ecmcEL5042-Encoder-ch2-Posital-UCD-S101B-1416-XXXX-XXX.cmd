#-d /**
#-d   \brief hardware script for CH2 ecmcEL5042-Encoder-Postital-UCD-S101B-1416-XXXX-XXX
#-d   \details Posital SSI 30-bit encoder
#-d   \author Niko Kivel
#-d   \file
#-d   \pre Need the following varibales:
#-d   \pre ECMC_EC_SLAVE_NUM    Slave index
#-d   \note Supply:     5 V
#-d   \note Resolution: 16/14 bit
#-d */

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8018")     # CH1=0x8008. CH2=0x8018

#- Call generic config file
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5042-Encoder-Postital-UCD-S101B-1416-XXXX-XXX.cmd
                                 