#-d /**
#-d   \brief hardware script for EL6624-Sensor-setup-pdos-OOII.cmd
#-d   \details Parametrization:
#-d      0..1 outputs
#-d      2..3 input
#-d   \author Anders Sandstroem
#-d   \file
#-d    \pre ECMC_EC_SLAVE_NUM   Slave number
#-d */

#- Clear all pdos
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL6224-Sensor-clear-pdos.cmd

#- Add inputs
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x1,0x1A04,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x2,0x1A02,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x3,0x1A03,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x0,3,1)"

#- Add outputs
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x1,0x1600,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x2,0x1601,2)"

ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x0,2,1)"
