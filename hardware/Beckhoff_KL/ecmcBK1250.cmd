#-d /**
#-d   \brief hardware script for BK1250
#-d   \details BK1250, EtherCAT coupler for KL terminals, using K-bus (not ethercat)
#-d   \note This is not an EtherCAT slave and needs to be configured
#-d   togheter with an BK1250 or similar.
#-d   The BL1250 coupler automatically scans the bus and generates pdos for the terminals downstream.
#-d   Terminals are adressed by their position relative the BK1250 starting with
#-d   the first KL slave with at index 0.
#-d   Outputs of KL slaves are mapped to SM2 pdo index 0x60<ECMC_KL_SLAVE_NUM>0 (for slave "00" => 0x6000, slave "1A" 0x61A0...)
#-d   Inputs of KL slaves are mapped to SM3 pdo index 0x70<ECMC_KL_SLAVE_NUM>0 (for slave "00" => 0x7000, slave "1B" 0x71B0...)
#-d   Note that all these pdo entries are accessed through the BK1250 coupler (with slave id ECMC_EC_SLAVE_NUM).
#-d   Needed environment vars:
#-d   - ECMC_EC_SLAVE_NUM  : The slave number of the BK1250
#-d   - ECMC_KL_SLAVE_NUM  : The slave number of the KL terminal starting at "00" at the first terminal _after_ the BK1250
#-d                          Must always be a 2 digit hex number (without "0x").. Example: "1A" for slave 26(decimal))
#-d   - ECMC_EC_VENDOR_ID  : The vendor id of BK1250 (or similar)
#-d   - ECMC_EC_PRODUCT_ID : The product id of BK1250 (or similar)
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "BK1250")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x04e22c22")

${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- Status word
#- 0x0001 = K-Bus error
#- 0x0002 = Configuration error
#- 0x0010 = Outputs disabled
#- 0x0020 = K-Bus overrun
#- 0x0040 = Communication error (Inputs)
#- 0x0080 = Communication error (Outputs)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1aff,0xf100,0x1,U16,status)"

#- Control word
#- 0x0010 = Disable outputs
#- 0x0020 = Show K-Bus overrun
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16ff,0xf200,0x1,U16,control)"
