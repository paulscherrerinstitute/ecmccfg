#-d /**
#-d   \brief hardware script for EL3202-0010
#-d   \details 2 channel PT100 temperature sensor input  (selectable range and other configs for sensors as SDO)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d   \note Selected range: +-10V (actually +-10.737V)
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: 2 channel PT100 temperature sensor input  (selectable range and other configs for sensors as SDO
#-
#-  Bits: 16
#-  Connection: 4-wire
#-
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3202-0010")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0c823052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

#- ############ Config PDOS: Channel 1
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "1")
epicsEnvSet("ECMC_EC_PDO"                "0x1a00")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6000")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-chX-analogInput.cmd

#- ############ Config PDOS: Channel 2
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "2")
epicsEnvSet("ECMC_EC_PDO"                "0x1a01")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6010")

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL32XX-chX-analogInput.cmd

epicsEnvUnset("ECMC_EC_CHANNEL_ID")
epicsEnvUnset("ECMC_EC_PDO")
epicsEnvUnset("ECMC_EC_PDO_ENTRY")
