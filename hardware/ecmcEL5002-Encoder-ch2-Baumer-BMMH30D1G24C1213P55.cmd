############################################################
############# Parmetrization of EL5002  channel 2 for encoder Baumer BMMH30D1G24C12/13P55

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8010")     # CH1=0x8000. CH2=0x8010 

# Call generic config file
< ../hardware/ecmcEL5002-Encoder-Baumer-BMMH30D1G24C1213P55
