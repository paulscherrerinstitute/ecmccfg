#-d /**
#-d   \brief  script for analog input channel with status word
#-d   \details This scripr maps PDO matching the pattern below \n
#-d           SM3: PhysAddr 0x1900, DefaultSize   30, ControlRegister 0x20, Enable 1 \n
#-d             TxPDO 0x1a00 "DIG TxPDO-Map Inputs" \n
#-d               PDO entry 0x6000:01,  1 bit, "Input 1" \n
#-d               PDO entry 0x6000:02,  1 bit, "Input 2" \n
#-d               PDO entry 0x6000:03,  1 bit, "Input 3" \n
#-d               PDO entry 0x6000:04,  1 bit, "Input 4" \n
#-d               PDO entry 0x6000:05,  1 bit, "Input 5" \n
#-d               PDO entry 0x6000:06,  1 bit, "Input 6" \n
#-d               PDO entry 0x0000:00, 10 bit, "Gap" \n
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
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SYNC_MAN=3},${ECMC_PDO=0x1a00},${ECMC_ENTRY=0x6000},0x11,S16,analogInput${ECMC_CHANNEL})"
