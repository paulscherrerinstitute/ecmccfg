#-d /**
#-d   \brief hardware script for EL6624-Sensor-Clear All Pdos
#-d   \details Parmetrization of all channels as inputs. Setup pdos
#-d   \author Anders Sandstroem
#-d   \file
#-d    \pre ECMC_EC_SLAVE_NUM   Slave number
#-d */

#- Clear all Outputs
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x0,0,1)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x1,0,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x2,0,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x3,0,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x4,0,2)"

#- Clear all Inputs
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x0,0,1)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x1,0,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x2,0,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x3,0,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x4,0,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x5,0,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x6,0,2)"
