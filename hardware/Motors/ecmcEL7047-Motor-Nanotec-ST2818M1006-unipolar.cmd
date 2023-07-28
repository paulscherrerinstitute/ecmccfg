#-d /**
#-d   \brief hardware script for EL7047-Motor-Nanotec-ST2818M1006 (unipolar or bipolar 1 winding wiring)
#-d   \details Parmetrization of EL7047 for motor Nanotec ST2818M1006 (unipolar or bipolar 1 winding wiring)
#-d   \file
#-d */

#- Load common config from EL7041
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7041-Motor-Nanotec-ST2818M1006-unipolar.cmd

#- Nominal voltage up to 48V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#- Coil inductance 1.2mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,120,2)"
