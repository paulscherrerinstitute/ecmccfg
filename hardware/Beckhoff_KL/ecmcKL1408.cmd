#-d /**
#-d   \brief hardware script for KL1408
#-d   \details 8ch 24V digital input
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

epicsEnvSet("ECMC_EC_HWTYPE"             "KL1408")

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x1,B1,BK_S${ECMC_KL_SLAVE_NUM}_BI_1)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x2,B1,BK_S${ECMC_KL_SLAVE_NUM}_BI_2)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x3,B1,BK_S${ECMC_KL_SLAVE_NUM}_BI_3)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x4,B1,BK_S${ECMC_KL_SLAVE_NUM}_BI_4)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x5,B1,BK_S${ECMC_KL_SLAVE_NUM}_BI_5)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x6,B1,BK_S${ECMC_KL_SLAVE_NUM}_BI_6)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x7,B1,BK_S${ECMC_KL_SLAVE_NUM}_BI_7)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60${ECMC_KL_SLAVE_NUM}0,0x8,B1,BK_S${ECMC_KL_SLAVE_NUM}_BI_8)"
