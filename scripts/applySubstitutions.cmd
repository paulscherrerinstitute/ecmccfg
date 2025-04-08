#==============================================================================
# applySubstitutions.cmd
#- Arguments: SUBST_FILE, ECMC_P

#-d /**
#-d   \brief Script for applying substitution file
#-d   \details Applies substitution from ${SUBST_FILE} with ${P_SCRIPT}
#-d   \author Niko Kivel
#-d   \file
#-d   \param SUBST_FILE substitution file
#-d   \param ECMC_P PV prefix
#-d   \param SUBST_FILE (optional) substitution file
#-d   \param P_SCRIPT (optional) naming convention prefix script
#-d   \param NELM (optional) Used for oversampling cards. Defaults to 1
#-d   \note Example calls:
#-d   \note - call w/o SLAVE_ID
#-d   \code
#-d     ${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}applySubstitutions.cmd" "SUBST_FILE=${SUBST_FILE=ecmc${ECMC_EC_HWTYPE}.substitutions},ECMC_P=${ECMC_P}"
#-d   \endcode
#-d   \pre It's advisable to run a script to defince ECMC_P before.
#-d   \todo TODO: for v7.0.0_RC1, substitute 'P=${ECMC_PREFIX}' by 'P=${ECMC_P}', needs all templates to be migrated before!
#-d */

ecmcFileExist(${SUBST_FILE},1,1)
#- TODO: for v7.0.0_RC1, substitute 'P=${ECMC_PREFIX}' by 'P=${ECMC_P}', needs all templates to be migrated before!
dbLoadTemplate(${SUBST_FILE},"P=${ECMC_PREFIX},ECMC_P=${ECMC_P},ECMC_G=${ECMC_G=},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,MASTER_ID=${ECMC_EC_MASTER_ID},SLAVE_POS=${ECMC_EC_SLAVE_NUM},HWTYPE=${ECMC_EC_HWTYPE},T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE},NELM=${NELM=1}")
