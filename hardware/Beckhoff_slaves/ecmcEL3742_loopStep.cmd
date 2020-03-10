#- ecmcForLoop file for EL3742 oversampling PDOS
#- 
#-  Loop macro: 
#-    ECMC_LOOP_IDX    : Loop variable 1..OVERSAMPLING_FACTOR
#-
#-  Static macros (same for entire for loop): 
#-  CH_ID            : Channel id
#-  PDO_OFFSET       : PDO Offset value
#-  PDO_ENTRY_OFFSET : PDO entry offset
#-  SYNC_MAN         : Sync manager

#- Convert to hex value with zero padding (subtract one since addresses start from 0)
ecmcEpicsEnvSetCalc("ECMC_ENTRY_HEX_VALUE",${ECMC_LOOP_IDX}-1,"%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_HEX_VALUE",${ECMC_LOOP_IDX}-1+${PDO_OFFSET},"%02x")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,${SYNC_MAN},0x1a${ECMC_PDO_HEX_VALUE},0x6${ECMC_ENTRY_HEX_VALUE}0,0x${PDO_ENTRY_OFFSET},S16,CH${CH_ID}_VALUE_${ECMC_LOOP_IDX},0)"
