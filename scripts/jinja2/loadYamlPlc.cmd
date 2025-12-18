#==============================================================================
# loadYamlPlc.cmd
#-d /**
#-d   \brief Script for loading PLC from yaml file via `jinja2`
#-d   \details adds a PLC, line by line, from a yaml-file, parsed by `jinja2`
#-d   \author Niko Kivel, Anders Sandström, Felix Maier
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
ecmcFileExist("${FILE}",1)
epicsEnvSet(FILE_TEMP_1,${ECMC_TMP_DIR}{FILE}_1)
epicsEnvSet(FILE_TEMP_2,${ECMC_TMP_DIR}{FILE}_2)
epicsEnvSet(FILE_TEMP_3,${ECMC_TMP_DIR}{FILE}_3)

# Step 1: Get Filename (need to check if filename contains other macros also). Basically run the filename in this iocsh
ecmcIf("'$(ECMC_CFG_TOOL=jinja)'=='ecb'")
  ${IF_TRUE}ecb --yaml ${FILE} --action readkey --key plc.file --output ${FILE_TEMP_1}
  ${IF_TRUE}system '[ ! -s ${FILE_TEMP_1} ] || sed -i "s/^\(.*\)$/epicsEnvSet(ECMC_PLC_FILENAME, \"\1\")\n/" ${FILE_TEMP_1}'
  ${IF_TRUE}system '[   -s ${FILE_TEMP_1} ] || echo "epicsEnvSet(ECMC_PLC_FILENAME, \"NONE\")\n" >> ${FILE_TEMP_1}'
#- else
  ${IF_FALSE}system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}ecmcPlcGetFileName.py ${FILE} ${FILE_TEMP_1}"
ecmcEndIf()

# PLC filename with expanded macros:
#- system "cat ${FILE_TEMP_1}"
${SCRIPTEXEC} "${FILE_TEMP_1}"
epicsEnvShow(ECMC_PLC_FILENAME)

#- cleanup
system "rm -rf ${FILE_TEMP_1}"
epicsEnvUnset(FILE_TEMP_1)

# Step 2: Set plc.file (write new yaml file)
ecmcIf("'$(ECMC_CFG_TOOL=jinja)'=='ecb'")
  ${IF_TRUE}ecb --yaml ${FILE} --action updatekey --key plc.file --value ${ECMC_PLC_FILENAME=} --output ${FILE_TEMP_2}
#- else
  ${IF_FALSE}system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}ecmcPlcSetFileName.py ${FILE} ${FILE_TEMP_2} ${ECMC_PLC_FILENAME=}"
ecmcEndIf()

ecmcFileExist("${FILE_TEMP_2}",1)

#- cleanup
epicsEnvUnset(ECMC_PLC_FILENAME)


#- Step 3: parse yaml file
ecmcIf("'$(ECMC_CFG_TOOL=jinja)'=='ecb'")
  ${IF_TRUE}ecb --yaml ${FILE_TEMP_2} --schemafile ${ECMC_CONFIG_ROOT}ecbSchema.json --schema plc --template ${ECMC_CONFIG_ROOT}plc.jinja2 --templatedir ${ECMC_CONFIG_ROOT} --output ${FILE_TEMP_3}
#- else
  #- setup python venv and run `plcYamlJinja2.py` must be in the same 'system'-context
  ${IF_FALSE}system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}plcYamlJinja2.py -d ${ECMC_TMP_DIR} -T ${ECMC_CONFIG_ROOT} -D ${FILE_TEMP_2} -o ${FILE_TEMP_3}"
ecmcEndIf()

#- cleanup
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

#- reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "${SM_PREFIX}")

ecmcEpicsEnvSetCalc(ECMC_PLC_COUNT, "$(ECMC_PLC_COUNT=0)+1")
