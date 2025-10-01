#-d /**
#-d   \brief hardware script for iPOSXXXX for voltage mode
#-d   \details
#-d   \author Anders Sandstroem
#-d   \file
#-d */

# WARNING THIS CONFIGURATION IS ONLY INTENDED FOR MODE VES (PURE VOLTAGE MODE), MOST OF THE PDOS are not working

epicsEnvSet("ECMC_EC_HWTYPE"             "iPOS4808BX_VOLT")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x000001a3")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x01a0c82d")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#############################################################
############# Configure PDOS:

epicsEnvSet("ECMC_CH_ID",              "01")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6040,0x0,16,driveControl${ECMC_CH_ID})"
# NOT USED in voltage mode (MODE VES)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x60FF,0x0,32,1,dummyVeloSet${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x60FE,0x1,32,binaryOutputArray${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x60FE,0x2,32,binaryOutputArrayMask${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1602,0x2067,0x0,32,1,tmlComIF${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6041,0x0,16,driveStatus${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6064,0x0,32,positionActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6077,0x0,16,1,currentActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60FD,0x0,32,binaryInputArray${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x2045,0x0,16,binaryOutputArrayReadBack${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2046,0x0,16,analogInput01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2047,0x0,16,analogInput02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2055,0x0,16,voltageActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2058,0x0,16,temperatureActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6063,0x0,32,positionActual02)"
epicsEnvUnset(ECMC_CH_ID)

#- Ensure drive gets some SDO settings
ecmcConfigOrDie "Cfg.EcSetSlaveNeedSDOSettings(${ECMC_EC_SLAVE_NUM},1,1)"

#- MAP EREF(h) as voltage setpoint
# Special for access of EREF (output voltage)
# CFG
# 0084=16 bit cfg
# 02A9 is the address of EREF(H)
# => write 0x2064 0x0 0x02A90084
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2064,0x0,0x02A90084,4)"
${SCRIPTEXEC} ${ecmccfg_DIR}addEcDataItem.cmd "STRT_ENTRY_NAME=tmlComIF01,OFFSET_BYTE=2,OFFSET_BITS=0,RW=1,DT=U16,NAME=TML-ComCfgIF01"
#- This is actuall the output voltage setpoint corresponfing to the velo setpoint (record loaded in subst later)
${SCRIPTEXEC} ${ecmccfg_DIR}addEcDataItem.cmd "STRT_ENTRY_NAME=tmlComIF01,OFFSET_BYTE=0,OFFSET_BITS=0,RW=1,DT=S16,NAME=velocitySetpoint01, LOAD_RECS='#-'"
#- Write adress 0x02A9 = 
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM},TML-ComCfgIF01,681)"
#- Now direct access to EREF should be possible through DATA_IF_DATA_01

# The tml trigger function cannot be mapped as PDO so need SDO async
#- Trigger this TML function (1) every time drive is beeing enabled:
#- EXTREF 0  // Take value from EREF(h)
#- MODE VES  // Pure volateg mode
#- UPD       // Update (use settings)
${SCRIPTEXEC} ${ecmccfg_DIR}addEcSdoRT.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM},INDEX=0x2006,SUBINDEX=0x0,DT=U16,NAME=TML-TrgFunc"
#- Default trigger TML func 1:
afterInit "dbpf ${ECMC_P}SDO-TML-TrgFunc-Val 1"

#############################################################
############# Settings:

#-#Set Cyclic Sync Velocity (CSV) mode (9)
#-ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6060,0x0,9,1)"
#-epicsThreadSleep(0.01)
#Set sample time 1*10^-3)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x60C2,0x1,1,1)"
epicsThreadSleep(0.01)
#Set sample time exponent =-3
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x60C2,0x2,-3,1)"
epicsThreadSleep(0.01)
#Set action if communication is lost (Quickstop=3, Diasble voltage=2, Execute fault routine = 1, No action (continue running)=0)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6007,0x0,3,2)"
epicsThreadSleep(0.01)

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "iPOSXXX_VOLT")
