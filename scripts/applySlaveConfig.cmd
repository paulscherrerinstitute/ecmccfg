#===============================================================================
# applySlaveConfig.cmd
# Arguments: CONFIG _or_ LOCAL_CONFIG

#-d /**
#-d   \brief Script for applying a specific slave configuration after the slave had been added manually.
#-d   \details Apply configurations to a slave.
#-d   \author Niko Kivel
#-d   \file
#-d   \note Example call:
#-d   \note call applySlaveConfig with CONFIG
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd, "CONFIG=-Motor-Nanotec-ST4118L1804-B"
#-d   \endcode
#-d   \note call applySlaveConfig with LOCAL_CONFIG
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd, "LOCAL_CONFIG=./myFancyServoConfig.cfg"
#-d   \endcode
#-d */
#-d   \pre A slave has to added immediately before this script is called by \b addSlave.cmd.

#- use LOCAL_CONFIG, else use CONFIG which has to be in ECMC_CONFIG_ROOT
epicsEnvSet("ECMC_CONFIG_FN", "${LOCAL_CONFIG=${ECMC_CONFIG_ROOT}ecmc${HW_DESC}${CONFIG}.cmd}")

ecmcFileExist("${ECMC_CONFIG_FN}",1)
${SCRIPTEXEC} ${ECMC_CONFIG_FN}

#- Settings done for ch1 and ch2 (this is not bullet proof, please switch to ecmccomp)
ecmcConfigOrDie "Cfg.EcSetSlaveSDOSettingsDone(${ECMC_EC_SLAVE_NUM},1,1)"
ecmcConfigOrDie "Cfg.EcSetSlaveSDOSettingsDone(${ECMC_EC_SLAVE_NUM},2,1)"
