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


#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- analog input Ch1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1a00,ECMC_ENTRY=0x6000"
#- analog input Ch2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=02,ECMC_PDO=0x1a02,ECMC_ENTRY=0x6010"
#- analog input Ch3
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=03,ECMC_PDO=0x1a04,ECMC_ENTRY=0x6020"
#- analog input Ch4
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=04,ECMC_PDO=0x1a06,ECMC_ENTRY=0x6030"

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
