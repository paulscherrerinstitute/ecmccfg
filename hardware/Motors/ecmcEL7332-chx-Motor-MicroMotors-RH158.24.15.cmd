#-d /**
#-d   \brief hardware script for EL7332-chx-Motor-MicroMotors-RH158.24.15
#-d   \details Parametrization of EL7332 Ch x for MicroMotors-RH158.24.15
#-d   Motor rated voltage      : 24V
#-d   Current at nominal load  : 330mA
#-d   Current without load     : 70mA
#-d   Velocity at nominal load : 300Rpm
#-d   Velocity without load    : 440Rpm
#-d   Gear ratio               : 1:14.14
#-d   Coil resistance          : ?
#-d
#-d   ECMC_EC_SDO_ID: SDO address 0x802 for Channel 1
#-d   ECMC_EC_SDO_ID: SDO address 0x803 for Channel 2
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- Set max current to 100mA (Not sure what max current is)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x1,350,2)"

#- Nominal current 50mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x2,330,2)"

#- Nominal voltage 24V (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x3,24000,2)"

#- Coil resistance Not defined in data sheet. Leave as default Ohm (unit 10mOhm)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x4,450,2)"

#- Reduced current positive 100mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x5,100,2)"

#- Reduced current negative 100mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x6,100,2)"

#- Nominal speed of teh motor at nominal voltage 300rpm
#- Not accessible for EL7332. probably accessible for EL7432
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x8,300,2)"

#- Kp control factor of the current controller (default 200)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}1,0x1,200,2)"

#- Ki control factor of the current controller (default 2)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}1,0x2,2,2)"

#- Note: More settings are accessible in 0x80x1.
