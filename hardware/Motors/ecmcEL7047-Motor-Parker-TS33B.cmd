#-d /**
#-d   \brief hardware script for EL7047-Motor-Parker-TS33B
#-d   \details Parametrization of EL7047 for motor Parker TS33B with series wiring
#-d   \author Niko Kivel
#-d   \file
#-d   \note Torque: 10.7 Nm
#-d   \note Phase Current: 4.0 A rms, 5.6 A peak
#-d   \note steps per revolution: 200
#-d   \note Resistence: 1.45 Ohm (measured, no data in datasheet)
#-d   \note Inductance: 13.6 mH
#-d   \note Voltge: 170 VDC
#-d */

#- Set max current 4 A (unit 1 mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,4000,2)"

#- Reduced current 2 A (unit 1 mA)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,2000,2)"

#- Nominal voltage 48 V (unit 10 mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,4800,2)"

#- Coil resistance 1.45 Ohm (unit 10 mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,145,2)"

#- Motor full steps count 200 - step angle degree: 1.8 deg
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#- Coil inductance 13.6 mH (unit 0.01 mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,1360,2)"
