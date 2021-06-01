#- ecmcForLoop file for EL3632 oversampling PDOS
#-
#-  Loop macro:
#-    IDX  : Loop variable 1..OVERSAMPLING_FACTOR
#-
#-  Static macros (same for entire for loop):
#-    CH_ID          : Channel id
#-    PDO_OFFSET     : PDO Offset value
#-    PDO_ENTRY_LAST_2_DIGITS : Last two digits of PDO entry (Ch1 =01, Ch2=11)

#- Convert to hex value with zero padding (subtract one since addresses start from 0)
ecmcEpicsEnvSetCalc("ECMC_ENTRY_OFFSET_HEX_VALUE",${IDX},"%02x")
ecmcEpicsEnvSetCalc("CH_ID",${IDX},"%02d")

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},${DIR=1},${SM=2},${PDO},${ENTRY},0x${ECMC_ENTRY_OFFSET_HEX_VALUE},${TYPE},${KEY}${CH_ID},0)"
