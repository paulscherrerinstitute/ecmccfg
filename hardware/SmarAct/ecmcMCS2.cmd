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
system "${ECMC_EC_TOOL_PATH} states -m${ECMC_EC_MASTER_ID} -p${ECMC_EC_SLAVE_NUM} PREOP"
#- epicsThreadSleep(0.5)

epicsEnvSet("ECMC_SDO_INDEX",              "0xF030")
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x00040000,4)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x00040000,4)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x3,0x00040000,4)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,3,1)"

#- Go to INIT
system "${ECMC_EC_TOOL_PATH} states -m${ECMC_EC_MASTER_ID} -p${ECMC_EC_SLAVE_NUM} INIT"
#- epicsThreadSleep(0.5)

#- and then back to PREOP
system "${ECMC_EC_TOOL_PATH} states -m${ECMC_EC_MASTER_ID} -p${ECMC_EC_SLAVE_NUM} PREOP"
#- epicsThreadSleep(0.5)

#- SyncManager 2
#- 0x1601 "csp/csv RxPDO"
#- CH1
epicsEnvSet(ECMC_MCS2_CHID,01)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x6040,0x00,16,driveControl${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x6060,0x00,16,mode${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x607a,0x00,32,1,positionSetpoint${ECMC_MCS2_CHID})"
#- Add bits for exe device specific cmds: driveControl01.4
ecmcConfigOrDie "Cfg.EcAddDataDT(ec${ECMC_EC_MASTER_ID=0}.s${ECMC_EC_SLAVE_NUM}.driveControl${ECMC_MCS2_CHID},0,4,1,B1,driveCmdExe${ECMC_MCS2_CHID})"

#- 0x1641 "csp/csv RxPDO"
#- CH2
epicsEnvSet(ECMC_MCS2_CHID,02)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1641,0x6840,0x00,16,driveControl${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1641,0x6860,0x00,16,mode${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1641,0x687a,0x00,32,1,positionSetpoint${ECMC_MCS2_CHID})"
#- Add bits for exe device specific cmds: driveControl02.4
ecmcConfigOrDie "Cfg.EcAddDataDT(ec${ECMC_EC_MASTER_ID=0}.s${ECMC_EC_SLAVE_NUM}.driveControl${ECMC_MCS2_CHID},0,4,1,B1,driveCmdExe${ECMC_MCS2_CHID})"

#- 0x1681 "csp/csv RxPDO"
#- CH3
epicsEnvSet(ECMC_MCS2_CHID,03)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1681,0x7040,0x00,16,driveControl${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1681,0x7060,0x00,16,mode${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1681,0x707a,0x00,32,1,positionSetpoint${ECMC_MCS2_CHID})"
#- Add bits for exe device specific cmds: driveControl03.4
ecmcConfigOrDie "Cfg.EcAddDataDT(ec${ECMC_EC_MASTER_ID=0}.s${ECMC_EC_SLAVE_NUM}.driveControl${ECMC_MCS2_CHID},0,4,1,B1,driveCmdExe${ECMC_MCS2_CHID})"

#- SyncManager 3
#- 0x1a01 "csp/csv TxPDO"
#- CH1
epicsEnvSet(ECMC_MCS2_CHID,01)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6061,0x00,16,modeActual${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6041,0x00,16,driveStatus${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6064,0x00,32,1,positionActual${ECMC_MCS2_CHID})"
#- Add bits for exe device specific cmds: driveStatus01.10 (1 byte 3 bits)
#-ecmcConfigOrDie "Cfg.EcAddDataDT(ec${ECMC_EC_MASTER_ID=0}.s${ECMC_EC_SLAVE_NUM}.driveStatus${ECMC_MCS2_CHID},1,2,2,B1,driveCmdDone${ECMC_MCS2_CHID})"
#- Check final control word (after applying data items)
ecmcConfigOrDie "Cfg.EcAddDataDT(ec${ECMC_EC_MASTER_ID=0}.s${ECMC_EC_SLAVE_NUM}.driveControl${ECMC_MCS2_CHID},0,0,2,U16,driveControl${ECMC_MCS2_CHID}_RB)"

#- 0x1a41 "csp/csv TxPDO"
#- CH2
epicsEnvSet(ECMC_MCS2_CHID,02)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a41,0x6861,0x00,16,modeActual${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a41,0x6841,0x00,16,driveStatus${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a41,0x6864,0x00,32,1,positionActual${ECMC_MCS2_CHID})"
#- Add bits for exe device specific cmds: driveStatus02.10 (1 byte 3 bits)
#- ecmcConfigOrDie "Cfg.EcAddDataDT(ec${ECMC_EC_MASTER_ID=0}.s${ECMC_EC_SLAVE_NUM}.driveStatus${ECMC_MCS2_CHID},1,2,2,B1,driveCmdDone${ECMC_MCS2_CHID})"
#- Check final control word (after applying data items)
ecmcConfigOrDie "Cfg.EcAddDataDT(ec${ECMC_EC_MASTER_ID=0}.s${ECMC_EC_SLAVE_NUM}.driveControl${ECMC_MCS2_CHID},0,0,2,U16,driveControl${ECMC_MCS2_CHID}_RB)"

#- 0x1a81 "csp/csv TxPDO"
#- CH3
epicsEnvSet(ECMC_MCS2_CHID,03)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x7061,0x00,16,modeActual${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x7041,0x00,16,driveStatus${ECMC_MCS2_CHID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x7064,0x00,32,1,positionActual${ECMC_MCS2_CHID})"
#- Add bits for exe device specific cmds: driveStatus03.10 (1 byte 3 bits)
#-ecmcConfigOrDie "Cfg.EcAddDataDT(ec${ECMC_EC_MASTER_ID=0}.s${ECMC_EC_SLAVE_NUM}.driveStatus${ECMC_MCS2_CHID},1,2,2,B1,driveCmdDone${ECMC_MCS2_CHID})"
#- Check final control word (after applying data items)
ecmcConfigOrDie "Cfg.EcAddDataDT(ec${ECMC_EC_MASTER_ID=0}.s${ECMC_EC_SLAVE_NUM}.driveControl${ECMC_MCS2_CHID},0,0,2,U16,driveControl${ECMC_MCS2_CHID}_RB)"


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
