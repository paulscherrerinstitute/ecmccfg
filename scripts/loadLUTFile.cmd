#==============================================================================
# loadLUTFile.cmd
#- Arguments: FILE, [LUT_ID]
#-d /**
#-d   \brief Script for craeting and adding a lookup table (LUT) from file.
#-d   \author Anders Sandström
#-d   \file
#-d   \param FILE LUT definition file, i.e. ./plc/test.lut
#-d   \param LUT_ID (optional) LUT_ID Default the next free number. The actual id will be stored in "ECMC_LUT_ID" for use after this script.
#-d
#-d   Example:
#-d   # Lookup table example (in this case for encoder corrections, but could be for anything when used in PLC)
#-d   # * Col 1: Encoder position values [EGU]
#-d   # * Col 2: Encoder correction values at the corresponding [EGU]
#-d   # Created 2024-12-09
#-d   #
#-d   # The number needs to be comma or space separated (only one char).
#-d   #
#-d   # Precision can be changed with the PREC command, see below example.
#-d   # All data read after/below a PREC command will be read with the new PREC.
#-d   #
#-d   PREC=5
#-d   -10 -10.123456789
#-d   0 0.123456789
#-d   10 10.123456789
#-d   PREC=6
#-d   12.67898 12.3456789
#-d */

epicsEnvSet("ECMC_LUT_ID",              "${LUT_ID=0}")

#- Now load the file to ecmc
ecmcFileExist("${FILE}",1)
ecmcConfigOrDie "Cfg.LoadLUTFile(${ECMC_LUT_ID},${FILE})"

ecmcEpicsEnvSetCalc(ECMC_LUT_COUNT, "$(ECMC_LUT_COUNT=0)+1")

#- increment LUT_ID
ecmcEpicsEnvSetCalc("LUT_ID", "${ECMC_LUT_ID}+1","%d")
