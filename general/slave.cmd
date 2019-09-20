#==============================================================================
# slave.cmd
#- Arguments: n/a

#-d /**
#-d   \brief Script for setting up default records for slaves.
#-d   \author Niko Kivel, Anders Sandstroem
#-d   \file
#-d */

#- Default records for slave
dbLoadTemplate("ecmc${ECMC_EC_HWTYPE}.substitutions","P=${ECMC_PREFIX},PORT=${ECMC_ASYN_PORT},ADDR=0,TIMEOUT=1,MASTER_ID=${ECMC_EC_MASTER_ID},SLAVE_POS=${ECMC_EC_SLAVE_NUM},HWTYPE=${ECMC_EC_HWTYPE},T_SMP_MS=${ECMC_SAMPLE_RATE_MS},TSE=${ECMC_TSE}")
