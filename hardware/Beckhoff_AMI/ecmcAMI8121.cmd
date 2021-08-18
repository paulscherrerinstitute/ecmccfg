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

#- common PDOs for CSV
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_CSV.cmd

ecmcEpicsEnvSetCalc("ECMC_TEMP_PERIOD_NANO_SECS",1000/${ECMC_EC_SAMPLE_RATE=1000}*1E6)

#- NOTE important the sync  period needs to be the 62500 ns!
#- NOTE important the sync 1 period needs to be the cycle time!
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x700,62500,0,${ECMC_TEMP_PERIOD_NANO_SECS},0)"
epicsEnvUnset(ECMC_TEMP_PERIOD_NANO_SECS)

#- watchdog
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcWatchDog.cmd
