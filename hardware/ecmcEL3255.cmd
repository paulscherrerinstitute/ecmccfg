############################################################
############# Information:
# Description: 5 channel potentiometer input
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3255")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0cb73052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

############# Config PDOS: Channel 1
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "1")
epicsEnvSet("ECMC_EC_PDO"                "0x1a00")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6000")

< ../hardware/ecmcEL32XX-chX-analogInput

############# Config PDOS: Channel 2
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "2")
epicsEnvSet("ECMC_EC_PDO"                "0x1a02")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6010")

< ../hardware/ecmcEL32XX-chX-analogInput

############# Config PDOS: Channel 3
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "3")
epicsEnvSet("ECMC_EC_PDO"                "0x1a04")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6020")

< ../hardware/ecmcEL32XX-chX-analogInput

############# Config PDOS: Channel 4
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "4")
epicsEnvSet("ECMC_EC_PDO"                "0x1a06")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6030")

< ../hardware/ecmcEL32XX-chX-analogInput

############# Config PDOS: Channel 5
epicsEnvSet("ECMC_EC_CHANNEL_ID"         "5")
epicsEnvSet("ECMC_EC_PDO"                "0x1a08")
epicsEnvSet("ECMC_EC_PDO_ENTRY"          "0x6040")

< ../hardware/ecmcEL32XX-chX-analogInput
