#-d /**
#-d   \brief hardware script for ELM7231-0010
#-d   \details ELM7231-0010 Servo terminal with OCT feedback
#-d   \author Niko Kivel
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: ELM7231-0010 Servo terminal with OCT feedback
#-
#-  Note: The sync mode can not be written to in newer firmwares:
#-        (0x1C32,0x1,0x1C33,0x1). So then these lines below needs
#-        to be removed or commented out.
#-        The log will then show error like:
#-           EtherCAT ERROR 0-46: SDO download 0x1C32:01 (2 bytes) aborted.
#-           EtherCAT ERROR 0-46: SDO abort message 0x06090030: "Value range of parameter exceeded".
#-           EtherCAT ERROR 0-46: SDO configuration failed.
#-
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM7231-0010_CSV")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x502275f9")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EL7231_OCT")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- Activly choose CSV mode
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x7010,0x3,9,1)"

#- ############  read electronic nameplate
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x1,1,1)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x2,1,1)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x3,1,1)"

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1610,0x7010,0x01,U16,driveControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1612,0x7010,0x06,S32,velocitySetpoint01)"

ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,U32,positionActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6010,0x01,U16,driveStatus01)"

#- ############ Distributed clocks config:
#- Configure DC clock
#- From TwinCAT: SYNC 0: User defined 62.5 us, SYNC 1: 4000 us <-- I set this to the cycle time below
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,62500,${ECMC_SYNC_0_OFFSET_NS=0},${ECMC_TEMP_PERIOD_NANO_SECS},${ECMC_SYNC_1_OFFSET_NS=0})"
epicsEnvUnset("ECMC_TEMP_PERIOD_NANO_SECS")

#- watchdog
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcWatchDog.cmd

#- Set 4000 ms delay of ethercat bus at startup:
#- Somtimes the Ex72xx-xxxx will not report a correct encoder signal when transition from PREOP to OP. This is not reflected in any status word or bit
#- This will result in problems sicne ecmc cannot know if teh value is correct or not after startup.
#- For the drives with problems measurements have been made which concludes that after 2600ms after entering OP the EL72xx will give correct encoder position.
#- For twincat probably this is not an isue since the terminals are not goung from PROP to OP so often. 
#- Conclusion: Need to contact Beckhoff. Probably firmware bug.
epicsEnvSet(ECMC_EC_STARTUP_DELAY,${ECMC_EC_STARTUP_DELAY_EL72XX=10})

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "Ex72x1")

