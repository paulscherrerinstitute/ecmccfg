############################################################
############# Information:
# Description: 2-channel analog input terminal for Condition Monitoring (IEPE) with oversampling
# Oversampling factor = 5
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3632_s5")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0xe303052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#############################################

# CH 1
# Configuration for sync manager 3
# Configuration for pdoIndex 6656
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,16,CH1_STATUS)"

# Configuration for pdoIndex 6657
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6001,0x1,16,sm3.p1.e0,0)"
# Configuration for pdoIndex 6658
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x6001,0x2,16,sm3.p2.e0,0)"
# Configuration for pdoIndex 6659
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6001,0x3,16,sm3.p3.e0,0)"
# Configuration for pdoIndex 6660
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6001,0x4,16,sm3.p4.e0,0)"
# Configuration for pdoIndex 6661
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6001,0x5,16,sm3.p5.e0,0)"

# CH 2
# Configuration for pdoIndex 6720
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a40,0x6010,0x1,16,CH2_STATUS)"
# Configuration for pdoIndex 6721
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a41,0x6011,0x1,16,sm3.p52.e0,0)"
# Configuration for pdoIndex 6722
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a42,0x6011,0x2,16,sm3.p53.e0,0)"
# Configuration for pdoIndex 6723
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a43,0x6011,0x3,16,sm3.p54.e0,0)"
# Configuration for pdoIndex 6724
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a44,0x6011,0x4,16,sm3.p55.e0,0)"
# Configuration for pdoIndex 6725
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a45,0x6011,0x5,16,sm3.p56.e0,0)"

#Cfg.EcSlaveConfigDC(
#      int slave_bus_position,
#      uint16_t assign_activate,
#      uint32_t sync0_cycle,
#      int32_t sync0_shift,
#      uint32_t sync1_cycle,
#      int32_t sync1_shift )*/
# Configure DC clock 20000ns update for oversampling (5 values oversampling in 1kHz)
#ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,20000,-832000,1000000,0)"


