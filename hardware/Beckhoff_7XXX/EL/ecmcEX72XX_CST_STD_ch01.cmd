#- common configuration for Ex7XXX CST

#- info data
#-   1: Torque current (filtered 1ms) [1000th of rated current]
#-   2: DC link voltage [mV]
#-   4: PCB temperature [0.1 °C]
#-   8: Errors: see docu for details
#-  16: Warnings: see docu for details
#-  32: I2T Motor [%]
#-  64: I2T Amplifier [%]
#- 128: Input Level: see doc for details

#- info data 01: DC voltage [mV]
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x39,2,1)"
#- info data 01: PCB Temp [1/10 degC]
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3A,4,1)"

#- SyncManager 2
#- 0x1600 (default)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7010,0x01,16,driveControl01)"
#- 0x1602 (default)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1602,0x7010,0x09,16,1,torqueSetpoint01)"

#- SyncManager 3
#- 0x1A00 (default)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,32,positionActual01)"
#- 0x1A01 (default)
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x01,16,driveStatus01)"
#- 0x1A02 DRV Velocity actual value
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x6010,0x07,S32,velocityActual01)"
#- 0x1A03 DRV Torque actual value
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6010,0x08,S16,torqueActual01)"
#- 0x1A04 DRV Info data 1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6010,0x12,U16,infoData01)"
#- 0x1A05 DRV Info data 2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x13,U16,infoData02)"
#- 0x1A07 FB Touch probe status
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a07,0x6001,0x01,U16,touchProbeStatus01)"
#- 0x1A0C FB status (encoder value valid and cycle counter)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0C,0x6000,0x01,U16,encoderStatus01)"
#- Activly choose CST mode
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x7010,0x3,10,1)"

#- Ensure drive recives some SDO settings
ecmcConfigOrDie "Cfg.EcSetSlaveNeedSDOSettings(${ECMC_EC_SLAVE_NUM},1,1)"

#- ############ Distributed clocks config EP7211:
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS_HALF",${ECMC_TEMP_PERIOD_NANO_SECS}/2)

ecmcFileExist(${ecmccfg_DIR}applySlaveDCconfig.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}applySlaveDCconfig.cmd "ASSIGN_ACTIVATE=0x700,SYNC_0_CYCLE=${ECMC_TEMP_PERIOD_NANO_SECS}"

# Peak current (to be overwritten by motor config)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,100,4)"

ecmcEpicsEnvSetCalc("ECMC_TEMP_WHATCHDOG_1",1000/${ECMC_EC_SAMPLE_RATE=1000}*1000)
ecmcEpicsEnvSetCalc("ECMC_TEMP_WHATCHDOG_2",${ECMC_TEMP_WHATCHDOG_1}*10)

ecmcConfigOrDie "Cfg.EcSlaveConfigWatchDog(${ECMC_EC_SLAVE_NUM},${ECMC_TEMP_WHATCHDOG_1},${ECMC_TEMP_WHATCHDOG_2})"

#- NOTE: Sometimes the EP7221-0034 will not go to op with the following error in /var/log/messages:
#- Sep  8 09:54:21 mcag-epics4 kernel: EtherCAT ERROR 0-40: SDO download 0x1C32:01 (2 bytes) aborted.
#- Then if the below command is not executed the slave will go online abnd work. Could be related to firmware versions.. Also see below 0x1c33
#- Sync mode
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C32,0x1,3,2)"
#- Cycle time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C32,0x2,${ECMC_TEMP_PERIOD_NANO_SECS},4)"

#- NOTE: Sometimes the EP7221-0034 will not go to op with the following error in /var/log/messages:
#- Sep  8 09:54:21 mcag-epics4 kernel: EtherCAT ERROR 0-40: SDO download 0x1C33:01 (2 bytes) aborted.
#- Then if the below command is not executed the slave will go online abnd work. Could be related to firmware versions.. Also see above 0x1c32
#- Sync mode
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C33,0x1,3,2)"
#- Cycle time
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x1C33,0x2,${ECMC_TEMP_PERIOD_NANO_SECS},4)"

#- Activly choose CST mode
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x7010,0x3,10,1)"

epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS_HALF)
epicsEnvUnset(ECMC_TEMP_WHATCHDOG_1)
epicsEnvUnset(ECMC_TEMP_WHATCHDOG_2)

#- Set 4000ms delay of ethercat bus at startup:
#- Somtimes the Ex72xx-xxxx will not report a correct encoder signal when transition from PREOP to OP. This is not reflected in any status word or bit
#- This will result in problems sicne ecmc cannot know if teh value is correct or not after startup.
#- For the drives with problems measurements have been made which concludes that after 2600ms after entering OP the EL72xx will give correct encoder position.
#- For twincat probably this is not an isue since the terminals are not goung from PROP to OP so often. 
#- Conclusion: Need to contact Beckhoff. Probably firmware bug.
epicsEnvSet(ECMC_EC_STARTUP_DELAY,${ECMC_EC_STARTUP_DELAY_EL72XX=10})

epicsEnvSet("ECMC_HW_PANEL"              "Ex72x1_CST_STD")
