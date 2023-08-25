#-d /**
#-d   \brief hardware script for EL7332-ch1-Motor-Maxon-115146
#-d   \details Parametrization of EL7332 Ch 1 for Maxon-115146
#-d   Rated voltage            : 24V
#-d   Rated power              : 2W
#-d   Rated current            : 83mA
#-d   Velocity without load    : 680Rpm
#-d   Gear ratio               : 1:19
#-d   Coil resistance          : ?
#-d   Rated Torque             : 300 Nmm
#-d   Flange size              : 16mm
#-d
#-d   ECMC_EC_SDO_ID: SDO address 0x802 for Channel 1
#-d   ECMC_EC_SDO_ID: SDO address 0x803 for Channel 2
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_ID",              "0x802")
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd, "SLAVE_ID=$(ECMC_EC_SLAVE_NUM), HW_DESC=EL7332, CONFIG=-chx-Motor-Maxon-115146"
