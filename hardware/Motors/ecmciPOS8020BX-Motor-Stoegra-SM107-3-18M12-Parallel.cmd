#-d /**
#-d   \brief hardware script for iPOS8020-Motor-Stoegra-SM107-3-18M12-Parallel
#-d   \details Parametrization of technosoft IPOS8020 for motor Stögra SM107.3.18M12 Parallel
#-d   \author Anders Sandstroem
#-d   \param I_RUN_MA     : (optional) Running current in mA (defaults to 10000mA)
#-d   \param I_STDBY_MA   : (optional) Standby current in mA (defaults to 1000mA)
#-d   \param I_MAX_PROT_MA: (optional) Max current protection limit (defaults to I_RUN_MA + 3000mA)
#-d   \file
#-d */

#- ###########################################################
#- ############ Parametrization of technosoft IPOS8020 for Phytron VSH.100.200.10 Parallel (10A)
#-
#-   Connection Parallel connection
#-   NoMicroStepsPerStep=256
#-   NoMotorSteps=200
#-
#-  NOTE: If "NoMicroStepsPerStep" or "NoMotorSteps" is changed from the default (256,200)
#-        a save and reset is needed of the drive. See "Save and reset" below.
#-
#- ###########################################################
#- ############ Configure settings not directlly accessible as sdos:
#-  Use 0x2064, 0x2067 for drive memory access, see technosoft CoE manual.
#-
#-  Configuration word to next write
#-  Bit 31..16: Address=0x271  (example KPI)
#-  Bit 15..8: Always 0
#-  Bit 7: 1 (Do not auto increment)
#-  Bit 6..4 Always 0
#-  Bit 3,2: 01 (DATA)
#-  Bit 1: Always 0
#-  Bit 0: 0 (16bit)
#-  Result: 0x2710084

#- Motor max 10000mArms = 14000mApeak, Drive max 20000mA peak => Use 14000mA
epicsEnvSet(I_MAX_MA_LOCAL,"14000")
epicsEnvSet(I_RUN_MA_LOCAL,${I_RUN_MA=10000})
epicsEnvSet(I_STDBY_MA_LOCAL,${I_STDBY_MA=1000})

#- Ensure valid current settings
ecmcFileExist("${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd "I_RUN_MA=${I_RUN_MA_LOCAL},I_STDBY_MA=${I_STDBY_MA_LOCAL},I_MAX_MA=${I_MAX_MA_LOCAL}"

#- Start parametrization
epicsEnvSet("ECMC_TECHNOSOFT_CFG_HEX"          "0084")

#- ############ Number of steps per revolution:
#-  NOTE:If changed from default then save and reset is needed (SE BELOW "Save and Reset section")!
#-  SFTCL1 at technosoft adress 280:
#-  SFTCL1 = log(2048/NoMicroStepsPerStep)/log(2)-1
#-  SFTCL1= log(2048/256)/log(2)-1=2

#-  Write data SFTCL1=1 (1dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0280")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "0002")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  SCL2L_long = 2*DSP_FREQ*NoMicroStepsPerStep*Ts_S ()
#-  SCL2H=HIGH(SCL2L_long) at technosoft adress 281:
#-  SCL2L=LOW(SCL2L_long) at technosoft adress 282:

#-  Write SCL2H=0x02BF (read in EasyMotion Studio ?SCL2H)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0281")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "02BF")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  Write SCL2L=0xC800 (read in EasyMotion Studio)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0282")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "C800")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  STEPRES at technosoft adress 802
#-  STEPRES=NoMotorSteps*NoMicroStepsPerStep (200*256)
#-  Write STEPRES=C800 (51200) (read in EasyMotion Studio)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0282")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "C800")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#- ############ Current controller:
#-  The values for current control can be automaticaly tuned/calculated in EasymotionStudio.
#-  KPI at technosoft address 0x0271 range 0..32737 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?KPI
#-  SFTKPI at technosoft address 0x0272 range 0..14 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?SFTKPI
#-  Formula Kp=KPI/32767*2^SFTKPI
#-  Kp=18.398 (from autotune in EasyMotionStudio)=>KPI=18839, SFTKPI=5

#-  Write data KPI=0x5309
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0271")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "5309")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  Write data SFTKPI=0x0
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0272")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "0000")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  KII at technosoft address 0x0273 range 0..32737 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?KII
#-  SFTKII at technosoft address 0x0274 range 0..14 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?SFTKII
#-  Formula Ki=KII/32767*2^SFTKII
#-  Ki=2.028 (from autotune in EasyMotionStudio)=>KII=16407, SFTKII=2

#-  Write data KII=0x1291
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0273")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "1291")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  Write data SFTKII=0x0
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0274")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "0000")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#- ############ Max Current protection: TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?IMAXPROT
#-  IMAXPROT at technosoft address 0x0295
#-  IMAXPROT=From args
ecmcEpicsEnvSetCalc("ECMC_TEMP_IMAXPROT","if(${I_MAX_PROT_MA=0}>0){ RESULT:=${I_MAX_PROT_MA=0}*819/1000;} else {RESULT:= (${I_RUN_MA_LOCAL}+3000)*819/1000;};","%04x")

#-  Write data IMAXPROT
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0295")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         ${ECMC_TEMP_IMAXPROT})
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#- ############ Speed controller:
#-  KPS at technosoft address 0x0237 range 0..32737 (int)
#-  SFTKPS at technosoft address 0x0238 range 0..14 (int)
#-  Formula Kp=KPS/32767*2^SFTKPS
#-  NOT IMPLEMENTED since not needed yet

#-  KIS at technosoft address 0x0269 range 0..32737 (int)
#-  SFTKIS at technosoft address 0x026A range 0..14 (int)
#-  Formula Ki=KIS/32767*2^SFTKIS
#-  NOT IMPLEMENTED since not needed yet

#- ###########################################################
#- ############ Save changes and reset (NOTE: only needs to be executed if number of steps is changed above):
#- ${SCRIPTEXEC} ${ecmccfg_DIR}technosoftSaveAndReset.cmd

#- ###########################################################
#- ############ Configure SDOS:

#-  NOTE: SHOULD NOT BE USED. Already set above! Steps per rev 200poles, 256 levels of microstepping=>51200steps SHOULD NOT BE USED.
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2084,0x0,51200,4)"

#-  Stepper current in open loop configuration (Isetting=2*Ipeak/65520*I, Ipeak=40A =>Isetting=819*I)
ecmcEpicsEnvSetCalc("ECMC_TEMP_I_RUN_SET","${I_RUN_MA_LOCAL}*819/1000","%d")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2025,0x0,${ECMC_TEMP_I_RUN_SET},4)"

#-  Stepper current in standby (open loop) 1A=>819 (Isetting=2*Ipeak/65520*I, Ipeak=40A =>Isetting=819*I)
ecmcEpicsEnvSetCalc("ECMC_TEMP_I_STDBY_SET","${I_STDBY_MA_LOCAL}*819/1000","%d")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2026,0x0,${ECMC_TEMP_I_STDBY_SET},4)"

#- Cleanup
epicsEnvUnset("ECMC_TEMP_I_STDBY_SET")
epicsEnvUnset("ECMC_TEMP_I_RUN_SET")
epicsEnvUnset("ECMC_TEMP_IMAXPROT")
epicsEnvUnset("I_RUN_MA_LOCAL")
epicsEnvUnset("I_STDBY_MA_LOCAL")
epicsEnvUnset("I_MAX_MA_LOCAL")
