#- ecmcForLoop file for EL3632 oversampling PDOS
#- 
#-  Loop macro: 
#-    ECMC_LOOP_IDX  : Loop variable 1..OVERSAMPLING_FACTOR
#-
#-  Static macros (same for entire for loop): 
#-    CH_ID          : Channel id
#-    PDO_OFFSET     : PDO Offset value
#-    PDO_ENTRY_LAST_2_DIGITS : Last two digits of PDO entry (Ch1 =01, Ch2=11)

#- Convert to hex value with zero padding (subtract one since addresses start from 0)
ecmcEpicsEnvSetCalc("ECMC_ENTRY_OFFSET_HEX_VALUE",${ECMC_LOOP_IDX},"%02x")
ecmcEpicsEnvSetCalc("ECMC_PDO_HEX_VALUE",${ECMC_LOOP_IDX}+${PDO_OFFSET},"%02x")

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_PDO_HEX_VALUE},0x60${PDO_ENTRY_LAST_2_DIGITS},0x${ECMC_ENTRY_OFFSET_HEX_VALUE},S16,analogInputArray${CH_ID}_${ECMC_LOOP_IDX},0)"
