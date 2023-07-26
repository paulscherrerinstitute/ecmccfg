#-d /**
#-d   \brief hardware script for EL3314-0002
#-d   \details EL3314-0002 | 4-channel (24 bits) thermocouple input terminal with open-circuit recognition
#-d   \author Anders Sandstroem, Markus Kristensson
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */


epicsEnvSet("ECMC_EC_HWTYPE"             "EL3314-0002")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0cf23052")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL3314-XXXX_generic.cmd
