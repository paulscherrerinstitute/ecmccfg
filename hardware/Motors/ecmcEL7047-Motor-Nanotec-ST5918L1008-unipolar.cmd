#-d /**
#-d   \brief hardware script for EL7047-Motor-Nanotec-ST5918L1008 (unipolar wiring)
#-d   \details Parmetrization of EL7047 for motor Nanotec ST5918L1008 (unipolar wiring)
#-d   \author Anders Sandstroem
#-d   \author Carlos Doro Neto
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Nanotec-ST5918L1008-unipolar.cmd

#- Nominal voltage up to 48V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#- Coil inductance 15.4mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,1540,2)"
