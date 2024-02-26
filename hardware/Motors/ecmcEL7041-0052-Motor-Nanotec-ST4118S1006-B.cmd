#-d /**
#-d   \brief hardware script for Nanotec-ST4118S1006-B.cmd 
#-d   \details Parmetrization of EL7041-0052 for motor Nanotec ST4118S1006-B
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- Motor max 950mA, Drive max 3500mA peak => Use 950mA  (paralell winding)
epicsEnvSet(I_MAX_MA_LOCAL,"950")
epicsEnvSet(I_RUN_MA_LOCAL,${I_RUN_MA=500})
epicsEnvSet(I_STDBY_MA_LOCAL,${I_STDBY_MA=100})

#- Ensure valid current settings 
ecmcFileExist("${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd",1)
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}chkValidCurrentSetOrDie.cmd "I_RUN_MA=${I_RUN_MA_LOCAL},I_STDBY_MA=${I_STDBY_MA_LOCAL},I_MAX_MA=${I_MAX_MA_LOCAL}"

#- Set max current
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x1,${I_RUN_MA_LOCAL},2)"

#- Reduced current
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x2,${I_STDBY_MA_LOCAL},2)"

#- Nominal voltage 48V (unit 1mV)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x3,48000,2)"

#- Coil resistance 3.9 Ohm PArallell (unit 10mOhm)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x4,390,2)"

#- Motor full steps count 200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x6,200,2)"

#- Coil inductance 3.3mH Ohm (unit 0.01mH)
#- ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0xA,330,2)"

epicsEnvUnset("I_RUN_MA_LOCAL")
epicsEnvUnset("I_STDBY_MA_LOCAL")
epicsEnvUnset("I_MAX_MA_LOCAL")
