#-d /**
#-d   \brief hardware script for EP7211-0034
#-d   \details EP7211-0034 Servo terminal with OCT feedback
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: EP7211-0034 Servo terminal with OCT feedback
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

epicsEnvSet("ECMC_EC_HWTYPE"             "EP7211-0034_CSP")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1c2b4052")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- common PDOs for CSP
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_CSP.cmd

#- DC
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_DC.cmd

#- watchdog
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcWatchDog.cmd

# Peak current (to be overwritten by motor config)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,1000,4)"

# #- Set used pdos
# epicsEnvSet("ECMC_SDO_INDEX",              "0x1C12")
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x1600,2)"
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x1606,2)"
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"
#
# epicsEnvSet("ECMC_SDO_INDEX",              "0x1C13")
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x1A00,2)"
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x1A01,2)"
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x1A02,2)"
# ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,3,1)"
#
# epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)
# epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS_HALF)
# epicsEnvUnset(ECMC_TEMP_WHATCHDOG_1)
# epicsEnvUnset(ECMC_TEMP_WHATCHDOG_2)

#- Set 4000ms delay of ethercat bus at startup:
#- Somtimes the Ex72xx-xxxx will not report a correct encoder signal when transition from PREOP to OP. This is not reflected in any status word or bit
#- This will result in problems sicne ecmc cannot know if teh value is correct or not after startup.
#- For the drives with problems measurements have been made which concludes that after 2600ms after entering OP the EL72xx will give correct encoder position.
#- For twincat probably this is not an isue since the terminals are not goung from PROP to OP so often. 
#- Conclusion: Need to contact Beckhoff. Probably firmware bug.
ecmcConfigOrDie "Cfg.EcSetDelayECOkAtStartup(${ECMC_EC_STARTUP_DELAY=4000})"

