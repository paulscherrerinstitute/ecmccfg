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

#- Get plc.file (must do like this in order to allow macros in plc.file). Basically execute plc.file in iocsh to expand macros
epicsEnvSet(GET_PLC_FILENAME_FILE,${ECMC_TMP_DIR}getPlcFilename.cmd)
system "echo '' > ${GET_PLC_FILENAME_FILE}"
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}ecmcPlcGetFileName.py ${FILE} ${GET_PLC_FILENAME_FILE}"
ecmcFileExist("${GET_PLC_FILENAME_FILE}",1)
${SCRIPTEXEC} "${GET_PLC_FILENAME_FILE}"
system "rm -rf ${GET_PLC_FILENAME_FILE}"
epicsEnvUnset(GET_PLC_FILENAME_FILE)
# PLC filename (with expanded macros):
epicsEnvShow(ECMC_PLC_FILENAME)
# PLC macros:
epicsEnvShow(ECMC_PLC_MACROS)

#- Set plc.file (write new yaml file)
epicsEnvSet(UPDATED_YAML_FILE,${ECMC_TMP_DIR}${FILE}.filename)
system "echo '' > ${UPDATED_YAML_FILE}"
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}ecmcPlcSetFileName.py ${FILE} ${UPDATED_YAML_FILE} ${ECMC_PLC_FILENAME=}"
epicsEnvUnset(ECMC_PLC_FILENAME)
ecmcFileExist("${UPDATED_YAML_FILE}",1)

#- setup python venv and run `plcYamlJinja2.py`
#- MUST be in the same 'system'-context!!!
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}axisYamlJinja2.py -d ${ECMC_TMP_DIR} -T ${ECMC_CONFIG_ROOT} -D ${UPDATED_YAML_FILE} -o ${ECMC_TMP_DIR}${FILE}.axis"
system "rm -rf ${UPDATED_YAML_FILE}"

#- run msi with the macros plc.macros
ecmcFileExist("${ECMC_TMP_DIR}${FILE}.axis",1)
epicsEnvSet(MSI_OUTPUT_FILE,"${ECMC_TMP_DIR}${FILE}.axis.msi")
system "msi -M '${ECMC_PLC_MACROS=EMPTY}' -o ${MSI_OUTPUT_FILE} ${ECMC_TMP_DIR}${FILE}.axis"
system "rm -rf ${ECMC_TMP_DIR}${FILE}.axis"

#- set device name, default to ${IOC}
epicsEnvSet("ECMC_PREFIX"      "${DEV=${IOC}}:")

#- check for ECMC-format PLC file and load the PLC
ecmcFileExist("${MSI_OUTPUT_FILE}",1)
system "cat ${MSI_OUTPUT_FILE}"
${SCRIPTEXEC} "${MSI_OUTPUT_FILE}"

#- cleanup
system "rm -rf ${MSI_OUTPUT_FILE}"
epicsEnvUnset(UPDATED_YAML_FILE)

#- reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "${SM_PREFIX}")
