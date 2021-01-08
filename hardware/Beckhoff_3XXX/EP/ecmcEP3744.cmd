#-d /**
#-d   \brief hardware script for EP3744-0041, maybe the EP3744-1041
#-d   \details Differential pressure measuring box, 6 digital inputs 24 V DC, 2 digital outputs 24 V DC, 0.5 A, 4 pressure inputs -1…1 bar
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"      "EP3744")
epicsEnvSet("ECMC_EC_VENDOR_ID"   "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"  "0x0ea04052")
epicsEnvSet("ECMC_EC_REVISION"    "0x00140029")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- binary outputs
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x7000,0x1,U16,binaryOutputArray01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0xf700,0x1,U16,binaryOutputArray02)"

#- binary inputs Ch1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x01,U16,binaryInputArray01)"
#- analog input Ch1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit.cmd "CH_ID=1,ECMC_PDO=0x1a01,ECMC_ENTRY=0x6020"
#- analog input Ch2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit.cmd "CH_ID=2,ECMC_PDO=0x1a02,ECMC_ENTRY=0x6030"
#- analog input Ch3
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit.cmd "CH_ID=3,ECMC_PDO=0x1a03,ECMC_ENTRY=0x6040"
#- analog input Ch4
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_32bit.cmd "CH_ID=4,ECMC_PDO=0x1a04,ECMC_ENTRY=0x6050"
#- device status
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0xf600,0x01,U16,safeStatus)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0xf611,0x01,U16,voltageStatus)"
