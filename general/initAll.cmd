#==============================================================================
# initAll.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for basic ECMC setup.
#-d   \author Niko Kivel, Anders Sandstroem
#-d   \file
#-d */

#- call init.cmd
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}init.cmd

############################################################
############# ASYN Configuration:

epicsEnvSet("ECMC_MOTOR_PORT"     "${SM_MOTOR_PORT=MCU1}")
epicsEnvSet("ECMC_ASYN_PORT"      "${SM_ASYN_PORT=MC_CPU1}")
epicsEnvSet("ECMC_PREFIX"         "${SM_PREFIX=IOC2:}")

ecmcAsynPortDriverConfigure(${ECMC_ASYN_PORT},1000,0,0,100)

asynOctetSetOutputEos(${ECMC_ASYN_PORT}, -1, ";\n")
asynOctetSetInputEos(${ECMC_ASYN_PORT}, -1, ";\n")

asynSetTraceMask(${ECMC_ASYN_PORT}, -1, 0x41)

asynSetTraceIOMask(${ECMC_ASYN_PORT}, -1, 6)
asynSetTraceInfoMask(${ECMC_ASYN_PORT}, -1, 1)

${ECMC_MR_MODULE="ecmcMotorRecord"}CreateController(${ECMC_MOTOR_PORT}, ${ECMC_ASYN_PORT}, "32", "200", "1000", "")

############################################################
############# Misc settings:
# Disable function call trace printouts
ecmcConfigOrDie "Cfg.SetEnableFuncCallDiag(0)"

# Disable on change printouts from objects (enable for easy logging)
ecmcConfigOrDie "Cfg.SetTraceMaskBit(15,0)"

# Choose to generate EPICS-records for EtherCAT-entries
# (For records use ECMC_GEN_EC_RECORDS="-records" otherwise ECMC_GEN_EC_RECORDS="")
epicsEnvSet("ECMC_GEN_EC_RECORDS",          "-records")

# Choose to generate EPICS-records for ax-entries (PosAct, SetPos,..)
# (For records use ECMC_GEN_AX_RECORDS="-records" otherwise ECMC_GEN_AX_RECORDS="")
epicsEnvSet("ECMC_GEN_AX_RECORDS",          "-records")

# Update records in 10Hz (skip 99 cycles, based on 1000Hz sample rate)
#epicsEnvSet("ECMC_ASYN_SKIP_CYCLES",       "99")

# Update records in 10ms (100Hz)
epicsEnvSet("ECMC_SAMPLE_RATE_MS",       "10")
