#-d /**
#-d   \brief Generic hardware script for EL3174
#-d   \details 4-channel analog input, -10/0…+10 V, -20/0/+4…+20 mA, 16 bit
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [in] Need the following macros to be assigned:
#-d       "ECMC_EC_HWTYPE"
#-d       "ECMC_EC_VENDOR_ID"
#-d       "ECMC_EC_PRODUCT_ID"
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d   \note Selected range: 0..10V (actually 0..10.737V)
#-d */

#- Configure PDOS
ecmcFileExist("${ecmccfg_DIR}ecmcEL3174_pdos.cmd",1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL3174_pdos.cmd

ecmcFileExist("${ecmccfg_DIR}ecmc$(ECMC_EC_HWTYPE)-Sensor-chX.cmd",1)

#-  Set signal type
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x800D")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmc$(ECMC_EC_HWTYPE)-Sensor-chX.cmd

#-  Set signal type
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x801D")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmc$(ECMC_EC_HWTYPE)-Sensor-chX.cmd

#-  Set signal type
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x802D")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmc$(ECMC_EC_HWTYPE)-Sensor-chX.cmd

#-  Set signal type
epicsEnvSet("ECMC_EC_SDO_INDEX",         "0x803D")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmc$(ECMC_EC_HWTYPE)-Sensor-chX.cmd
