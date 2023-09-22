#===============================================================================
# ecmcEL7411_CSP-Motor-Maxon-312315.cmd
#-d /**
#-d   \brief hardware script for EL7411-Motor-Maxon-312315
#-d   \details Parametrization of EL7411 for motor Maxon-312315 BLDC with hall and incremental encoder for CSP mode
#-d 
#-d   \note This config configures both motor and encoder part of EL7411
#-d 
#-d   Operation mode is to use incremental encoder (not hall sensors)
#-d
#-d   Partnumber 312315 is a motor encoder combination consisting of:
#-d   1. Motor part number            : 283870
#-d   2. Encoder part number          : 228456
#-d
#-d   \param I_RUN_MA     : (optional) Running current in mA (defaults to 4000mA)
#-d   \param I_MAX_MA     : (optional) Max current protection limit (12000mA)
#-d
#-d*/

#-d Load motor settings
ecmcFileExist("${ECMC_CONFIG_ROOT}ecmcEL7411-Motor-Maxon-283870.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7411-Motor-Maxon-283870.cmd "I_RUN_MA=${I_RUN_MA=4000},I_MAX_MA=${I_MAX_MA=12000}"

#-d Load encoder settings
ecmcFileExist("${ECMC_CONFIG_ROOT}ecmcEL7411-Encoder-Maxon-228456.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}ecmcEL7411-Encoder-Maxon-228456.cmd
