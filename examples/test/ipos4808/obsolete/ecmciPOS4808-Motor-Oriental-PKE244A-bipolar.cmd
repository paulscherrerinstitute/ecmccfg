#-d /**
#-d   \brief hardware script for iPOS4808-Motor-Nanotec-AS5918L4204-ENM24B
#-d   \details Parametrization of technosoft IPOS4808 for motor Oriental Motor PK296DB
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- ###########################################################
#- ############ Parametrization of technosoft IPOS4808 for motor Oriental Motor PK296DB
#-
#-   Connection Parallel connection
#-   Max current: 4.2A
#-   Run current: 4.0A
#-   standby current: 1.0A
#-   NoMicroStepsPerStep=256
#-   NoMotorSteps=200
#-
#-  NOTE: If "NoMicroStepsPerStep" or "NoMotorSteps" is changed from the default (256,200)
#-        a save and reset is needed of the drive. See "Save and reset" below.
#-
#- ###########################################################
#- ############ Configure settings not directly accessible as sdos:
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
epicsEnvSet("ECMC_TECHNOSOFT_CFG_HEX"          "0084")

#- ############ Number of steps per revolution:
#-  NOTE:If changed from default then save and reset is needed (SE BELOW "Save and Reset section")!
#-  SFTCL1 at technosoft address 280:
#-  SFTCL1 = log(2048/NoMicroStepsPerStep)/log(2)-1
#-  SFTCL1= log(2048/256)/log(2)-1=2

#-  Write data SFTCL1=1 (1dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0280")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "0002")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  SCL2L_long = 2*DSP_FREQ*NoMicroStepsPerStep*Ts_S ()
#-  SCL2H=HIGH(SCL2L_long) at technosoft address 281:
#-  SCL2L=LOW(SCL2L_long) at technosoft address 282:

#-  Write SCL2H=0x02BF (read in EasyMotion Studio)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0281")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "02BF")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  Write SCL2L=0x2000 (read in EasyMotion Studio)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0282")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "2000")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  STEPRES at technosoft address 802
#-  STEPRES=NoMotorSteps*NoMicroStepsPerStep (200*256)
#-  Write STEPRES=C800 (51200) (read in EasyMotion Studio)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0282")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "C800")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#- ############ Current controller:
#-  The values for current control can be automatically tuned/calculated in EasymotionStudio.
#-  KPI at technosoft address 0x0271 range 0..32737 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?KPI
#-  SFTKPI at technosoft address 0x0272 range 0..14 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?SFTKPI
#-  Formula Kp=KPI/32767*2^SFTKPI
#-  Kp=5.0126 (from autotune in EasyMotionStudio)=>KPI=21501 (53FD), SFTKPI=1

#-  Write data KPI=53FD (21501)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0271")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "53FD")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  Write data SFTKPI=0x2(2dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0272")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "0001")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-KI=1.0443
#-  KII at technosoft address 0x0273 range 0..32737 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?KII
#-  SFTKII at technosoft address 0x0274 range 0..14 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?SFTKII
#-  Formula Ki=KII/32767*2^SFTKII
#-  Ki=0.33543 (from autotune in EasyMotionStudio)=>KII=10991 (0x2AEF), SFTKII=0

#-  Write data KII=4982 (18818)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0273")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "4982")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#-  Write data SFTKII=0x0 (0dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0274")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "0001")
${SCRIPTEXEC} ${ecmccfg_DIR}technosoftWriteGenericCfg.cmd

#- ############ Max Current protection:
#-  IMAXPROT at technosoft address 0x0295
#-  IMAXPROT=Imax*1638=4.5*1638=7371dec (0x1CCB)

#-  Write data IMAXPROT=0x1CCB (7371dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0295")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "1CCB")
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

#- Stepper current in open loop configuration 1A => 1638 (Isetting=2*Ipeak/65520*I, Ipeak=20A =>Isetting=1638*I)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2025,0x0,1638,2)"

#- Stepper current in standby (open loop) 0.2A=>3281638 (Isetting=2*Ipeak/65520*I, Ipeak=20A =>Isetting=1638*I)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2026,0x0,328,2)"
