############################################################
############# Parmetrization of EL2522  Stepdirection drive channel 1

#Ch 1 Drive
epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8000")     
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL2522-chX-stepDirectionDrive.cmd

#Ch 1 Encoder
epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8020")     
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL2522-chX-stepDirectionEncoder.cmd

#Ch 2 Drive
epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8010")     
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL2522-chX-stepDirectionDrive.cmd

#Ch 2 Encoder
epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8030")     
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcEL2522-chX-stepDirectionEncoder.cmd
