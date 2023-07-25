#-d /**
#-d   \brief hardware script for EL7037-Motor-Nanotec-ST4118L1804-B
#-d   \details Parmetrization of EL7037 for motor Nanotec ST4118L184-b
#-d   \author Anders Sandstroem
#-d   \note Max current for this motor is set to 1800mA RMS = 1800*1.4=2500mA peak but drive only allows 1500mA
#-d   \param I_RUN_MA (optional) Running current in mA (defaults to 1000mA)
#-d   \param I_STDBY_MA (optional) Standby current in mA (defaults to 500mA)
#-d   \file
#-d */

#- Motor max 1800mArms = 2500mApeak, Drive max 1500mA peak => Use 1500mA
epicsEnvSet(I_MAX_MA_LOCAL,"1500")
epicsEnvSet(I_RUN_MA_LOCAL,${I_RUN_MA=1000})
epicsEnvSet(I_STDBY_MA_LOCAL,${I_STDBY_MA=500})

#- Ensure valid current settings 
ecmcFileExist("${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd "I_RUN_MA=${I_RUN_MA_LOCAL},I_STDBY_MA=${I_STDBY_MA_LOCAL},I_MAX_MA=${I_MAX_MA_LOCAL}"

#- Set max current to 1000mA (actually max current is 1.8Arms for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,${I_RUN_MA_LOCAL},2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,${I_STDBY_MA_LOCAL},2)"

#- Nominal voltage 24V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,2400,2)"

#- Coil resistance 1.75 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,175,2)"

#- Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#- Coil inductance 3.3mH (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,330,2)"

epicsEnvUnset("I_RUN_MA_LOCAL")
epicsEnvUnset("I_STDBY_MA_LOCAL")
epicsEnvUnset("I_MAX_MA_LOCAL")
