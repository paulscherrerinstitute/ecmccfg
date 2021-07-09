#-d /**
#-d   \brief hardware script for EL3174_4to20mA
#-d   \details 4-channel analog input, -10/0…+10 V, -20/0/+4…+20 mA, 16 bit
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d   \note Selected range: 4..20mA (actually 0..21.179mA)
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3174_4to20mA")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0c663052")

ecmcFileExist(${ecmccfg_DIR}ecmcEL3174_generic.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL3174_generic.cmd
