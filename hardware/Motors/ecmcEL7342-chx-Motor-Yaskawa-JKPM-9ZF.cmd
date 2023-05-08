#-d /**
#-d   \brief hardware script for EL7342-chx-Motor-Yaskawa-JKPM-9ZF
#-d   \details Parmetrization of EL7332 Ch x for Motor-Yaskawa-JKPM-9ZF
#-d   Rated voltage            : 12V
#-d   Rated power              :
#-d   Rated current            : 80mA      No data
#-d   Velocity without load    : 1000Rpm   no data
#-d   Coil resistance          : Measured appr0x 100Ohm (varies with angels du to brush)
#-d   Rated Torque             : No idea
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
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x4,10000,2)"

#- Reduced current positive 100mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x5,20,2)"

#- Reduced current negative 100mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x6,20,2)"

#- Nominal speed of teh motor at nominal voltage 300rpm 
#- Not accessible for EL7332. probably accessible for EL7432
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}0,0x8,1000,2)"

#- Kp control factor of the current controller (default 200)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}1,0x1,200,2)"

#- Ki control factor of the current controller (default 2)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_ID}1,0x2,2,2)"

#- Note: More settings are accessible in 0x80x1
