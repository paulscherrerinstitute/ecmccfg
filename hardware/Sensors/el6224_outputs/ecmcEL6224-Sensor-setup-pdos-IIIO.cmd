#-d /**
#-d   \brief hardware script for EL6624-Sensor-setup-pdos-IIIO.cmd
#-d   \details Parmetrization:
#-d      3    outputs 
#-d      0..2 inputs
#-d   \author Anders Sandstroem
#-d   \file
#-d    \pre ECMC_EC_SLAVE_NUM   Slave number
#-d */

#- Clear all pdos
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL6224-Sensor-clear-pdos.cmd

#- Add inputs
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x1,0x1A04,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x2,0x1A00,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x3,0x1A01,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x4,0x1A02,2)"

ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x0,4,1)"

#- Add outputs
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x1,0x1603,2)"

ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x0,1,1)"
