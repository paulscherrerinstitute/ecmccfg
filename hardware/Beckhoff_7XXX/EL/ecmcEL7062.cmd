#-d /**
#-d   \brief hardware script for EL7062 CSV
#-d   \details EL7062 stepper drive 3ch 8-48V, 3A, max 5A per channel (sum <= 6A)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL7062")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b963052")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

##-############ Configure PDO 0x1A04:
##-ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6010,0x12,16,voltageActual01)"
#epicsEnvSet("ECMC_SDO_INDEX",              "0x1A04")
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#epicsThreadSleep(0.01)
##-0x60101210
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x60101210,4)"
#epicsThreadSleep(0.01)
##-<PS>,CoE,0x1A00:00,0x03 (3),download pdo 0x1A00 entry count
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"
#epicsThreadSleep(0.01)
#
##-############ Configure PDO 0x1A05:
##ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x13,16,temperatureActual01)"
#epicsEnvSet("ECMC_SDO_INDEX",              "0x1A05")
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#epicsThreadSleep(0.01)
##0x60101310 (0xAAAABBCC, AAAA=index,BB=subindex,CC=size)
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x60101310,4)"
#epicsThreadSleep(0.01)
##<PS>,CoE,0x1A00:00,0x03 (3),download pdo 0x1A00 entry count
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"
#epicsThreadSleep(0.01)
#
##-############ Configure PDO 0x1A0D:
##ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x13,16,infodata_3)"
#epicsEnvSet("ECMC_SDO_INDEX",              "0x1A0D")
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#epicsThreadSleep(0.01)
##0x60101410 (0xAAAABBCC, AAAA=index,BB=subindex,CC=size)
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x60101410,4)"
#epicsThreadSleep(0.01)
##<PS>,CoE,0x1A00:00,0x03 (3),download pdo 0x1A00 entry count
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"
#epicsThreadSleep(0.01)
#
##-############ Configure PDO 0x1A84:
##-ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a84,0x6110,0x11,16,voltageActual02)"
#epicsEnvSet("ECMC_SDO_INDEX",              "0x1A84")
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#epicsThreadSleep(0.01)
##-0x61101210 (0xAAAABBCC, AAAA=index,BB=subindex,CC=size)
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x61101210,4)"
#epicsThreadSleep(0.01)
##-<PS>,CoE,0x1A00:00,0x03 (3),download pdo 0x1A00 entry count
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"
#epicsThreadSleep(0.01)
#
##-############ Configure PDO 0x1A85:
##-ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a85,0x6110,0x13,16,temperatureActual02)"
#epicsEnvSet("ECMC_SDO_INDEX",              "0x1A85")
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#epicsThreadSleep(0.01)
##-0x61101310 (0xAAAABBCC, AAAA=index,BB=subindex,CC=size)
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x61101310,4)"
#epicsThreadSleep(0.01)
##-<PS>,CoE,0x1A00:00,0x03 (3),download pdo 0x1A00 entry count
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"
#epicsThreadSleep(0.01)
#
##-############ Configure PDO 0x1A8D:
##ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x13,16,infodata_3)"
#epicsEnvSet("ECMC_SDO_INDEX",              "0x1A8D")
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#epicsThreadSleep(0.01)
##0x61101410 (0xAAAABBCC, AAAA=index,BB=subindex,CC=size)
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x61101410,4)"
#epicsThreadSleep(0.01)
##<PS>,CoE,0x1A00:00,0x03 (3),download pdo 0x1A00 entry count
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"
#epicsThreadSleep(0.01)
#
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x0,0,1)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x1,0x1600,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x2,0x1601,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x3,0x1680,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x4,0x1681,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C12,0x0,4,1)"
#
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x0,0,1)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x1,0x1a00,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x2,0x1a01,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x3,0x1a04,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x4,0x1a05,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x5,0x1a0D,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x6,0x1a10,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x7,0x1a15,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x8,0x1a80,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x9,0x1a81,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0xA,0x1a84,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0xB,0x1a85,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0xC,0x1a8D,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0xD,0x1a90,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0xE,0x1a95,2)"
#ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1C13,0x0,14,1)"
#
#- ========================== Channel 1 ==========================
#- Activly choose CSV
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x7010,0x3,9,1)"
#
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7010,0x01,U16,driveControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x06,S32,velocitySetpoint01)"
#
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,U32,positionActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x01,U16,driveStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6020,0x1,16,binaryInputs01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a15,0x6000,0x15,32,positionActual01_2)"
#
##- ========================== Channel 2 ==========================
##- Activly choose CSV
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x7110,0x3,9,1)"
#
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1680,0x7110,0x01,U16,driveControl02)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1681,0x7110,0x06,S32,velocitySetpoint02)"
#
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a80,0x6100,0x11,U32,positionActual02)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x6110,0x01,U16,driveStatus02)"

ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a90,0x6120,0x1,16,binaryInputs02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a95,0x6100,0x15,32,positionActual02_2)"


#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7010,0x1,16,driveControl01)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x6,32,1,velocitySetpoint01)"
#
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1680,0x7010,0x1,16,driveControl02)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1681,0x7010,0x6,32,1,velocitySetpoint02)"
#
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,32,positionActual01)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x1,16,driveStatus01)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6010,0x12,16,voltageActual01)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x13,16,temperatureActual01)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0D,0x6010,0x14,16,infodata3_01)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6020,0x1,16,binaryInputs01)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a15,0x6000,0x15,32,positionActual01_2)"
#
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a80,0x6100,0x11,32,positionActual02)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x6110,0x1,16,driveStatus02)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a84,0x6110,0x12,16,voltageActual02)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a85,0x6110,0x13,16,temperatureActual02)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a8D,0x6110,0x14,16,infodata3_02)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a90,0x6120,0x1,16,binaryInputs02)"
#ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a95,0x6100,0x15,32,positionActual02_2)"

ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x7010,0x3,9,1)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x7110,0x3,9,1)"

#- ############ Distributed clocks config
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcEpicsEnvSetCalc("ECMC_SYNC_1","${ECMC_TEMP_PERIOD_NANO_SECS}-62500")
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,62500,0,${ECMC_SYNC_1},0)"
epicsEnvUnset(ECMC_SYNC_1)

ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C32,0x2,${ECMC_TEMP_PERIOD_NANO_SECS},4)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C33,0x2,${ECMC_TEMP_PERIOD_NANO_SECS},4)"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "EL7062")
