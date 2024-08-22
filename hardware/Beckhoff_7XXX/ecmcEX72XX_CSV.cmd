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

# ethercat -p22 pdos
# SM0: PhysAddr 0x1000, DefaultSize  256, ControlRegister 0x26, Enable 1
# SM1: PhysAddr 0x1100, DefaultSize  256, ControlRegister 0x22, Enable 1

# SM2: PhysAddr 0x1200, DefaultSize   12, ControlRegister 0x24, Enable 1
#   RxPDO 0x1610 "DRV RxPDO-Map Controlword Ch.1"
#     PDO entry 0x7010:01, 16 bit, "Controlword"
#   RxPDO 0x1611 "DRV RxPDO-Map Target position Ch.1"
#     PDO entry 0x7010:05, 32 bit, "Target position"
#   RxPDO 0x1650 "DRV RxPDO-Map Controlword Ch.2"
#     PDO entry 0x7110:01, 16 bit, "Controlword"
#   RxPDO 0x1651 "DRV RxPDO-Map Target position Ch.2"
#     PDO entry 0x7110:05, 32 bit, "Target position"

# SM3: PhysAddr 0x1600, DefaultSize   20, ControlRegister 0x20, Enable 1
#   TxPDO 0x1a00 "FB TxPDO-Map Position Ch.1"
#     PDO entry 0x6000:11, 32 bit, "Position"
#   TxPDO 0x1a10 "DRV TxPDO-Map Statusword Ch.1"
#     PDO entry 0x6010:01, 16 bit, "Statusword"
#   TxPDO 0x1a11 "DRV TxPDO-Map Following error actual value Ch.1"
#     PDO entry 0x6010:06, 32 bit, "Following error actual value"

#   TxPDO 0x1a40 "FB TxPDO-Map Position Ch.2"
#     PDO entry 0x6100:11, 32 bit, "Position"
#   TxPDO 0x1a50 "DRV TxPDO-Map Statusword Ch.2"
#     PDO entry 0x6110:01, 16 bit, "Statusword"
#   TxPDO 0x1a51 "DRV TxPDO-Map Following error actual value Ch.2"
#     PDO entry 0x6110:06, 32 bit, "Following error actual value"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "Ex72x1")

