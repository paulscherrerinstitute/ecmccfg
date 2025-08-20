#-d /**
#-d   \brief hardware script for EL4374
#-d   \details 2 channel analog output, 2 ch analog input module +-10V, +-20mA 16 bit
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "EL4374_+-10V")

ecmcFileExist(${ecmccfg_DIR}ecmcEL4374_generic.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL4374_generic.cmd

#- 0..20mA for all

#- Inputs mapped as CH1 and CH2
#- 0 – None
#- 2 - V ±10V
#- 14 - V 0-10V
#- 17 - I ±20mA
#- 18 - I 0-20mA
#- 19 - I 4-20mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x800D,0x11,18,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x801D,0x11,18,2)"

#- Outputs mapped as CH3, CH4 
#- 0 – None
#- 2 - V ±10V
#- 14 - V 0-10V
#- 17 - I ±20mA
#- 18 - I 0-20mA
#- 19 - I 4-20mA
#- 20 - I 4-20mA NAMU
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x802D,0x11,18,2)"
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x803D,0x11,18,2)"
