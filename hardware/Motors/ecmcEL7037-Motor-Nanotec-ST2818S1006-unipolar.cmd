#-d /**
#-d   \brief hardware script for EL7037-Motor-Nanotec-ST2818S1006 (unipolar or bipolar 1 winding wiring)
#-d   \details Parametrization of EL7037 for motor Nanotec ST2818S1006 (unipolar or bipolar 1 winding wiring)
#-d   \author Javier Cereijo Garcia
#-d   \file
#-d */

#- Load common config from EL7047
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7047-Motor-Nanotec-ST2818S1006-unipolar.cmd

#- Nominal voltage 24V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,2400,2)"
