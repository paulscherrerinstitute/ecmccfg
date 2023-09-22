#-d /**
#-d   \brief hardware script for KL2032
#-d   \details 2ch 24V digital output, 0.5A
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

epicsEnvSet("ECMC_EC_HWTYPE"             "KL2032")

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x1,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7${ECMC_KL_SLAVE_NUM}0,0x2,B1,KL${ECMC_KL_SLAVE_NUM}_binaryOutput02)"
#- Make a 14 bit byte align dummy to fill up (U8+B4+B2 = 14 bits)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x1701,0x1,U8,KL${ECMC_KL_SLAVE_NUM}_notConneted01,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x1701,0x9,B4,KL${ECMC_KL_SLAVE_NUM}_notConneted02,0)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x1701,0x13,B2,KL${ECMC_KL_SLAVE_NUM}_notConneted03,0)"
