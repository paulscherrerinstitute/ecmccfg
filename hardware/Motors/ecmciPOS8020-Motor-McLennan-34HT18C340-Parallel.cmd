############################################################
############# Parmetrization of technosoft IPOS8020 for motor McLennan-34HT18C340
#
#  Connection Paralell connection
#  Max current: 5.6A
#  Run current: 5.0A
#  standby current: 2.0A
#  NoMicroStepsPerStep=256
#  NoMotorSteps=200
#
# NOTE: If "NoMicroStepsPerStep" or "NoMotorSteps" is changed from the default (256,200) 
#       a save and reset is needed of the drive. See "Save and reset" below.
#
############################################################
############# Configure settings not directlly accessible as sdos:
# Use 0x2064, 0x2067 for drive memory access, see technosoft CoE manual.
#
# Configuration word to next write
# Bit 31..16: Address=0x271  (example KPI)
# Bit 15..8: Always 0
# Bit 7: 1 (Do not auto increment)
# Bit 6..4 Always 0
# Bit 3,2: 01 (DATA)
# Bit 1: Always 0
# Bit 0: 0 (16bit)
# Result: 0x2710084 
epicsEnvSet("ECMC_TECHNOSOFT_CFG_HEX"          "0084")

############# Number of steps per revolution:
# NOTE:If changed from default then save and reset is needed (SE BELOW "Save and Reset section")!
# SFTCL1 at technosoft adress 280:
# SFTCL1 = log(2048/NoMicroStepsPerStep)/log(2)-1
# SFTCL1= log(2048/256)/log(2)-1=2

# Write data SFTCL1=1 (1dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0280")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "0002")
< ../hardware/technosoft/technosoftWriteGenericCfg

# SCL2L_long = 2*DSP_FREQ*NoMicroStepsPerStep*Ts_S ()
# SCL2H=HIGH(SCL2L_long) at technosoft adress 281:
# SCL2L=LOW(SCL2L_long) at technosoft adress 282:

# Write SCL2H=0x02BF (read in EasyMotion Studio)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0281")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "02BF")
< ../hardware/technosoft/technosoftWriteGenericCfg

# Write SCL2L=0x2000 (read in EasyMotion Studio)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0282")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "2000")
< ../hardware/technosoft/technosoftWriteGenericCfg

# STEPRES at technosoft adress 802
# STEPRES=NoMotorSteps*NoMicroStepsPerStep (200*256)
# Write STEPRES=C800 (51200) (read in EasyMotion Studio)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0282")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "C800")
< ../hardware/technosoft/technosoftWriteGenericCfg

############# Current controller:
# The values for current control can be automaticaly tuned/calculated in EasymotionStudio.
# KPI at technosoft address 0x0271 range 0..32737 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?KPI 
# SFTKPI at technosoft address 0x0272 range 0..14 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?SFTKPI 
# Formula Kp=KPI/32767*2^SFTKPI 
# Kp=18.398 (from autotune in EasyMotionStudio)=>KPI=18839, SFTKPI=5

# Write data KPI=0x4997 (18839dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0271")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "4997")
< ../hardware/technosoft/technosoftWriteGenericCfg

# Write data SFTKPI=0x5(5dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0272")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "0005")
< ../hardware/technosoft/technosoftWriteGenericCfg

# KII at technosoft address 0x0273 range 0..32737 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?KII 
# SFTKII at technosoft address 0x0274 range 0..14 (int). TML Command in Technosoft EasyMotionStudio "Command Interpreter": ?SFTKII 
# Formula Ki=KII/32767*2^SFTKII
# Ki=2.028 (from autotune in EasyMotionStudio)=>KII=16407, SFTKII=2

# Write data KII=0x4017 (16407dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0273")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "4017")
< ../hardware/technosoft/technosoftWriteGenericCfg

# Write data SFTKII=0x2 (2dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0274")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "0002")
< ../hardware/technosoft/technosoftWriteGenericCfg

############# Max Current protection: 
# IMAXPROT at technosoft address 0x0295 
# IMAXPROT=Imax*819=5.6*819=4586dec (0x11EA)

# Write data IMAXPROT=0x11EA (4586dec)
epicsEnvSet("ECMC_TECHNOSOFT_ADR_HEX"          "0295")
epicsEnvSet("ECMC_TECHNOSOFT_DATA_HEX"         "11EA")
< ../hardware/technosoft/technosoftWriteGenericCfg

############# Speed controller:
# KPS at technosoft address 0x0237 range 0..32737 (int) 
# SFTKPS at technosoft address 0x0238 range 0..14 (int)
# Formula Kp=KPS/32767*2^SFTKPS
# NOT IMPLEMENTED since not needed yet

# KIS at technosoft address 0x0269 range 0..32737 (int) 
# SFTKIS at technosoft address 0x026A range 0..14 (int)
# Formula Ki=KIS/32767*2^SFTKIS
# NOT IMPLEMENTED since not needed yet

############################################################
############# Save changes and reset (NOTE: only needs to be executed if number of steps is changed above):
#< ../hardware/technosoft/technosoftSaveAndReset

############################################################
############# Configure SDOS:

# NOTE: SHOULD NOT BE USED. Already set above! Steps per rev 200poles, 256 levels of microstepping=>51200steps SHOULD NOT BE USED.
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2084,0x0,51200,4)"

# Stepper current in open loop configuration 5A => 4095 (Isetting=2*Ipeak/65520*I, Ipeak=40A =>Isetting=819*I)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2025,0x0,4095,4)"

# Stepper current in standby (open loop) 2A=>1638 (Isetting=2*Ipeak/65520*I, Ipeak=40A =>Isetting=819*I)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2026,0x0,1638,4)"


