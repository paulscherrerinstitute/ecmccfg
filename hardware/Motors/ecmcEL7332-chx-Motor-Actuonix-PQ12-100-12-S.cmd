#-d /**
#-d   \brief hardware script for EL7332-chx-Motor-Actuonix-PQ12-100-12-S.cmd
#-d   \details Parametrization of EL7332 Ch x for Actuonix-PQ12-100-12-S.cmd
#-d   Rated voltage            : 12V
#-d   Rated power              : 2W
#-d   Peak power point         : 40N @ 6mm/s
#-d   Peak efficiency point    : 20N @ 8mm/s
#-d   Rated current            : 210mA
#-d   Velocity without load    : 10mm/s
#-d   Max force                : 50N
#-d   Max side load            : 10N
#-d   Back drive force         : 35N
#-d   Max duty cycle           : 20%
#-d   Coil resistance          : ?
#
#-d   ECMC_EC_SDO_ID: SDO address 0x802 for Channel 1
#-d   ECMC_EC_SDO_ID: SDO address 0x803 for Channel 2
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- Set max current to 100mA (Not sure what max current is)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x1,100,2)"

#- Nominal current 50mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x2,80,2)"

#- Nominal voltage 12V (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x3,12000,2)"

#- Coil resistance Not defined in data sheet. Leave as default Ohm (unit 10mOhm)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x4,450,2)"

#- Reduced current positive 100mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x5,50,2)"

#- Reduced current negative 100mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x6,50,2)"

#- Nominal speed of the motor at nominal voltage
#- Not accessible for EL7332. probably accessible for EL7432
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x8,680,2)"

#- Kp control factor of the current controller (default 200)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}1,0x1,200,2)"

#- Ki control factor of the current controller (default 2)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}1,0x2,2,2)"

#- Note: More settings are accessible in 0x80x1
