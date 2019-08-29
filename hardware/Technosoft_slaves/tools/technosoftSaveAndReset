############# Save:
ecmcConfig "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2076,0x0,1,2)"
# Wait for save done
epicsThreadSleep(1)
# Save status
ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x208A,0x0,2)"
epicsThreadSleep(0.1)
# Save status
ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x208A,0x0,2)"
epicsThreadSleep(0.1)
# Save status
ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x208A,0x0,2)"
epicsThreadSleep(0.1)

############# Reset:
# NOTE: Reset drive command will return error -5 since no repsonse is sent back to the master! The drive will be reset anyway 
# Therefore "ecmcConfig" is used instead of "ecmcConfigOrDie" ("ecmcConfig" will not go to error state).
ecmcConfig "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2080,0x0,1,2)"
epicsThreadSleep(1)
# Wait for drive to reset
epicsThreadSleep(1)
# Wait for drive to reset
epicsThreadSleep(1)

