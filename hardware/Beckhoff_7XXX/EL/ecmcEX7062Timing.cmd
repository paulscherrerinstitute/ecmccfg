#-d /**
#-d   \brief Shared ED7062/EL7062 input timing metadata
#-d   \details Apply after the EX7062 distributed-clock configuration.
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- The normal position PDO timing was calibrated on ED7062 CSV and is shared
#- by the ED7062/EL7062 CSV, CSP, and TPDC configurations because they use the
#- same DC schedule and input PDO layout. This describes input timing only;
#- CSP output timing is a separate property.
#-
#- At zero SYNC0 shift the effective normal-position sample is approximately
#- receive time - 1 application cycle - 45 us. The acquisition phase follows
#- SYNC0, so include the configured shift in the effective input offset.
ecmcEpicsEnvSetCalc("ECMC_TEMP_TIMING_IN_OFFSET_NS","-45000+(${SYNC_0_SHIFT=0})")
ecmcConfigOrDie "Cfg.EcSetSlaveTimingSource(${ECMC_EC_SLAVE_NUM},2,0)"
ecmcConfigOrDie "Cfg.EcSetSlaveTimingOverride(${ECMC_EC_SLAVE_NUM},2,-1,${ECMC_TEMP_TIMING_IN_OFFSET_NS},31250)"
epicsEnvUnset(ECMC_TEMP_TIMING_IN_OFFSET_NS)
