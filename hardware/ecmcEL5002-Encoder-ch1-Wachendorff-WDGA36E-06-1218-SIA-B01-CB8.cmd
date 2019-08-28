############################################################
############# Parmetrization of EL5002  channel 1 for encoder Wachendorff WDGA36E-06-1218-SIA-B01-CB8

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8000")     # CH1=0x8000. CH2=0x8010 

# Call generic config file
< ../hardware/ecmcEL5002-Encoder-Wachendorff-WDGA36E-06-1218-SIA-B01-CB8

