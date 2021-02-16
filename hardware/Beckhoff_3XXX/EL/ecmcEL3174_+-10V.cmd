#-d /**
#-d   \brief hardware script for EL3174_+-10V
#-d   \details 4-channel analog input, -10/0…+10 V, -20/0/+4…+20 mA, 16 bit
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d   \note Selected range: +-10V (actually +-10.737V)
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3174_+-10V")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0c663052")

ecmcFileExist(${ecmccfg_DIR}ecmcEL3174_generic.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL3174_generic.cmd
