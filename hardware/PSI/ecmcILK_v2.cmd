#-d /**
#-d   \brief hardware script for Anybus-CC-ETC-ILK
#-d   \details LLRF ILK v2
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ILK_v2")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x00505349")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x00020000")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- Configure generic buffers (64byte out and 64byte in)
ecmcFileExist(${ecmccfg_DIR}ecmcILK_generic_64byte.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcILK_generic_64byte.cmd

#- Add custom data items as pointers to buffers...
#- Need custom configs here...
#- ...
#- ...

#- See the final result of the buffers
ecmcFileExist(${ecmccfg_DIR}ecmcILK_generic_64byte_dataitem.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcILK_generic_64byte_dataitem.cmd
