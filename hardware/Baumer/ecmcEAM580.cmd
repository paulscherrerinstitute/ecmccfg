#-d /**
#-d   \brief generic hardware script for Baumer EAM580
#-d   \details Encoder with EtherCAT interface
#-d   \author Niko Kivel
#-d   \file
#-d
#-d   Macros:
#-d     ECMC_EC_SLAVE_NUM         : Slave number
#-d     ECMC_EC_MASTER_ID         : Master id
#-d     ECMC_EC_SAMPLE_RATE       : EtherCAT sampling rate [Hz] (set in startup.cmd)
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EAM580")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x000000ec")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x00000300")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############ Config PDOS: Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6004,0x00,U32,ENC_POSITION)"
