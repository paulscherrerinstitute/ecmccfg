epicsEnvSet("ECMC_EC_HWTYPE",        "EP1918-0002")
epicsEnvSet("ECMC_EC_VENDOR_ID",     "0x00000002")
epicsEnvSet("ECMC_EC_PRODUCT_ID",    "0x077e4052")

#- verify slave
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,0)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#***************** OUTPUTS FROM MASTER
#- RxPDO Mapping Connection 001
# FSoE_Command
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7040,0x01,U8,fsoe_cmd_out_01)"
# FSoE Data
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7002,0x01,U8,fsoe_data_out_01)"

# FSoE CRC
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7040,0x03,U16,fsoe_crc_out_01)"

# FSoE ConnectionID
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7040,0x02,U16,fsoe_conn_id_out_01)"

# Standard in var 1 and 4 
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17f0,0x6000,0x01,U8,std_vars_out_01)"

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x17ff,0x0000,0x00,U16,fsoe_logic_out_01)"

#***************** INPUTS TO MASTER
#- TxPDO Mapping Connection 001
# FSoE Command
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6040,0x01,U8,fsoe_cmd_in_01)"

# FSoE Data: Module 1 Channel 1/2 Input, Module Fault
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6041,0x01,U8,fsoe_data_in_01)"

# FSoE CRC
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6040,0x03,U16,fsoe_crc_in_01)"

# FSoE Connection ID
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6040,0x02,U16,fsoe_conn_id_in_01)"

# FSoE Device Status: SafeLogicState and CycleCounter
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1bff,0xf100,0x01,U8,fsoe_state_in_01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1bff,0xf100,0x02,U8,fsoe_cycle_counter_in_01)"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "EP1918-0002")
