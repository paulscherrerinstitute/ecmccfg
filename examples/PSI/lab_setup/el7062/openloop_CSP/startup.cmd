##############################################################################
## Example config for open loop only

require ecmccfg sandst_a "ENG_MODE=1"

#epicsEnvSet(ECMC_DEV_MODE,1)
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "SLAVE_ID=3,HW_DESC=EL7062_CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000, R_COIL_MOHM=8296,L_COIL_UH=1976'"
#${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC,          CH_ID=1, MACROS='ST_ENC_RES=1024'"
#${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC,          CH_ID=2, MACROS='ST_ENC_RES=1024,INV_DIR=1'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_open_loop.yaml,    DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01" 

# Curr I
#ecmcConfigOrDie "Cfg.EcAddSdo(3,0x8010,0x12,1,2)"
## Curr P
#ecmcConfigOrDie "Cfg.EcAddSdo(3,0x8010,0x13,500,2)"
## V I
#ecmcConfigOrDie "Cfg.EcAddSdo(3,0x8010,0x14,50,4)"
## V P
#ecmcConfigOrDie "Cfg.EcAddSdo(3,0x8010,0x15,100,4)"
## P P
#ecmcConfigOrDie "Cfg.EcAddSdo(3,0x8010,0x17,10000,4)"


# Data from auto tune:
# Inductance:
# 0x07b8 1976
# Resistance:
# 0x00002068 8296
# Current loop integral time:
# 0x0018 24
# Current loop proportional gain:
# 0x0124 292
# Velocity loop integral time:
# 0x00000096 150
# Velocity loop proportional gain:
# 0x000000b0 176
# Position loop proportional gain:
# 0x0000000a 10
#

require ecmc_plugin_motion

#  test params
#epicsEnvSet(SDO_INDEX,"0x8${CH_ID_X=0}11")

#- Rotor inertia 57gcm²
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${SDO_INDEX},0x18,57,4)"

#- Position loop window
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x62,10000,4)"

#- Accel limit
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x73,200000,4)"

#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${SDO_INDEX},0x1B,200000,4)"


#- Torque constant
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${SDO_INDEX},0x16,100,4)"

#- Set max current [mA]
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${SDO_INDEX},0x12,1500,4)"
#- Configured motor current
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${SDO_INDEX},0x34,1000,4)"

# feed forward gain
#8110:57
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x57,100,1)"

# Motor max speed
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1b,200000,4)"

# rated speed
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2e,3000,4)"
# Voltage constant
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x31,30000,4)"

# encoder counts per rev
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x13,1000000,4)"

# fault reaction
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x52,0,2)"

