#-d /**
#-d   \brief hardware script for EL7201
#-d   \details EL7201 Servo terminal with resolver feedback
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: EL7201 Servo terminal with resolver feedback
#-
#-  Note: The sync mode can not be written to in newer firmwares:
#-        (0x1C32,0x1,0x1C33,0x1). So then these lines below needs
#-        to be removed or commented out.
#-        The log will then show error like:
#-           EtherCAT ERROR 0-46: SDO download 0x1C32:01 (2 bytes) aborted.
#-           EtherCAT ERROR 0-46: SDO abort message 0x06090030: "Value range of parameter exceeded".
#-           EtherCAT ERROR 0-46: SDO configuration failed.
#-
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL7201_STD")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x1c213052")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "EL7201_RES")

#- Load standard cfg
ecmcFileExist(${ecmccfg_DIR}ecmcEX72XX_STD-ch01.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEX72XX_STD-ch01.cmd
