#-d /**
#-d   \brief  script for analog input channel with status word
#-d   \details This scripr maps PDO matching the pattern below \n
#-d     TxPDO 0x1a01 "AI TxPDO-Map Inputs Ch.1"
#-d       PDO entry 0x6020:01,  1 bit, "Underrange"
#-d       PDO entry 0x6020:02,  1 bit, "Overrange"
#-d       PDO entry 0x6020:03,  2 bit, "Limit 1"
#-d       PDO entry 0x6020:05,  2 bit, "Limit 2"
#-d       PDO entry 0x6020:07,  1 bit, "Error"
#-d       PDO entry 0x0000:00,  7 bit, "Gap"
#-d       PDO entry 0x6020:0f,  1 bit, "TxPDO State"
#-d       PDO entry 0x6020:10,  1 bit, "TxPDO Toggle"
#-d       PDO entry 0x6020:11, 32 bit, "Value"
#-d   \author Niko Kivel
#-d   \file
#-d   \note Macros
#-d   \param CH_ID       Channel ID, default 1, internally converted to two digit zero padded hex
#-d   \param ECMC_PDO    PDO, default 0xa100
#-d   \param ECMC_ENTRY  PDO entry, default 0x6000
#-d   \param SYNC_MAN    Sync manager, default 3
#-d */

#- Convert to hex value with zero padding
ecmcEpicsEnvSetCalc("ECMC_CHANNEL",${CH_ID=1},"%02x")

#- analog input channel with status
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SYNC_MAN=3},${ECMC_PDO=0x1a00},${ECMC_ENTRY=0x6000},0x01,U16,status${ECMC_CHANNEL})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SYNC_MAN=3},${ECMC_PDO=0x1a00},${ECMC_ENTRY=0x6000},0x11,S32,analogInput${ECMC_CHANNEL})"
