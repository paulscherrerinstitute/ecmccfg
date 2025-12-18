#==============================================================================
# loadYamlAxis.cmd
#-d /**
#-d   \brief Script for loading Axis from yaml file via `jinja2`
#-d   \details adds an Axis, based on a yaml config file
#-d   \author Niko Kivel, Anders Sandström, Felix Maier
#-d   \file
#-d   \param FILE the yaml-file containing the PLC definition
#-d   \param DEV  the device name (optional, defaults to ${IOC}), automatically appended with a `:`
#-d   \param PREFIX  the device PREFIX, will _NOT_ be appended with a `:`
#-d   \note Example calls:
#-d   \note - call
#-d   \code
#-d     ${SCRIPTEXEC} "./loadYamlAxis.cmd" "FILE=./axis1.yaml"
#-d     ${SCRIPTEXEC} "./loadYamlAxis.cmd" "FILE=./axis1.yaml, DEV=foobar"
#-d     ${SCRIPTEXEC} "./loadYamlAxis.cmd" "FILE=./axis1.yaml, PREFIX=MTEST-STEPPER:X:"
#-d   \endcode
#-d */

on error halt
ecmcFileExist("${FILE}",1)
epicsEnvSet(FILE_TEMP_1,${ECMC_TMP_DIR}${FILE}_1)
epicsEnvSet(FILE_TEMP_2,${ECMC_TMP_DIR}${FILE}_2)
epicsEnvSet(FILE_TEMP_3,${ECMC_TMP_DIR}${FILE}_3)


# step 1: get filename (need to check if filename contains other macros also). Basically run the filename in this iocsh
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

# step 2: Set plc.file (write new yaml file)
ecmcIf("'$(ECMC_CFG_TOOL=jinja)'=='ecb'")
  ${IF_TRUE}ecb --yaml ${FILE} --action updatekey --key plc.file --value ${ECMC_PLC_FILENAME=} --output ${FILE_TEMP_2}
#- else
  ${IF_FALSE}system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}ecmcPlcSetFileName.py ${FILE} ${FILE_TEMP_2} ${ECMC_PLC_FILENAME=}"
ecmcEndIf()

ecmcFileExist("${FILE_TEMP_2}",1)

#- cleanup
epicsEnvUnset(ECMC_PLC_FILENAME)


#- step 3: parse yaml file
ecmcIf("'$(ECMC_CFG_TOOL=jinja)'=='ecb'")
  ${IF_TRUE}ecb --yaml ${FILE_TEMP_2} --schemafile ${ECMC_CONFIG_ROOT}ecbSchema.json --schema axis --template ${ECMC_CONFIG_ROOT}axis_main.jinja2 --templatedir ${ECMC_CONFIG_ROOT} --output ${FILE_TEMP_3}
#- else
  #- setup python venv and run `plcYamlJinja2.py` must be in the same 'system'-context
  ${IF_FALSE}system ". ${ECMC_CONFIG_ROOT}pythonVenv.sh -d ${ECMC_TMP_DIR}; python ${ECMC_CONFIG_ROOT}axisYamlJinja2.py -d ${ECMC_TMP_DIR} -T ${ECMC_CONFIG_ROOT} -D ${FILE_TEMP_2} -o ${FILE_TEMP_3}"
ecmcEndIf()

#- cleanup
system "rm -rf ${FILE_TEMP_2}"
epicsEnvUnset(FILE_TEMP_2)

#- set device name, default to ${IOC}
epicsEnvSet("ECMC_PREFIX"      "${PREFIX=${DEV=${IOC}}:}")

#- check for ECMC-format PLC file and load the PLC
ecmcFileExist("${FILE_TEMP_3}",1)
#- system "cat ${FILE_TEMP_3}"
${SCRIPTEXEC} "${FILE_TEMP_3}"

#- cleanup
system "rm -rf ${FILE_TEMP_3}"
epicsEnvUnset(FILE_TEMP_3)


#- reset PREFIX
epicsEnvSet("ECMC_PREFIX"      "${SM_PREFIX}")

ecmcEpicsEnvSetCalc(ECMC_AXIS_COUNT, "$(ECMC_AXIS_COUNT=0)+1")
