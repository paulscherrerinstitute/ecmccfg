#-d /**
#-d   \brief hardware script for EL3602
#-d   \details 2-channel 24bit analog input terminal for Condition Monitoring (IEPE) with oversampling
#-d
#-d   Minimum sample time          = 20000ns  (oversampling rate of 50 in 1kHz ec rate)
#-d   Maximum Oversampling factor  = 100      (if ec rate is 500Hz then a NELM of 100 can be used)
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM3602")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x50219329")
epicsEnvSet("ECMC_OVER_SAMP_MAX"         "100")
epicsEnvSet("ECMC_SAMP_TIME_MIN"         "20000")
epicsEnvSet("ECMC_EC_COMP_TYPE"          "ELM3602")

#- Call generic for ELM3602
< ${ecmccfg_DIR}ecmcELM3602-XXXX.cmd
