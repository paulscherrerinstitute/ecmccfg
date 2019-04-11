############################################################
############# Information:
# Description: Baumer BMMH30D1G24C1213
#
# by Niko Kivel, Paul Scherrer Institute, 2018
# email: niko.kivel@psi.ch
############################################################

epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8008")
#epicsEnvSet("ECMC_EC_SDO_INDEX"               "0x8018")

# SSI Mode
EthercatMCConfigController "${ECMC_MOTOR_PORT}" "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x18,1,1)"

# Clock frequency
EthercatMCConfigController "${ECMC_MOTOR_PORT}" "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x13,9,1)"

# Gray code == 1
EthercatMCConfigController "${ECMC_MOTOR_PORT}" "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},0x14,1,1)"
