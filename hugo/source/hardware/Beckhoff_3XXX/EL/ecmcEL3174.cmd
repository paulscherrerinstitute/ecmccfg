#-d /**
#-d   \brief hardware script for EL3174
#-d   \details 4-channel analog input (signal type will not be defined)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d   \note Selected range: 0..10V (actually 0..10.737V)
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3174")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0c663052")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- Configure PDOS
ecmcFileExist("${ecmccfg_DIR}ecmcEL3174_pdos.cmd",1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL3174_pdos.cmd
