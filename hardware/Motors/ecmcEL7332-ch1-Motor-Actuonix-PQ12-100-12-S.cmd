#-d /**
#-d   \brief hardware script for EL7332-ch1-Actuonix-PQ12-100-12-S.cmd
#-d   \details Parmetrization of EL7332 Ch 1 for Actuonix-PQ12-100-12-S.cmd
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
#-d
#-d   ECMC_EC_SDO_ID: SDO address 0x802 for Channel 1
#-d   ECMC_EC_SDO_ID: SDO address 0x803 for Channel 2
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_ID",              "0x802")
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd, "SLAVE_ID=$(ECMC_EC_SLAVE_NUM), HW_DESC=EL7332, CONFIG=-chx-Motor-Actuonix-PQ12-100-12-S"
