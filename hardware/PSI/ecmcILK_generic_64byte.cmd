#-d /**
#-d   \brief hardware script for Anybus-CC-ETC-ILK
#-d   \details LLRF ILK cfg of 64byte buffer
#-d   \author Anders Sandstroem
#-d   \file
#-d */

ecmcFileExist(${ecmccfg_DIR}ecmcILK_generic_buffer.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcILK_generic_buffer.cmd "IN_SIZE=64,OUT_SIZE=64"
