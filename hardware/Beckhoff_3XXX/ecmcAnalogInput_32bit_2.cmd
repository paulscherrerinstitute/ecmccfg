#-d /**
#-d   \brief  script for analog input channel with status word
#-d   \details This scripr maps PDO matching the pattern below \n
#-d     TxPDO 0x1a00 "PAI TxPDO-Map Status Ch.1"
#-d       PDO entry 0x6000:01,  8 bit, "No of Samples"
#-d       PDO entry 0x6000:09,  1 bit, "Error"
#-d       PDO entry 0x6000:0a,  1 bit, "Underrange"
#-d       PDO entry 0x6000:0b,  1 bit, "Overrange"
#-d       PDO entry 0x0000:00,  1 bit, "Gap"
#-d       PDO entry 0x6000:0d,  1 bit, "Diag"
#-d       PDO entry 0x6000:0e,  1 bit, "TxPDO State"
#-d       PDO entry 0x6000:0f,  2 bit, "Input cycle counter"
#-d       PDO entry 0x0000:00, 16 bit, "Gap"
#-d     TxPDO 0x1a01 "PAI TxPDO-Map Samples 1 Ch.1"
#-d       PDO entry 0x6001:01, 32 bit, "SubIndex 001"
#-d   \author Niko Kivel
#-d   \file
#-d   \note Macros
#-d   \param CH_ID       Channel ID, default 1, internally converted to two digit zero padded hex
#-d   \param PDO    PDO, default 0xa100
#-d   \param ECMC_ENTRY  PDO entry, default 0x6000
#-d   \param SYNC_MAN    Sync manager, default 3
#-d */

#- Convert to hex value with zero padding
ecmcEpicsEnvSetCalc("ECMC_CHANNEL",${CH_ID=1},"%02x")

#- analog input channel with status
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SYNC_MAN=3},${PDO_0=0x1a00},${ENTRY_0=0x6000},0x01,U32,status${ECMC_CHANNEL})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SYNC_MAN=3},${PDO_1=0x1a01},${ENTRY_1=0x6001},0x01,S32,analogInput${ECMC_CHANNEL})"
