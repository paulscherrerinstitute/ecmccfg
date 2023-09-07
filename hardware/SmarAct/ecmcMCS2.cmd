#-d /**
#-d   \brief hardware script for MCS2
#-d   \details SmarAct MCS2 piezo controller with EtherCAT interface
#-d   \author Niko Kivel, Anders Sandström
#-d   \file
#-d   \note SDOS
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "MCS2")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x00536d61")                                          
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x00020d08")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- Consider read which channels are deteced in 0xf050?!

#- mandatory setting of 0xF030, which subseqently defines SM2 and SM3
#- use Cfg.EcWriteSdo, this needs to happen at I->P
#- TODO: clarify which mechanism actually ensures that this happens at I->P.

#- ensure PREOP state
system "{ECMC_EC_TOOL_PATH} states -m${ECMC_EC_MASTER_ID} -p${ECMC_EC_SLAVE_NUM} PREOP"
epicsSleep(0.5)

epicsEnvSet("ECMC_SDO_INDEX",              "0xF030")
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x00040000,4)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x00040000,4)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x3,0x00040000,4)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(),0x0,3,1)"

#- Go to INIT
system "${ECMC_EC_TOOL_PATH} states -m${ECMC_EC_MASTER_ID} -p${ECMC_EC_SLAVE_NUM} INIT"
epicsSleep(0.5)

#- and then back to PREOP
system "${ECMC_EC_TOOL_PATH} states -m${ECMC_EC_MASTER_ID} -p${ECMC_EC_SLAVE_NUM} PREOP"
epicsSleep(0.5)

#- SyncManager 2
#- 0x1601 "csp/csv RxPDO"
#- CH1
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x6040,0x00,16,driveControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x6060,0x00,16,mode01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x607a,0x00,32,1,positionSetpoint01)"

#- 0x1641 "csp/csv RxPDO"
#- CH2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1641,0x6840,0x00,16,driveControl02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1641,0x6860,0x00,16,mode02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1641,0x687a,0x00,32,1,positionSetpoint02)"

#- 0x1681 "csp/csv RxPDO"
#- CH3
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1681,0x7040,0x00,16,driveControl03)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1681,0x7060,0x00,16,mode03)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1681,0x707a,0x00,32,1,positionSetpoint03)"

#- SyncManager 3
#- 0x1a01 "csp/csv TxPDO"
#- CH2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6061,0x00,16,modeActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6041,0x00,16,driveStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6064,0x00,32,1,positionActual01)"

#- 0x1a41 "csp/csv TxPDO"
#- CH2
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a41,0x6861,0x00,16,modeActual02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a41,0x6841,0x00,16,driveStatus02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a41,0x6864,0x00,32,1,positionActual02)"

#- 0x1a81 "csp/csv TxPDO"
#- CH3
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x7061,0x00,16,modeActual03)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x7041,0x00,16,driveStatus03)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x7064,0x00,32,1,positionActual03)"


#- For some reason the 0x6060 does not exist?! Why...
#- Activly choose CSP mode
#- set mode to 8, aka CSP
#- -1 Calibration
#-  0 None
#-  1 Profile Position
#-  6 Homing
#-  8 Cyclic Synchronous Position
#- CH1
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6060,0x00,8,1)"
#- CH2
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6860,0x00,8,1)"
#- CH3
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x7060,0x00,8,1)"

#- Set position resolution to 1/1000
#- CH1
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x608F,0x01,1000,4)"
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x608F,0x02,1,4)"
#
##- CH2
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x688F,0x01,1000,4)"
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x688F,0x02,1,4)"
#
##- CH3
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x708F,0x01,1000,4)"
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x708F,0x02,1,4)"
