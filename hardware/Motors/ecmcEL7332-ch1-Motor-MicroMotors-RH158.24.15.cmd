#-d /**
#-d   \brief hardware script for EL7332-ch1-Motor-MicroMotors-RH158.24.15
#-d   \details Parametrization of EL7332 Ch 1 for MicroMotors-RH158.24.15
#-d   Motor rated voltage      : 24V
#-d   Current at nominal load  : 330mA
#-d   Current without load     : 70mA
#-d   Velocity at nominal load : 300Rpm
#-d   Velocity without load    : 440Rpm
#-d   Gear ratio               : 1:14.14
#-d   Coil resistance          : ?
#-d   
#-d   SDO address 0x802x for Channel 1
#-d   
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_ID",              "0x802")
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd, "SLAVE_ID=$(ECMC_EC_SLAVE_NUM), HW_DESC=EL7332, CONFIG=-chx-Motor-MicroMotors-RH158.24.15"
