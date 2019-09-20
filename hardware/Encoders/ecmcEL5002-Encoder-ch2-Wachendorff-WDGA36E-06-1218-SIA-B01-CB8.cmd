#-d /**
#-d   \brief hardware script for EL5002-Encoder-ch2-Wachendorff-WDGA36E-06-1218-SIA-B01-CB8
#-d   \details Parmetrization of EL5002  channel 2 for encoder Wachendorff WDGA36E-06-1218-SIA-B01-CB8
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8010")     # CH1=0x8000. CH2=0x8010

#- Call generic config file
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL5002-Encoder-Wachendorff-WDGA36E-06-1218-SIA-B01-CB8.cmd
