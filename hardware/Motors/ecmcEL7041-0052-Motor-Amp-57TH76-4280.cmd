#-d /**
#-d   \brief hardware script for EL7041-0052-Motor-Amp-57TH76-4280
#-d   \details Parametrization of EL7041-0052 for motor Amp-57TH76-4280
#-d   \author Anders Sandstrom
#-d   \file
#-d */

#- Set max current to 2500 mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,2800,2)"

#- Reduced current 500 mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,100,2)"


#- Coil resistance 80 x 10⁻²Ω
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,113,2)"


#- Coil inductance 290 x 10⁻⁵H - NOT USED FOR EL7041
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,290,2)"
