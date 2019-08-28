############################################################
############# Information:
# Description: EL7041-1000 stepper drive (24V,5A)
# Niko Kivel, PSI
#
############################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL7041-1000")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b813052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x01,16,ENC_CONTROL)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x11,16,VALUE)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1602,0x7010,0x1,16,STM_CONTROL)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1604,0x7010,0x21,16,1,VELOCITY_SETPOINT)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x0,16,ENC_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,16,POSITION)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x12,16,LATCH_POSITION)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6010,0x1,16,STM_STATUS)"

#-----------------------------------------------------------
# Index 7010 STM Outputs Ch.1
#
# 7010:03 Reduce torque
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x7010,0x3,1,1)"

#-----------------------------------------------------------
# Index 8012 STM Features Ch.1
#
# 8012:01 Operation mode

# 8012:08 Feedback type
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x8,0,1)"

# 8012:09 Invert motor polarity
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x9,0,1)"

# 8012:30 Invert digital input 1

# 8012:31 Invert digital input 2

# 8012:32 Function for input 1

# 8012:36 Function for input 2

# 8012:45 Microstepping
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x45,6,1)"

#-----------------------------------------------------------
# Index 8014 STM Motor Settings 2 Ch.1
#
# 8014:01 Acceleration (maximum) [max 2047]
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8014,0x1,2047,2)"

# 8014:02 Acceleration threshold (a_th) [max 1023]
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8014,0x2,1023,2)"

# 8014:03 Coil current (a > a,th)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8014,0x3,100,1)"

# 8014:04 Coil current (a < a,th)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8014,0x4,50,1)"

# 8014:05 Coil current (v = 0, auto) [in percent of Imax of the driver, 5 A in this case!!!]
# 0 --> cuts power completely, make sure holding torque is enough to prevent spinning!
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8014,0x5,0,1)"

# 8014:06 Coil current (v = 0, manual) [in percent of Imax of the driver, 5 A in this case!!!]
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8014,0x6,50,1)"
