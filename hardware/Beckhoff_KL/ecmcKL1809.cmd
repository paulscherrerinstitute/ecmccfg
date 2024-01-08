#-d /**
#-d   \brief hardware script for El1809
#-d   \details 16ch 24V digital input
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
#-d                          Must always be a 2 digit hex number (without "0x").. Example: "1A" for slave 26(decimal)
#-d   - ECMC_EC_VENDOR_ID  : The vendor id of BK1250 (or similar)
#-d   - ECMC_EC_PRODUCT_ID : The product id of BK1250 (or similar)
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "KL1809")

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x1,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x2,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput02)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x3,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput03)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x4,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput04)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x5,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput05)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x6,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput06)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x7,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput07)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x8,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput08)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x9,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput09)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0xA,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput10)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0xB,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput11)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0xC,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput12)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0xD,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput13)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0xE,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput14)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0xF,B1,KL${ECMC_KL_SLAVE_NUM}_binaryInput15)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x10,B1,KLS${ECMC_KL_SLAVE_NUM}_binaryInput16)"
