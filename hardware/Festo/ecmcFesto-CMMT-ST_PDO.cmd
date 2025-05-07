#-d /**
#-d   \brief hardware script for Festo CMMT-ST Drive
#-d   \details Festo CMMT-ST drive (48V,8A)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */


epicsEnvSet("ECMC_EC_HWTYPE"             "Festo-CMMT-ST")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x0000001d")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x007b5a25")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "Festo-CMMT-ST")

#- verify slave
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#- Outputs
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6040,0x00,16,driveControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6060,0x00,8,modeControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x607A,0x00,32,1,positionSetpoint01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6081,0x00,32,1,profileVelocitySetpoint01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x60FF,0x00,32,1,velocitySetpoint01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6071,0x00,16,1,torqueSetpoint01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x60B1,0x00,32,1,velocityOffset01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x60B2,0x00,16,1,torqueOffset01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x60FE,0x1,32,0,binaryOutputWd01)"

#- Inputs
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6041,0x0,16,driveStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6061,0x0,8,1,modeStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6064,0x0,32,1,positionActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x60E4,0x1,32,1,positionActual02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x606C,0x0,32,1,velocityActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x60E5,0x1,32,1,velocityActual02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6077,0x0,16,1,torqueActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x60FD,0x0,32,0,binaryInputWd01)"

#- Select encoder (Async SDO)
#- P11616.0.0 0x2130:7D: 
#- 4: Incremental encoder
#- 7: Without encoder 
#- 8: BISS-C
ecmcFileExist(${ecmccfg_DIR}addEcSdoRT.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}addEcSdoRT.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM},INDEX=0x2130,SUBINDEX=0x7D,DT=S32,NAME=EncSel"

#- Reinit drive (Async SDO)
${SCRIPTEXEC} ${ecmccfg_DIR}addEcSdoRT.cmd, "SLAVE_ID=${ECMC_EC_SLAVE_NUM},INDEX=0x2003,SUBINDEX=0x1,DT=S8,NAME=ReInitCmd"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "CMMT-ST")
