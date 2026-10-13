# WARNING: UNTESTED
#-d /**
#-d   \brief Hardware configuration for Nanotec N6-1-1-1-S in CSV mode
#-d   \details CiA-402 EtherCAT drive; ESI version 2508-B1072143
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "N6-1-1-1-S")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x0000026C")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x00110001")
epicsEnvSet("ECMC_EC_REVISION"           "0x09CC0000")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "N6")
epicsEnvSet("ECMC_SUBST_TYPE"            "N6-1-1-1-S")
epicsEnvSet("ECMC_HW_PANEL"              "N6-1-1-1-S")

#- Verify identity without attempting a restore-default SDO on untested hardware.
ecmcFileExist(${ecmccfg_DIR}slaveVerify.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=0"

#- Select CiA-402 cyclic synchronous velocity mode (CSV = 9).
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x6060,0x00,9,1)"

#- Use the highest-resolution native units by default:
#- position = encoder increments, velocity = encoder increments/second.
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x60A8,0x00,0x00B50000,4)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x60A9,0x00,0x00B50300,4)"

#- Industrial digital I/O levels: 24 V inputs, +UB outputs and pull-down inputs.
#- 0x323A:01 is shared by the inputs and outputs (0=5 V, 1=24 V/+UB).
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x323A,0x01,1,1)"
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x323A,0x02,0,1)"

#- SM2 outputs.
#- 0x1600: controlword + mode of operation
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6040,0x00,U16,driveControl01)"
ecmcConfigOrDie "Cfg.EcSetSlavePortWiringCheckEnable(${ECMC_EC_SLAVE_NUM},1)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6060,0x00,S8,modeControl01)"
#- 0x1602: CSV target velocity
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1602,0x60FF,0x00,S32,velocitySetpoint01)"
#- 0x1603: physical digital outputs
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1603,0x60FE,0x01,U32,binaryOutputArray01)"

#- SM3 inputs.
#- 0x1a00: statusword + displayed mode
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6041,0x00,U16,driveStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6061,0x00,S8,modeActual01)"
#- 0x1a01: encoder position
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6064,0x00,S32,positionActual01)"
#- 0x1a02: actual velocity
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x606C,0x00,S32,velocityActual01)"
#- 0x1a03: digital inputs, external feedback and diagnostics. The N6 has
#- only four slots in 0x1C13, so all added Tx entries stay in PDO 0x1a03.
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x60FD,0x00,U32,binaryInputArray01)"
#- Feedback interface 3: incremental A/B/I (configured at 0x33A0).
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x60E4,0x03,S32,positionActualInc01)"
#- Feedback interface 4: SSI (configured at 0x33B0).
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x60E4,0x04,S32,positionActualSSI01)"
#- Drive diagnostics.
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x603F,0x00,U16,errorCode01)"
ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6077,0x00,S16,torqueActual01)"

#- Initialise the cyclic mode byte and replay the SDO after reconnection.
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM},modeControl01,9)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM},binaryOutputArray01,0)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6060,0x00,9,1)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x60A8,0x00,0x00B50000,4)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x60A9,0x00,0x00B50300,4)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x323A,0x01,1,1)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x323A,0x02,0,1)"
ecmcConfigOrDie "Cfg.EcSetSlaveNeedSDOSettings(${ECMC_EC_SLAVE_NUM},1,1)"

#- ESI DC mode: SYNC0=1 ms, shift=250 us, AssignActivate=0x0330.
#- This mode is intended for an EtherCAT update rate of 1 kHz.
ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x0330,1000000,250000,0,0)"

${SCRIPTEXEC} ${ecmccfg_DIR}ecmcWatchDog.cmd
