#-d /**
#-d   \brief hardware script for EP1816-3008
#-d   \details 16-channel digital input 24 V DC, 2 x 3-axis accelerometers
#-d   \author Niko Kivel
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EP1816-3008")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x07184052")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- binary inputs Ch1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x01,U8,binaryInputArray01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x0000,0x00,8,GAP)"
#- binary inputs Ch2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6010,0x01,U8,binaryInputArray02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x0000,0x00,8,GAP)"


#- Presentation of the measured values
#- 0x8080:1d, rwrwrw, type 0802, 16 bit, "Presentation"
#- 3 (default): The measured acceleration values are output as raw values.
#- 4: The measured acceleration values are converted into inclination angles.
#- 5: The measured acceleration values are output in mg (milli g).
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8080,0x1d,5,2)"

#- accelerometers input Ch1
epicsEnvSet("ECMC_PDO_INDEX"   "2")
epicsEnvSet("CH_ID"            "01")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x01,U16,accelerometerStatus${CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x11,S16,accelerometerActual${CH_ID})"

#- accelerometers input Ch2
epicsEnvSet("ECMC_PDO_INDEX"   "3")
epicsEnvSet("CH_ID"            "02")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x01,U16,accelerometerStatus${CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x11,S16,accelerometerActual${CH_ID})"

#- accelerometers input Ch3
epicsEnvSet("ECMC_PDO_INDEX"   "4")
epicsEnvSet("CH_ID"            "03")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x01,U16,accelerometerStatus${CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x11,S16,accelerometerActual${CH_ID})"

#- accelerometers input Ch4
epicsEnvSet("ECMC_PDO_INDEX"   "5")
epicsEnvSet("CH_ID"            "04")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x01,U16,accelerometerStatus${CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x11,S16,accelerometerActual${CH_ID})"

#- accelerometers input Ch5
epicsEnvSet("ECMC_PDO_INDEX"   "6")
epicsEnvSet("CH_ID"            "05")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x01,U16,accelerometerStatus${CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x11,S16,accelerometerActual${CH_ID})"

#- accelerometers input Ch6
epicsEnvSet("ECMC_PDO_INDEX"   "7")
epicsEnvSet("CH_ID"            "06")
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x01,U16,accelerometerStatus${CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0${ECMC_PDO_INDEX},0x60${ECMC_PDO_INDEX}0,0x11,S16,accelerometerActual${CH_ID})"

#- device status
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a80,0xf600,0x01,U16,status)"
