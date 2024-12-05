#-d /**
#-d   \brief hardware script for iPOSXXXX
#-d   \details
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "iPOS4808BX_2")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x000001a3")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x01a0c82d")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "IPOS4808")

#- verify slave
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

#############################################################
############# Configure PDOS:

epicsEnvSet("ECMC_CH_ID",              "01")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6040,0x0,16,driveControl${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x60FF,0x0,32,1,velocitySetpoint${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x60FE,0x1,32,binaryOutputArray${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x60FE,0x2,32,binaryOutputArrayMask${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6041,0x0,16,driveStatus${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6064,0x0,32,positionActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6077,0x0,16,currentActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60FD,0x0,32,binaryInputArray${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x2045,0x0,16,binaryOutputArrayReadBack${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2046,0x0,16,analogInput01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2047,0x0,16,analogInput02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2055,0x0,16,voltageActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2058,0x0,16,temperatureActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6063,0x0,32,positionActual02)"
epicsEnvUnset(ECMC_CH_ID)

#############################################################
############# Settings:

#Set Cyclic Sync Velocity (CSV) mode (9)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6060,0x0,9,1)"
epicsThreadSleep(0.01)
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
epicsEnvSet("ECMC_HW_PANEL"              "iPOSXXXX")
