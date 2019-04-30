${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}${HW_DESC}.cmd

# Add Memory map object to access an memory area of the EtherCAT process image (200bytes starting form and including "CH1_VALUE_1" resulting in an array containing CH1_VALUE_1 to CH1_VALUE_100)
ecmcConfigOrDie "Cfg.EcAddMemMap(${ECMC_EC_SLAVE_NUM},CH1_VALUE_1,200,2,ec$(ECMC_EC_MASTER_ID).mm.CH1_ARRAY)"
ecmcAsynPortDriverAddParameter(${ECMC_ASYN_PORT},"ec${ECMC_EC_MASTER_ID}.mm.CH1_ARRAY","asynInt16ArrayIn",${ECMC_ASYN_SKIP_CYCLES})
ecmcAsynPortDriverAddParameter(${ECMC_ASYN_PORT},"ec${ECMC_EC_MASTER_ID}.s${ECMC_EC_SLAVE_NUM}.CH1_CYCLE_CNT","asynInt32",${ECMC_ASYN_SKIP_CYCLES})

# Add Memory map object to access an memory area of the EtherCAT process image (200bytes starting form and including "CH2_VALUE_1" resulting in an array containing CH2_VALUE_1 to CH2_VALUE_100)
ecmcConfigOrDie "Cfg.EcAddMemMap(${ECMC_EC_SLAVE_NUM},CH2_VALUE_1,200,2,ec$(ECMC_EC_MASTER_ID).mm.CH2_ARRAY)"
ecmcAsynPortDriverAddParameter(${ECMC_ASYN_PORT},"ec${ECMC_EC_MASTER_ID}.mm.CH2_ARRAY","asynInt16ArrayIn",${ECMC_ASYN_SKIP_CYCLES})
ecmcAsynPortDriverAddParameter(${ECMC_ASYN_PORT},"ec${ECMC_EC_MASTER_ID}.s${ECMC_EC_SLAVE_NUM}.CH2_CYCLE_CNT","asynInt32",${ECMC_ASYN_SKIP_CYCLES})

dbLoadTemplate("ecmcEL37X2_100.substitutions","P=${ECMC_PREFIX}, PORT=${ECMC_ASYN_PORT}, ADDR=${ECMC_ASYN_ADDR}, TIMEOUT=${ECMC_ASYN_TIMEOUT}, MASTER_ID=${ECMC_EC_MASTER_ID}, SLAVE_POS=${ECMC_EC_SLAVE_NUM}, HWTYPE=${ECMC_EC_HWTYPE}")
