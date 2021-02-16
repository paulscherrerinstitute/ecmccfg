#-d /**
#-d   \brief hardware script for KL2809
#-d   \details 16ch 24V digital output, 0.5A
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
#-d   \author Anders Sandstroem, Markus Kristensson
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "KL2809")

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x1,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x2,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput02)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x3,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput03)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x4,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput04)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x5,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput05)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x6,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput06)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x7,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput07)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x8,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput08)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x9,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput09)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x10,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput10)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x11,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput11)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x12,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput12)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x13,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput13)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x14,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput14)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x15,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput15)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x16,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput16)"
