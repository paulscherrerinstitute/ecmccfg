#-d /**
#-d   \brief  script for slave verification and optional reset
#-d   \details will verify the slave identity and reset by writing to 0x1011
#-d   \author Niko Kivel
#-d   \file
#-d   \note Macros
#-d   \param RESET       macro to enable reset, defaults to 0 --> no reset
#-d */

#- verify slave identity
ecmcEpicsEnvSetCalcTernary(ECMC_SLAVE_VERIFY, "${ECMC_DEV_MODE=0}==0", "","#- ")
${ECMC_SLAVE_VERIFY}ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- reset terminal
ecmcEpicsEnvSetCalcTernary(ECMC_SLAVE_RESET, "${RESET=0}>0", "","#- ")
${ECMC_SLAVE_VERIFY}${ECMC_SLAVE_RESET}ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

#- Read firmware version
${ECMC_SLAVE_VERIFY}${ECMC_SLAVE_RESET}ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x100a,0x0,2)"
${ECMC_SLAVE_VERIFY}${ECMC_SLAVE_RESET}ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_FW", "${ECMC_CONFIG_RETURN_VAL=0}", "0x%04x")
${ECMC_SLAVE_RESET}${ECMC_COMMENT=#} Firmware version: ${ECMC_EC_SLAVE_FW=0}

#- Reset
epicsEnvUnset(ECMC_SLAVE_VERIFY)
epicsEnvUnset(ECMC_COMMENT)
