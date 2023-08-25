#-d /**
#-d   \brief hardware script for EL5042-Encoder-ch1-Wachendorff-WDGA36E-06-1218-SIA-B01-CB8
#-d   \details Parametrization of EL5042  channel 2 for encoder Wachendorff WDGA36E-06-1218-SIA-B01-CB8
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8008")     # CH1=0x8008. CH2=0x8018

#- Call generic config file
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5042-Encoder-Wachendorff-WDGA36E-06-1218-SIA-B01-CB8.cmd
