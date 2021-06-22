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
#-d   \pre jinja2 has to be in the PATH
#-d */

#- python3 virtual env (credits Maciej Patro)
system "cp ${ECMC_CONFIG_ROOT}requirements.txt ${ECMC_TMP_DIR}"
system "${ECMC_CONFIG_ROOT}pythonVenvJinja2.sh -d ${ECMC_TMP_DIR} -t ${ECMC_CONFIG_ROOT}plc.jinja2 -D ${FILE} -o ${ECMC_TMP_DIR}${FILE}.plc"

#- call jinja2
#- system "jinja2 ${ECMC_CONFIG_ROOT}plc.jinja2 ${FILE} -o /tmp/${FILE}.plc"

#- check for ECMC-format PLC file and load the PLC
ecmcFileExist("${ECMC_TMP_DIR}${FILE}.plc",1)
${SCRIPTEXEC} "${ECMC_TMP_DIR}${FILE}.plc"

#- cleanup
system "rm -rf ${ECMC_TMP_DIR}${FILE}.plc"
