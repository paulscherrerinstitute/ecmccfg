#-d /**
#-d   \brief hardware script for Anybus-CC-ETC-ILK
#-d   \details LLRF ILK cfg of 64byte buffer
#-d   \author Anders Sandstroem
#-d   \file
#-d */

ecmcFileExist(${ecmccfg_DIR}ecmcILK_v2_generic_buffer.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcILK_v2_generic_buffer.cmd "IN_SIZE=${NELM},OUT_SIZE={NELM}"
