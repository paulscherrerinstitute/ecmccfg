############################################################
############# Parmetrization of EL5002  channel 2
#             for encoder Numerik Jena LAK
#             This encoder delivers 33-bit of data:
#             32-bit position information 
#             1-bit leading ZERO
#             WARNING: LSB ist lost --> half the theoretical resolution only!
############# Configuration file written by Niko Kivel, PSI

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8010")     # CH1=0x8000. CH2=0x8010 

# Call generic config file
< ../hardware/ecmcEL5002-Encoder-NJ_LAK12-510

