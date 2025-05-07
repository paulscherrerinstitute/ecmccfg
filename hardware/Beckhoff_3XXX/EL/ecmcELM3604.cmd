#-d /**
#-d   \brief hardware script for EL3604
#-d   \details 4-channel 24bit analog input terminal for Condition Monitoring (IEPE) with oversampling
#-d
#-d   Minimum sample time          = 50000ns  (oversampling rate of 20 in 1kHz ec rate)
#-d   Maximum Oversampling factor  = 100      (if ec rate is 200Hz then a NELM of 100 can be used)
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "ELM3604")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x50219349")
epicsEnvSet("ECMC_OVER_SAMP_MAX"         "100")
epicsEnvSet("ECMC_SAMP_TIME_MIN"         "50000")

#- Call generic for ELM3604
< ${ecmccfg_DIR}ecmcELM3604-XXXX.cmd
