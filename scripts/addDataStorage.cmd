#==============================================================================
# addDataStorage.cmd
#- Arguments: DS_SIZE, [DS_ID], [DS_TYPE], [SAMPLE_RATE_MS], [DS_DEBUG]

#-d /**
#-d   \brief Script for adding dataStorage.
#-d   \details Adds dataStorage buffer.
#-d   \author Anders Sandstroem
#-d   \file
#-d   \param DS_SIZE Size of data buffer.
#-d   \param DS_ID (optional), default 0, buffer ID
#-d   \param DS_TYPE (optional), default 0, 0: Normal Buffer, 1: Ring Buffer, 2: FIFO Buffer
#-d   \param SAMPLE_RATE_MS (optional), default 1
#-d   \param DS_DEBUG (optional), default 0, 0: No debug printouts, 1: Debug  printouts
#-d   \note Example calls:
#-d   \note - call for 1000 elements at 10 Hz
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}addDataStorage.cmd "DS_ID=1, DS_SIZE=1000, SAMPLE_RATE_MS=100"
#-d   \endcode
#-d */

#- DS_SIZE  : Size of data buffer.
#- [optional]
#- DS_ID   = 0
#- DS_TYPE = 0
#-   0: Normal Buffer. Fill from beginning (index 0). Stop when full.
#-   1: Ring Buffer. Fill from beginning (index 0). Start over in beginning when full.
#-   2: FIFO Buffer. Fill from end (index size-1). Old values shifted out.
#- SAMPLE_RATE_MS = 1
#-  -1  : Update records with plc_function (ds_push_asyn())
#-   0   : Update records when data storage changes.
#-   1.. : Sample rate in ms.
#-  DS_DEBUG = 0
#-   0: No debug printouts.
#-   1: Debug  printouts.

epicsEnvSet("ECMC_STORAGE_INDEX",   "${DS_ID=0}")
epicsEnvSet("ECMC_STORAGE_SIZE",    "${DS_SIZE}")
ecmcConfigOrDie "Cfg.CreateStorage(${ECMC_STORAGE_INDEX},${ECMC_STORAGE_SIZE},${DS_TYPE=0})"
ecmcConfigOrDie "Cfg.ClearStorage(${ECMC_STORAGE_INDEX})"
ecmcConfigOrDie "Cfg.SetStorageEnablePrintouts(${ECMC_STORAGE_INDEX},${DS_DEBUG=0})"

ecmcFileExist("ecmcDS-idx.template",1,1)
dbLoadRecords("ecmcDS-idx.template", "P=${ECMC_PREFIX}, PORT=${ECMC_ASYN_PORT}, ADDR=${ECMC_ASYN_ADDR}, TIMEOUT=${ECMC_ASYN_TIMEOUT},A=0,Index=${ECMC_STORAGE_INDEX},NELM=${ECMC_STORAGE_SIZE},T_SMP_MS=${SAMPLE_RATE_MS=1}")
