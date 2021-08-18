#-d /**
#-d   \brief hardware script for AMI8121
#-d   \details AMI8000 integrated servo motor
#-d   \author Niko Kivel, based on intial work by Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "AMI8121")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x368ecc09")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- set CSV mode explicitly
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x7010,0x3,9,1)"
#- info data 01: DC voltage [mV]
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x39,2,1)"
#- info data 01: PCB Temp [1/10 degC]
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3A,4,1)"

#- common PDOs for CSV
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_CSV.cmd
#- 0x1A02 DRV Velocity actual value
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x6010,0x07,S32,velocityActual01)"
#- 0x1A03 DRV Torque actual value
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6010,0x08,S16,torqueActual01)"
#- 0x1A04 DRV Info data 1
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6010,0x12,U16,infoData01)"
#- 0x1A05 DRV Info data 2
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6010,0x13,U16,infoData02)"
#- 0x1A10 binaryInputArray mapping for digital inputs
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6020,0x01,U16,binaryInputArray01)"

#- DC
ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)
#- NOTE important the sync  period needs to be the 62500 ns!
#- NOTE important the sync 1 period needs to be the cycle time!
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,62500,0,${ECMC_TEMP_PERIOD_NANO_SECS},0)"
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)

#- watchdog
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcWatchDog.cmd
