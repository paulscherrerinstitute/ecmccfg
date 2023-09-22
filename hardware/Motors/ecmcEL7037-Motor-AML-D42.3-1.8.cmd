#-d /**
#-d   \brief hardware script for EL7037-Motor-AML-D42.3-1.8
#-d   \details Parametrization of EL7037 for motor AML-D42.3-1.8
#-d   Specs:
#-d     Holding torque:        450 mNm
#-d     Detent torque:         20 mNm
#-d     Rotor inertia :        102 gcm²
#-d     Max axial force:       9N
#-d     Max radial force:      15N
#-d     Mass:                  610g
#-d     Max current per phase: 1.0A
#-d     Phase resistance:      8.5 Ohm
#-d     Phase inductance:      19.5 mH
#-d     Vacuum environment:    <1x10-10 mbar
#-d     Operating temperature: -65°C to +175°C
#-d     Temperature sensor:    Type ‘K’ thermocouple standard or PT100 optional
#-d     Bakeout temperature:   200°C
#-d     Step angle:            1.8°
#-d     Step angle tolerance:  ±5%
#-d     Lead length:           1.5m
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- Motor max 1000mArms
epicsEnvSet(I_MAX_MA_LOCAL,"1000")
epicsEnvSet(I_RUN_MA_LOCAL,${I_RUN_MA=610})
epicsEnvSet(I_STDBY_MA_LOCAL,${I_STDBY_MA=87})

#- Ensure valid current settings
ecmcFileExist("${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd "I_RUN_MA=${I_RUN_MA_LOCAL},I_STDBY_MA=${I_STDBY_MA_LOCAL},I_MAX_MA=${I_MAX_MA_LOCAL}"

#- Set run current
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,${I_RUN_MA_LOCAL},2)"

#- Reduced current
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,${I_STDBY_MA_LOCAL},2)"

#- Nominal voltage 24V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,2400,2)"

#- Coil resistance 8.5 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,850,2)"

#- Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#- Coil inductance 19.5mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,1950,2)"

#- Cleanup
epicsEnvUnset("I_RUN_MA_LOCAL")
epicsEnvUnset("I_STDBY_MA_LOCAL")
epicsEnvUnset("I_MAX_MA_LOCAL")
