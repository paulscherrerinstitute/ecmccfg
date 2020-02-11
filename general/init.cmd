#==============================================================================
# init.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for setting up the basic EPICS environment.
#-d   \author Niko Kivel, Anders Sandstroem
#-d   \file
#-d */


#- Environment variables:
#-   "ECMC_ASYN_PORT":         Asyn port name
#-   "ECMC_EC_MASTER_ID":      EtherCAT master index
#-   "ECMC_EC_SLAVE_NUM":      EtherCAT slave bus position index
#-   "ECMC_EC_CHANNEL_ID"      Index of input
#-   "ECMC_PINI":              Process at Initialization
#-   "ECMC_DESC":              Description
#-   "ECMC_DTYP":              Data type
#-   "ECMC_SCAN":              Scan field
#-   "ECMC_DRVINFO":           DrvInfo
#-   "ECMC_ZNAM":              String for zero value
#-   "ECMC_ONAM":              String for one value
#-   "ECMC_ZSV":               Alarm severity for zero value
#-   "ECMC_OSV":               Alarm severity for one value
#-   "ECMC_FLNK":              Forward link field
#-   "ECMC_RECORD_NAME":       Record name
#-   "ECMC_ASYN_TIMEOUT":      Asyn timeout
#-   "ECMC_ASYN_ADDR":         Asyn Address

epicsEnvSet("ECMC_ASYN_TIMEOUT",      1)                   # Asyn timeout
epicsEnvSet("ECMC_ASYN_ADDR",         0)                   # Asyn Address
epicsEnvSet("ECMC_MOTOR_PORT",        "NOT SET")
epicsEnvSet("ECMC_ASYN_PORT",         "NOT SET")
epicsEnvSet("ECMC_PREFIX",            "NOT SET")
epicsEnvSet("ECMC_GEN_EC_RECORDS",    "NOT SET")
epicsEnvSet("ECMC_GEN_AX_RECORDS",    "NOT SET")
epicsEnvSet("ECMC_EC_AXIS_HEALTH",    "NOT SET")
epicsEnvSet("ECMC_PLC_SAMPLE_RATE_MS", "NOT SET")

#- ECMC_TIME_SOURCE:
#- = -2 for time stamp in ECMC (default).
#- = 0 for time stamp in EPICS
epicsEnvSet("ECMC_TSE",               -2)

#- Init all axis related variables
${SCRIPTEXEC} "${ECMC_CONFIG_ROOT}initAxis.cmd"

#- Additional parameters when motor Records are loaded
epicsEnvSet("ECMC_EGU",               "mm")
epicsEnvSet("ECMC_PREC",              3)
epicsEnvSet("ECMCAXISFIELDINIT",      "")                  # Extra field init to motor record
epicsEnvSet("ECMC_AXISCONFIG",        "")                  # Extra parameters to driver
