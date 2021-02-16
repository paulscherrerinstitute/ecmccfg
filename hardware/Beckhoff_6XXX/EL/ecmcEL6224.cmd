#-d /**
#-d   \brief hardware script for EL6224
#-d   \details I/O link master terminal
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL6224")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x18503052")

#- verify slave, including reset
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- 0x_C = Device diag
#- 0x_F = Device state
#ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0xf101,0x0D,B1,DEV_DIAG)"
#ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0xf101,0x10,B1,DEV_STATE)"

#- 0x_1 = Port in std dig in
#- 0x_2 = Port in std dig out
#- 0x_3 = Port in communikation OP
#- 0x_4 = Port in communikation COMSTOP
#- 0x1_ = Watchdog detected
#- 0x2_ = internal Error
#- 0x3_ = invalid Device ID
#- 0x4_ = invalid Vendor ID
#- 0x5_ = invalid IO-Link Version
#- 0x6_ = invalid Frame Capability
#- 0x7_ = invalid Cycle Time
#- 0x8_ = invalid PD in length
#- 0x9_ = invalid PD out length
#- 0xA_ = no Device detected

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0xf100,0x01,U8,status01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0xf100,0x02,U8,status02)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0xf100,0x03,U8,status03)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0xf100,0x04,U8,status04)"
