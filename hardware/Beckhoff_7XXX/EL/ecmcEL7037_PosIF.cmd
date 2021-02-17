#-d /**
#-d   \brief hardware script for EL7037_PosIF
#-d   \details EL7037 stepper drive (24V,1.5A)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d   \note For Position Interface
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL7037_PosIF")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1b7d3052")

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- Configure entries
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6000,0x1,16,encoderStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6000,0x11,32,positionActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6000,0x12,32,encoderLatchPostion01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6010,0x1,16,driveStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a07,0x6020,0x1,16,posStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a07,0x6020,0x11,32,posPositionActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a07,0x6020,0x21,16,posVelocityActual01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a07,0x6020,0x22,32,posDriveTime01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7000,0x1,16,encoderControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x7000,0x11,32,value01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1602,0x7010,0x1,16,driveControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1606,0x7020,0x1,16,posControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1606,0x7020,0x11,32,posPositionTarget01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1606,0x7020,0x21,16,posVelocitySetpoint01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1606,0x7020,0x22,16,posStartType01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1606,0x7020,0x23,16,posAccelerationSetpoint01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1606,0x7020,0x24,16,posDecelerationSetpoint01)"

#- ##### Setup parameters for positioning interface

#- Set up position mode
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x1,3,1)"

#- Set velocity min (0-10000)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x1,100,2)"

#- Set velocity max (0-10000)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x2,1000,2)"

#- Set acceleration positive direction (1000ms)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x3,1000,2)"

#- Set acceleration negative direction (1000ms)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x4,1000,2)"

#- Set deceleration positive direction (1000ms)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x5,1000,2)"

#- Set deceleration negative direction (1000ms)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x6,1000,2)"

#- Set emergency deceleration (100ms)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x7,100,2)"

#- Set calibration position  (0)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x8,0,4)"

#- Set calibration velocity twords cam (100)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x9,100,2)"

#- Set calibration velocity off cam (10)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0xA,10,2)"

#- Set target position window (10)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0xB,10,2)"

#- Set in-target timeout (1000)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0xC,1000,2)"

#- Set dead time compensation (50micros)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0xD,50,2)"

#- Set modulo factor/position (0)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0xE,0,4)"

#- Set modulo tolerance window (0)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0xF,0,4)"

#- Set position lag max (0  why?)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8020,0x10,0,2)"

#- Max full step freq = 2000Hz (setting is 1)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x5,1,1)"

#- Error on loss of steps = 1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0xA,1,1)"

#- Feedback type = Internal counter = 1 (for encoder on terminal set to 0)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x8,1,1)"

#- Invert motor polarity = 0
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8012,0x9,0,1)"
