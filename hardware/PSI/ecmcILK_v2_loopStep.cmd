#- ecmcForLoop file for ILK
#-
#-  Loop macro:
#-    IDX  : Loop variable 1..buffer size
#-
#-  Static macros (same for entire for loop):
#-    CH_ID          : Channel id

#- Convert to hex value with zero padding
ecmcEpicsEnvSetCalc("ECMC_ENTRY_OFFSET_HEX_VALUE",${IDX}+1,"%02x")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},${DIR=1},${SM=2},${PDO},${ENTRY},0x${ECMC_ENTRY_OFFSET_HEX_VALUE},${TYPE},${KEY}${IDX})"
