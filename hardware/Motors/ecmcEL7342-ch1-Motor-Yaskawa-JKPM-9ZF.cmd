#-d /**
#-d   \brief hardware script for EL7332-ch1-Motor-Yaskawa-JKPM-9ZF
#-d   \details Parmetrization of EL7332 Ch 1 for Yaskawa-JKPM-9ZF
#-d   Rated voltage            : 12V
#-d   Rated power              :
#-d   Rated current            : 80mA      No data
#-d   Velocity without load    : 1000Rpm   no data
#-d   Coil resistance          : Measured appr0x 100Ohm (varies with angels du to brush)
#-d   Rated Torque             : No idea
#-d
#-d   ECMC_EC_SDO_ID: SDO address 0x802 for Channel 1
#-d   ECMC_EC_SDO_ID: SDO address 0x803 for Channel 2
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_SDO_ID",              "0x802")
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveConfig.cmd, "SLAVE_ID=$(ECMC_EC_SLAVE_NUM), HW_DESC=EL7342, CONFIG=-chx-Motor-Yaskawa-JKPM-9ZF"
