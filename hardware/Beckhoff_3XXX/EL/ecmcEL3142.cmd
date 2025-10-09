#-d /**
#-d   \brief hardware script for EL3142
#-d   \details 2 channel 16bit analog input (0-20mA)
#-d   \author Anders Sandström
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3142")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0c463052")                                        

#- verify slave, including reset
${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd "RESET=true"

#- analog input Ch1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=01,ECMC_PDO=0x1a02,ECMC_ENTRY=0x6000"
#- analog input Ch2
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcAnalogInput_16bit.cmd "CH_ID=02,ECMC_PDO=0x1a04,ECMC_ENTRY=0x6010"

#- Default panel
epicsEnvSet("ECMC_HW_PANEL"              "Ex3xx2")
				