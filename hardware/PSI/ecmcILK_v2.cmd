#-d /**
#-d   \brief hardware script for Anybus-CC-ETC-ILK
#-d   \details LLRF ILK v2
#-d   \details Only configures a byte buffer
#-d   \author Anders Sandstroem
#-d   \param NELM : Size of input and output buffer
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ILK_v2")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0xe000001b")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x00000034")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- Configure generic buffers (byte out and 64byte in)
ecmcFileExist(${ecmccfg_DIR}ecmcILK_v2_generic_buffer.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcILK_v2_generic_buffer.cmd "IN_SIZE=${NELM},OUT_SIZE=${NELM}"




#- Obsolete
#- Configure generic buffers (64byte out and 64byte in)
#-ecmcFileExist(${ecmccfg_DIR}ecmcILK_v2_generic_64byte.cmd,1)
#-${SCRIPTEXEC} ${ecmccfg_DIR}ecmcILK_v2_generic_64byte.cmd

#- Custom data items moved to IOC
#- ecmcFileExist(${ecmccfg_DIR}ecmcILK_v2_dataitems.cmd,1)
#- ${SCRIPTEXEC} ${ecmccfg_DIR}ecmcILK_v2_dataitems.cmd

#- See the final result of the buffers
#- ecmcFileExist(${ecmccfg_DIR}ecmcILK_v2_generic_64byte_dataitem.cmd,1)
#- ${SCRIPTEXEC} ${ecmccfg_DIR}ecmcILK_v2_generic_64byte_dataitem.cmd

