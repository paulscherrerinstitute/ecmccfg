#-d /**
#-d   \brief hardware script for ELM3602
#-d   \details Parmetrization of ELM3602 for setting all channels to the selected RANGE
#-d   \author Anders Sandstroem
#-d   \file
#-    \pre Environment variables needed:
#-    \pre ECMC_EC_SLAVE_NUM = slave number
#-    \pre RANGE = selected range ("+-320mV")
#-d */

ecmcFileExist("${ecmccfg_DIR}ecmcELM360X-Sensor_${RANGE=}-chX.cmd",1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcELM360X-Sensor_${RANGE}-chX.cmd CH_ID=1
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcELM360X-Sensor_${RANGE}-chX.cmd CH_ID=2
