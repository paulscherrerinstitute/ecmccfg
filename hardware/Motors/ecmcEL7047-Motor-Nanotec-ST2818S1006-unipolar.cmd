#-d /**
#-d   \brief hardware script for EL7047-Motor-Nanotec-ST2818S1006 (unipolar or bipolar 1 winding wiring)
#-d   \details Parametrization of EL7047 for motor Nanotec ST2818S1006 (unipolar or bipolar 1 winding wiring)
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Nanotec-ST2818S1006-unipolar.cmd

#- Nominal voltage up to 48V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#- Coil inductance 1mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,100,2)"
