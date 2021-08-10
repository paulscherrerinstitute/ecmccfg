#-d /**
#-d   \brief Script for loading PLC from yaml file via `jinja2`
#-d   \details adds a PLC, line by line, from a yaml-file, parsed by `jinja2`
#-d   \author Niko Kivel
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

#- setup python venv and run `plcYamlJinja2.py`
#- MUST be in the same 'system'-context!!!
system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; jinja2 "${ECMC_CONFIG_ROOT}axis.jinja2" "${FILE}" -o "${ECMC_TMP_DIR}${FILE}.axis""

#- check for ECMC-format PLC file and load the PLC
ecmcFileExist("${ECMC_TMP_DIR}${FILE}.axis",1)
${SCRIPTEXEC} "${ECMC_TMP_DIR}${FILE}.axis"

#- cleanup
system "rm -rf ${ECMC_TMP_DIR}${FILE}.axis"
