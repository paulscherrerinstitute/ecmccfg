#-d /**
#-d   \brief hardware script for EP7211-0034
#-d   \details EP7211-0034 Servo terminal with OCT feedback
#-d   \author Niko Kivel
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EP7211-0034")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1c2b4052")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EL7211_OCT")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- common PDOs for CSV
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_CSV.cmd

#- DC
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_DC.cmd

#- watchdog
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcWatchDog.cmd

# Peak current (to be overwritten by motor config)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,1000,4)"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "Ex72x1")
