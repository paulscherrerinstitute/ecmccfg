#==============================================================================
# loadYamlAxis.cmd
#-d /**
#-d   \brief Script for loading Axis from yaml file via `jinja2`
#-d   \details adds an Axis, based on a yaml config file
#-d   \author Niko Kivel
#-d   \file
#-d   \param FILE the yaml-file containing the PLC definition
#-d   \param DEV  the device name (optional, defaults to ${IOC}
#-d   \note Example calls:
#-d   \note - call
#-d   \code
#-d     ${SCRIPTEXEC} "./loadYamlAxis.cmd" "FILE=./axis1.yaml"
#-d     ${SCRIPTEXEC} "./loadYamlAxis.cmd" "FILE=./axis1.yaml, DEV=foobar"
#-d   \endcode
#-d */

#- halt the ioc startup in case od an error
on error halt

# Step 1: Get macros from yaml file
epicsEnvSet(FILE_TEMP_BASE,${ECMC_TMP_DIR}${FILE})
epicsEnvSet(FILE_TEMP_1,${FILE_TEMP_BASE}_1)
system "echo '' > ${FILE_TEMP_1}"
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}ecmcYamlGetMacros.py ${FILE} ${FILE_TEMP_1}"
ecmcFileExist("${FILE_TEMP_1}",1)
${SCRIPTEXEC} "${FILE_TEMP_1}"
system "rm -rf ${FILE_TEMP_1}"
epicsEnvUnset(FILE_TEMP_1)
# PLC macros:
epicsEnvShow(ECMC_PLC_MACROS)

# Step 2: Run msi with the macros from  step 1
ecmcFileExist("${FILE}",1)
epicsEnvSet(FILE_TEMP_2,${FILE_TEMP_BASE}_2)
system "msi -M '${ECMC_PLC_MACROS=EMPTY}' -o ${FILE_TEMP_2} ${FILE}"

# Step 3: Get Filename (need to check if filename contains other macros also). Bascally run the filename in this iocsh
epicsEnvSet(FILE_TEMP_3,${FILE_TEMP_BASE}_3)
system "echo '' > ${FILE_TEMP_3}"
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}ecmcPlcGetFileName.py ${FILE_TEMP_2} ${FILE_TEMP_3}"
ecmcFileExist("${FILE_TEMP_3}",1)
#- Eval name
${SCRIPTEXEC} "${FILE_TEMP_3}"
system "rm -rf ${FILE_TEMP_3}"
epicsEnvUnset(FILE_TEMP_3)
# PLC filename (with expanded macros):
epicsEnvShow(ECMC_PLC_FILENAME)

# Step 4: Set plc.file (write new yaml file)
epicsEnvSet(FILE_TEMP_4,${FILE_TEMP_BASE}_4)
#-system "echo '' > ${FILE_TEMP_4}"
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}ecmcPlcSetFileName.py ${FILE_TEMP_2} ${FILE_TEMP_4} ${ECMC_PLC_FILENAME=}"
system "rm -rf ${FILE_TEMP_2}"
epicsEnvUnset(FILE_TEMP_2)
epicsEnvUnset(ECMC_PLC_FILENAME)
ecmcFileExist("${FILE_TEMP_4}",1)

#- Step 5: setup python venv and run `plcYamlJinja2.py`
#- MUST be in the same 'system'-context!!!
epicsEnvSet(FILE_TEMP_5,${FILE_TEMP_BASE}_5)
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}axisYamlJinja2.py -d ${ECMC_TMP_DIR} -T ${ECMC_CONFIG_ROOT} -D ${FILE_TEMP_4} -o ${FILE_TEMP_5}"
system "rm -rf ${FILE_TEMP_4}"
epicsEnvUnset(FILE_TEMP_4)

#- Step 6: Run msi again on the output jinja2 script
ecmcFileExist("${FILE}",1)
epicsEnvSet(FILE_TEMP_6,${FILE_TEMP_BASE}_6)
system "msi -M '${ECMC_PLC_MACROS=EMPTY}' -o ${FILE_TEMP_6} ${FILE_TEMP_5}"
system "rm -rf ${FILE_TEMP_5}"
epicsEnvUnset(FILE_TEMP_5)

#- set device name, default to ${IOC}
epicsEnvSet("ECMC_PREFIX"      "${DEV=${IOC}}:")

#- check for ECMC-format PLC file and load the PLC
ecmcFileExist("${FILE_TEMP_6}",1)
system "cat ${FILE_TEMP_6}"
${SCRIPTEXEC} "${FILE_TEMP_6}"

#- cleanup
system "rm -rf ${FILE_TEMP_6}"
epicsEnvUnset(FILE_TEMP_6)
epicsEnvUnset(ECMC_PLC_MACROS)

#- reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "${SM_PREFIX}")
