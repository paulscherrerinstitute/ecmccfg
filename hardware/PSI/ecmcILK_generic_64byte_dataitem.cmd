#-d /**
#-d   \brief map data items for the resulting data buffer  
#-d   \details Needs to be executed LAST in order to see the final results of the buffers
#-d   \details Also loads AI records for dataitems
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- The records will only be INPUTS to view the current status of teh buffer
epicsEnvSet("ECMC_EC_KEY"   "byteOutput")
ecmcFileExist(${ecmccfg_DIR}ecmcILK_generic_loopStep_dataitem.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcILK_generic_loopStep_dataitem.cmd,"KEY=${ECMC_EC_KEY}",IDX,1,64,1)

epicsEnvSet("ECMC_EC_KEY"   "byteInput")
ecmcFileExist(${ecmccfg_DIR}ecmcILK_generic_loopStep_dataitem.cmd,1)
ecmcForLoop(${ecmccfg_DIR}ecmcILK_generic_loopStep_dataitem.cmd,"KEY=${ECMC_EC_KEY}",IDX,1,64,1)
