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

#- setup python venv and run `plcYamlJinja2.py`
#- MUST be in the same 'system'-context!!!
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}axisYamlJinja2.py -d ${ECMC_TMP_DIR} -T ${ECMC_CONFIG_ROOT} -D ${FILE} -o ${ECMC_TMP_DIR}${FILE}.axis"

#- set device name, default to ${IOC}
epicsEnvSet("ECMC_PREFIX"      "${DEV=${IOC}}:")

#- check for ECMC-format PLC file and load the PLC
ecmcFileExist("${ECMC_TMP_DIR}${FILE}.axis",1)
${SCRIPTEXEC} "${ECMC_TMP_DIR}${FILE}.axis"

#- cleanup
system "rm -rf ${ECMC_TMP_DIR}${FILE}.axis"
#- reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "${SM_PREFIX}")
