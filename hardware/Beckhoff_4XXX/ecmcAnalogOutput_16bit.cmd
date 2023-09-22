#-d /**
#-d   \brief  script for analog output channel
#-d   \details This script maps PDO matching the pattern below \n
#-d   \author Anders Sandström
#-d   \file
#-d   \note Macros
#-d   \param CH_ID       Channel ID, default 1, internally converted to two digit zero padded hex
#-d   \param ECMC_PDO    PDO, default 0x1600
#-d   \param ECMC_ENTRY  PDO entry, default 0x7000
#-d   \param ECMC_ENTRY_OFFSET  PDO entry offset, default 0x1
#-d   \param SYNC_MAN    Sync manager, default 2
#-d */

#- Convert to hex value with zero padding
ecmcEpicsEnvSetCalc("ECMC_CHANNEL",${CH_ID=01},"%02x")

#- analog input channel with status
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,${SYNC_MAN=2},${ECMC_PDO=0x1600},${ECMC_ENTRY=0x7000},${ECMC_ENTRY_OFFSET=0x1},S16,analogOutput${CH_ID})"
