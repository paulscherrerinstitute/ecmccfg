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
epicsEnvUnset(ECMC_SLAVE_VERIFY)

#- reset terminal
ecmcEpicsEnvSetCalcTernary(ECMC_SLAVE_RESET, "${RESET=0}>0", "","#- ")
${ECMC_SLAVE_RESET}ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"
