#-d /**
#-d   \brief  script for slave verification and optional reset
#-d   \details will verify the slave identity and reset by writing to 0x1011, optionally read firmwre version from 0x100a
#-d   \author Niko Kivel
#-d   \file
#-d   \note Macros
#-d   \param RESET    macro to enable reset, defaults to 0 --> no reset
#-d   \param READ_FW  macro to enable a firmware check, defaults to 0 --> no firmware read out
#-d */

#- verify slave identity
ecmcEpicsEnvSetCalcTernary(SLAVE_VERIFY, "${ECMC_DEV_MODE=0}==0","","#- ")
${SLAVE_VERIFY}ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- reset terminal
ecmcEpicsEnvSetCalcTernary(SLAVE_RESET, "${RESET=0}>0","","#- ")
${SLAVE_VERIFY}${SLAVE_RESET}ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

#- read firmware version
ecmcEpicsEnvSetCalcTernary(SLAVE_FW, "${READ_FW=0}>0","","#- ")
${SLAVE_VERIFY}${SLAVE_FW}ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x100a,0x0,2)"
${SLAVE_VERIFY}${SLAVE_FW}ecmcEpicsEnvSetCalc("ECMC_EC_SLAVE_FW", "${ECMC_CONFIG_RETURN_VAL=0}", "0x%04x")
${SLAVE_VERIFY}${SLAVE_FW}Firmware version: ${ECMC_EC_SLAVE_FW=0}

#- reset envitronment
epicsEnvUnset(SLAVE_VERIFY)
epicsEnvUnset(SLAVE_RESET)
epicsEnvUnset(SLAVE_FW)

