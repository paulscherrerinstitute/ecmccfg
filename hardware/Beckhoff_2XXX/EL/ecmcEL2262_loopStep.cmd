#- ecmcForLoop file for EL2262 oversampling PDOs
#- ECMC_LOOP_IDX is the byte number, starting at one.

#- ESI: PDO 0x1800/0x1880, object 0x7200 incremented by eight per byte.
ecmcEpicsEnvSetCalc("ECMC_ENTRY_HEX_VALUE","512+(${ECMC_LOOP_IDX}-1)*8","%03x")
ecmcEpicsEnvSetCalc("ECMC_PDO_HEX_VALUE","6144+${ECMC_LOOP_IDX}-1+${PDO_OFFSET}","%04x")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,${SYNC_MAN},0x${ECMC_PDO_HEX_VALUE},0x7${ECMC_ENTRY_HEX_VALUE},0x${PDO_ENTRY_OFFSET},U8,binaryOutputArray${CH_ID}_${ECMC_LOOP_IDX},0)"
