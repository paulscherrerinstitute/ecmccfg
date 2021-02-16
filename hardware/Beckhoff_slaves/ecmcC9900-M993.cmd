#-d /**
#-d   \brief hardware script for C9900-M995
#-d   \details Push button touch panel with indicators
#-d   \author Niko Kivel, based on Anders Sandstroem M995-script
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "C9900-M993")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1ede4032")

${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

##################### BK1250

#- Status word
#- 0x0001 = K-Bus error
#- 0x0002 = Configuration error
#- 0x0010 = Outputs disabled
#- 0x0020 = K-Bus overrun
#- 0x0040 = Communication error (Inputs)
#- 0x0080 = Communication error (Outputs)
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1aff,0xf100,0x1,U16,status)"

#- Control word
#- 0x0010 = Disable outputs
#- 0x0020 = Show K-Bus overrun
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16ff,0xf200,0x1,U16,control)"

##################### KL2809 (outputs for indications of first row of buttons), last output not used
epicsEnvSet("ECMC_KL_SLAVE_NUM"             "00")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x01,B1,binaryOutput01_R)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x02,B1,binaryOutput01_G)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x03,B1,binaryOutput01_B)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x04,B1,binaryOutput02_R)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x05,B1,binaryOutput02_G)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x06,B1,binaryOutput02_B)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x07,B1,binaryOutput03_R)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x08,B1,binaryOutput03_G)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x09,B1,binaryOutput03_B)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x0a,B1,binaryOutput04_R)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x0b,B1,binaryOutput04_G)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x0c,B1,binaryOutput04_B)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x0d,B1,binaryOutput05_R)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x0e,B1,binaryOutput05_G)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x0f,B1,binaryOutput05_B)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x10,B1,notConnected01,0)"

##################### KL1408 (inputs for first row of buttons, key switch and ESTOP)
#- from right to left:
#- buttons 1..5 --> B1_1..5
#- key switch: 6
#- ESTOP: 8
epicsEnvSet("ECMC_KL_SLAVE_NUM"             "01")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x01,B1,binaryInput01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x02,B1,binaryInput02)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x03,B1,binaryInput03)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x04,B1,binaryInput04)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x05,B1,binaryInput05)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x06,B1,binaryInput06)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x07,B1,binaryInput07)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x08,B1,binaryInput08)"

##################### KL2809 (outputs for indications of second row of buttons), last output not used
epicsEnvSet("ECMC_KL_SLAVE_NUM"             "02")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x01,B1,binaryOutput09_R)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x02,B1,binaryOutput09_G)"

##################### KL1408 (inputs for second row of buttons), three last inputs not connected
epicsEnvSet("ECMC_KL_SLAVE_NUM"             "03")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x01,B1,binaryOutput09_B)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x02,B1,binaryOutput10_R)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x03,B1,binaryOutput10_G)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x04,B1,binaryOutput10_B)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x05,B1,binaryOutput11_R)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x06,B1,binaryOutput11_G)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x07,B1,binaryOutput11_B)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x16${ECMC_KL_SLAVE_NUM},0x7${ECMC_KL_SLAVE_NUM}0,0x08,B1,notConnected02,0)"

##################### KL1408 (inputs for second row of buttons)
#- from right to left:
#- buttons 1..3 --> B1_9..11
epicsEnvSet("ECMC_KL_SLAVE_NUM"             "04")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x01,B1,binaryInput09)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x02,B1,binaryInput10)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x03,B1,binaryInput11)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a${ECMC_KL_SLAVE_NUM},0x6${ECMC_KL_SLAVE_NUM}0,0x04,B1,notConnected03,0)"
