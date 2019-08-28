############################################################
############# Parmetrization of EL2522  Stepdirection drive channel 1

#Ch 1 Drive
epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8000")     
< ../hardware/ecmcEL2522-chX-stepDirectionDrive

#Ch 1 Encoder
epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8020")     
< ../hardware/ecmcEL2522-chX-stepDirectionEncoder

#Ch 2 Drive
epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8010")     
< ../hardware/ecmcEL2522-chX-stepDirectionDrive

#Ch 2 Encoder
epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8030")     
< ../hardware/ecmcEL2522-chX-stepDirectionEncoder
