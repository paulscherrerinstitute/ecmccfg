#==============================================================================
# loadYamlPlc.cmd
#-d /**
#-d   \brief Script for loading PLC from yaml file via `jinja2`
#-d   \details adds a PLC, line by line, from a yaml-file, parsed by `jinja2`
#-d   \author Niko Kivel, Anders Sandström
#-d   \file
#-d   \param FILE the yaml-file containing the PLC definition
#-d   \note Example calls:
#-d   \note - call
#-d   \code
#-d     ${SCRIPTEXEC} "./loadYamlPlc.cmd" "FILE=./plc1.yaml"
#-d   \endcode
#-d */

#- halt the ioc startup in case od an error
on error halt

# Step 1: Get Filename (need to check if filename contains other macros also). Bascally run the filename in this iocsh
ecmcFileExist("${FILE}",1)
epicsEnvSet(FILE_TEMP_BASE,${ECMC_TMP_DIR}${FILE})
epicsEnvSet(FILE_TEMP_1,${FILE_TEMP_BASE}_1)
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}ecmcPlcGetFileName.py ${FILE} ${FILE_TEMP_1}"
#- Eval name
${SCRIPTEXEC} "${FILE_TEMP_1}"
system "rm -rf ${FILE_TEMP_1}"
epicsEnvUnset(FILE_TEMP_1)
# PLC filename (with expanded macros):
epicsEnvShow(ECMC_PLC_FILENAME)

# Step 2: Set plc.file (write new yaml file)
epicsEnvSet(FILE_TEMP_2,${FILE_TEMP_BASE}_2)
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}ecmcPlcSetFileName.py ${FILE} ${FILE_TEMP_2} ${ECMC_PLC_FILENAME=}"
ecmcFileExist("${FILE_TEMP_2}",1)

#- Step 3: setup python venv and run `plcYamlJinja2.py`
#- MUST be in the same 'system'-context!!!
epicsEnvSet(FILE_TEMP_3,${FILE_TEMP_BASE}_3)
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}plcYamlJinja2.py -d ${ECMC_TMP_DIR} -T ${ECMC_CONFIG_ROOT} -D ${FILE_TEMP_2} -o ${FILE_TEMP_3}"
system "rm -rf ${FILE_TEMP_2}"
epicsEnvUnset(FILE_TEMP_2)

#- set device name, default to ${IOC}
epicsEnvSet("ECMC_PREFIX"      "${DEV=${IOC}}:")

#- check for ECMC-format PLC file and load the PLC
ecmcFileExist("${FILE_TEMP_3}",1)
system "cat ${FILE_TEMP_3}"
${SCRIPTEXEC} "${FILE_TEMP_3}"

#- cleanup
system "rm -rf ${FILE_TEMP_3}"
epicsEnvUnset(FILE_TEMP_3)
epicsEnvUnset(ECMC_PLC_FILENAME)
epicsEnvUnset(FILE_TEMP_BASE)

#- reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "${SM_PREFIX}")

ecmcEpicsEnvSetCalc(ECMC_PLC_COUNT, "$(ECMC_PLC_COUNT=0)+1")
