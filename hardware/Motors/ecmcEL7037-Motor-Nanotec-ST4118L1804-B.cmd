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
epicsEnvSet(I_MAX_MA,"1500")

#- Ensure running current is below max current otherwise exit
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${I_RUN_MA=1000}>${I_MAX_MA} or ${I_RUN_MA=1000}<=0", "ecmcExit Error: Run current setpoint to high or negative...","# Run current setting OK (${I_RUN_MA=1000})...")
# Result: 
${ECMC_EXE_CMD}
epicsEnvUnset(ECMC_EXE_CMD)

#- Ensure standby current is below max current otherwise exit
ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD, "${I_STDBY_MA=500}>${I_MAX_MA} or ${I_STDBY_MA=500}<=0", "ecmcExit Error: Standby current setpoint to high or negative...","# Standby current setting OK (${I_STDBY_MA=500}).. ")
# Result: 
${ECMC_EXE_CMD}
epicsEnvUnset(ECMC_EXE_CMD)

#- Set max current to 1000mA (actually max current is 1.8Arms for this motor)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,${I_RUN_MA=1000},2)"

#- Reduced current 500mA
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,${I_STDBY_MA=500},2)"

#- Nominal voltage 24V (unit 10mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,2400,2)"

#- Coil resistance 1.75 Ohm (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,175,2)"

#- Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#- Coil inductance 3.3mH Ohm (unit 0.01mH)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,330,2)"
