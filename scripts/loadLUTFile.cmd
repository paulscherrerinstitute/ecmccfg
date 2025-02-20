#==============================================================================
# loadLUTFile.cmd
#- Arguments: FILE, [LUT_ID]

#-d /**
#-d   \brief Script for adding a lookup table (LUT) from file.
#-d   \author Anders Sandström
#-d   \file
#-d   \param FILE LUT definition file, i.e. ./plc/test.lut
#-d   \param LUT_ID (optional) PLC number, default 0, or to next free PLC, the actual PLC Id is stored in ECMC_PLC_ID and can be used after this command
#-d */

#- Create a new PLC 0 (Motion: Direct access through variables, I/O, global var, plc enable)

epicsEnvSet("ECMC_LUT_ID",              "${LUT_ID=0}")

#- Now load the file to ecmc
ecmcFileExist("${FILE}",1)
ecmcConfigOrDie "Cfg.LoadLUTFile(${ECMC_LUT_ID},${FILE})"

ecmcEpicsEnvSetCalc(ECMC_LUT_COUNT, "$(ECMC_LUT_COUNT=0)+1")

#- increment LUT_ID
ecmcEpicsEnvSetCalc("LUT_ID", "${ECMC_LUT_ID}+1","%d")
