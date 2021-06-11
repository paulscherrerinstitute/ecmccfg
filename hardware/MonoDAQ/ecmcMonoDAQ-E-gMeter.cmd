#-d /**
#-d   \brief hardware script for MonoDAQ-E-gemeter
#-d   \details MonoDAQ triaxial accelerometer
#-d   \author Niko Kivel
#-d   \note https://www.monodaq.com/ethercat/triaxial-accelerometer-labview/
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "MonoDAQ-E-gMeter")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x0001DA7A")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x000000A2")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=false"

# Raw data select
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x03,20992,2)"
# BufferedInput
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x07,16896,2)"

#- device
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6001,0x01,U16,counter01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6001,0x02,F32,temperature01)"

#- X axis
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a60,0x6060,0x01,F32,accelerometer01)"
#- Y axis
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a61,0x6061,0x01,F32,accelerometer02)"
#- Z axis
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a62,0x6062,0x01,F32,accelerometer03)"

#- ############ Distributed clocks config:
#- SYNC0: enabled, cycle time = 1 µs, shift time = 0
#- SYNC1: enabled, cylce time = 1 ms, shift time = 0
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,1000,0,1000000,0)"
