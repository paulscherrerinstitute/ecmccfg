#-d /**
#-d   \brief hardware script for EL3174_+-20mA
#-d   \details 4-channel analog input, -10/0…+10 V, -20/0/+4…+20 mA, 16 bit
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d   \note Selected range: +-20mA (actually +-21.474mA)
#-d   \todo migrate to ecmccfg
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3174_+-20mA")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0c663052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############  Reset terminal
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"

#- ############ Config PDOS: Channel 1
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,16,CH1_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,16,1,CH1_VALUE)"

#-  Set signal type to +-10V
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x800D")
< ../hardware/ecmc$(ECMC_EC_HWTYPE)-Sensor-chX

#- ############ Config PDOS: Channel 2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x6010,0x1,16,CH2_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x6010,0x11,16,1,CH2_VALUE)"

#-  Set signal type to +-10V
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x801D")
< ../hardware/ecmc$(ECMC_EC_HWTYPE)-Sensor-chX

#- ############ Config PDOS: Channel 3
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6020,0x1,16,CH3_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6020,0x11,16,1,CH3_VALUE)"

#-  Set signal type to +-10V
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x802D")
< ../hardware/ecmc$(ECMC_EC_HWTYPE)-Sensor-chX

#- ############ Config PDOS: Channel 4
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a06,0x6030,0x1,16,CH4_STATUS)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a06,0x6030,0x11,16,1,CH4_VALUE)"

#-  Set signal type to +-10V
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x803D")
< ../hardware/ecmc$(ECMC_EC_HWTYPE)-Sensor-chX
