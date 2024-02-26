#- common configuration for Ex7XXX CSV
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7010,0x01,U16,driveControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7010,0x06,S32,velocitySetpoint01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x11,U32,positionActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x01,U16,driveStatus01)"

#- Set 4000ms delay of ethercat bus at startup:
#- Somtimes the Ex72xx-xxxx will not report a correct encoder signal when transition from PREOP to OP. This is not reflected in any status word or bit
#- This will result in problems sicne ecmc cannot know if teh value is correct or not after startup.
#- For the drives with problems measurements have been made which concludes that after 2600ms after entering OP the EL72xx will give correct encoder position.
#- For twincat probably this is not an isue since the terminals are not goung from PROP to OP so often. 
#- Conclusion: Need to contact Beckhoff. Probably firmware bug.
ecmcConfigOrDie "Cfg.EcSetDelayECOkAtStartup(${ECMC_EC_STARTUP_DELAY=4000})"
