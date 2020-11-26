#===============================================================================
# ecmcEL7411-Motor-Maxon-283870.cmd
#-d /**
#-d   \brief hardware script for EL7411-Motor-Maxon-283870
#-d 
#-d   \details Parmetrization of EL7411 for motor Maxon-283870
#-d 
#-d   \note This config only configures the motor part of the EL7411. 
#-d
#-d   \param I_RUN_MA     : (optional) Running current in mA (defaults to 4000mA)
#-d   \param I_MAX_MA     : (optional) Max current protection limit (max is 12000mA)
#-d   \param I_STDBY_MA   : Not supported for servos
#-d
#-d   Combination partnumber: 312315
#-d   Motor:
#-d     part number            : 283870
#-d     name                   : EC-Max 40 brushless 120W with hallsensors
#-d     Nominal torque         : 170mNm
#-d     Nominal voltage        : 48V
#-d     Max continious current : 4.06A
#-d     Torque constant        : 44.8mNm/A
#-d     Speed constant         : 231 rpm/V
#-d     Speed Trorque gradient : 4.89 rpm/mNm
#-d     Mech time constant     : 5.17ms
#-d     Rotor inertia          : 101 gcm^2
#-d     Terminal resistance phase to phase: 1.03 Ohm
#-d     Terminal inductance phase to phase: 0.204 mH
#-d     No load speed          : 10100 rpm
#-d     Nominal speed          : 9250 rpm
#-d     Thermal time const winding : 3.96s
#-d     Thermal time const motor   : 1240s
#-d     Pinout motor:
#-d         pin 1 red    : L1
#-d         pin 2 black  : L2
#-d         pin 3 white  : L3
#-d         pin 4        : NC
#-d         
#-d     Pinout hall:
#-d         pin 1 Yellow : hall 1
#-d         pin 2 brown  : hall 2
#-d         pin 3 grey   : hall 3
#-d         pin 4 blue   : gnd
#-d         pin 5 green  : 3..24V
#-d         pin 6        : NC
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note For important parameters see TwinCAT CoE startup list for the motor terminal configuration.
#-d */ 

#- ###################### Verify current ######################################

epicsEnvSet(I_MAX_MA_LOCAL,12000)

# Only use I_MAX_MA if lower than 12000
ecmcEpicsEnvSetCalcTernary(I_MAX_MA_LOCAL, "${I_MAX_MA=${I_MAX_MA_LOCAL}}<${I_MAX_MA_LOCAL}", "${I_MAX_MA=${I_MAX_MA_LOCAL}}","${I_MAX_MA_LOCAL}")

epicsEnvSet(I_RUN_MA_LOCAL,${I_RUN_MA=4000})

#- Ensure valid current settings 
ecmcFileExist("${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd "I_RUN_MA=${I_RUN_MA_LOCAL},I_STDBY_MA=0,I_MAX_MA=${I_MAX_MA_LOCAL}"

#- ###################### MOTOR ######################################
#- NOTE The Current control paarmeters are very important for FOC commutation. 
#- If warning or error when commutating then slower control params could solve then problem
#-
#- Current loop I default 10 = 1ms  (40 =4ms)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x12,40,2)"
#- Current loop P (0.1V/A) default 10 = 1V/A  (5 = 0.5V/A)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x13,5,2)"

#- Velocity loop proportianal gain = 95
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x15,95,4)"
#- Velocity loop integral time = 150
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x14,150,4)"


#- Nominal voltage = 48V
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x19,48000,4)"
#- Commutation Find cummutation time default 9 = 0.9ms  
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x63,20,2)"
#- Commutation type FOC with incremental encoder =1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x64,1,1)"

#- Motor max current = 12000
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,${I_MAX_MA_LOCAL},4)"
#- Motor rated current = 4A
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x12,${I_RUN_MA_LOCAL},4)"
#- Motor pole pairs = 1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x13,1,1)"
#- Torque contstant = 44.8
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x16,45,4)"
#- Rotor moment of inertia = 101
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x18,101,4)"
#- Winding inductance = 0.204mH (unit in setting 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x19,20,2)"

#- Motor speed limitation = 11000
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1b,11000,4)"
#- Rated voltage = 48V (48000mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2F,48000,4)"
#- Winding resistance 1.03 ohm (1030mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x30,1030,4)"
#- Voltage constant:  1/231=0.00432 volt/rpm  
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x31,4320,4)"

#- Motor thermal time constant = 3.96 s for WINDING!!
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2d,40,2)"
