#==============================================================================
# applyTemplate.cmd
#- Arguments: TEMPLATE_FILE, ECMC_P, [PARAMS]

#-d /**
#-d   \brief Script for applying a template
#-d   \details Applies template from ${TEMPLATE_FILE} with ${P_SCRIPT}, PARAMS can be passed
#-d   \author Niko Kivel
#-d   \file
#-d   \param TEMPLATE_FILE template file
#-d   \param ECMC_P PV prefix
#-d   \param PARAMS (optional) additional parameters
#-d   \note Example calls:
#-d   \note - call w/o SLAVE_ID
#-d   \code
#-d     ${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}applyTemplate.cmd" "TEMPLATE_FILE=ecmcEcSlave.template,ECMC_P=${ECMC_P}"
#-d   \endcode
#-d   \pre It's advisable to run a script to defince ECMC_P before.
#-d */

ecmcFileExist(${TEMPLATE_FILE},1,1)
dbLoadRecords("${TEMPLATE_FILE}", "ECMC_P=${ECMC_P},ECMC_G=${ECMC_G=},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,MASTER_ID=${ECMC_EC_MASTER_ID},SLAVE_POS=${ECMC_EC_SLAVE_NUM},HWTYPE=${ECMC_EC_HWTYPE},T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},${PARAM=}, PREV_SLAVE_NUM=${ECMC_EC_PREV_SLAVE_NUM=-1},PANEL=$(ECMC_HW_PANEL=GenericSlave)")
