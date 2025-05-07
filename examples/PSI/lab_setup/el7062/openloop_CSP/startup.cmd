##############################################################################
## Example config for open loop only

#require ecmccfg sandst_a "ENG_MODE=1,ECMC_VER=9.6.8"
require ecmccfg sandst_a "ENG_MODE=1"

#epicsEnvSet(ECMC_DEV_MODE,1)
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,      "SLAVE_ID=3,HW_DESC=EL7062_CSP"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, CH_ID=1, MACROS='I_MAX_MA=1000, I_STDBY_MA=100, U_NOM_MV=24000, R_COIL_MOHM=2372,L_COIL_UH=3000'"
#${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC,          CH_ID=1, MACROS='ST_ENC_RES=1024'"
#${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Encoder-Generic-INC,          CH_ID=2, MACROS='ST_ENC_RES=1024,INV_DIR=1'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})

${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_open_loop.yaml,    DEV=${IOC}, AX_NAME=M1, AXIS_ID=1, DRV_SID=${DRV_SID}, ENC_SID=${DRV_SID}, ENC_CH=01" 

# Curr I
#ecmcConfigOrDie "Cfg.EcAddSdo(3,0x8010,0x12,50,2)"
## Curr P
#ecmcConfigOrDie "Cfg.EcAddSdo(3,0x8010,0x13,250,2)"
### V I
#ecmcConfigOrDie "Cfg.EcAddSdo(3,0x8010,0x14,1500,4)"
#### V P
#ecmcConfigOrDie "Cfg.EcAddSdo(3,0x8010,0x15,10000,4)"
#### P P
#ecmcConfigOrDie "Cfg.EcAddSdo(3,0x8010,0x17,1000,4)"

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
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1b,500,4)"

# rated speed
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2e,3000,4)"

# Voltage constant
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x31,10000,4)"

# encoder counts per rev
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x13,1000000,4)"

# Rotor inertia
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x18,200,4)"

# fault reaction
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x52,0,2)"

#<PS>;CoE;0x1C13 C 0;07 00 00 1A 01 1A 03 1A 06 1A 80 1A 81 1A 86 1A;download pdo 0x1C13 index
#- IP;CoE;0xF081:01;0x00100000 (1048576);
#- IP;CoE;0x10F3:05;0x0001 (1);Enable DiagMessage as emergency
#- PS;CoE;0xF800:10;0x00005DC0 (24000);DRV Amplifier Settings / Nominal DC link voltage
#- PS;CoE;0x8011:12;0x000007D0 (2000);DRV Motor Settings Ch.1 / Rated current
#- PS;CoE;0x8011:18;0x000000D2 (210);DRV Motor Settings Ch.1 / Rotor moment of inertia
#- PS;CoE;0x8011:19;0x017C (380);DRV Motor Settings Ch.1 / Winding inductance
#- PS;CoE;0x8011:30;0x00000320 (800);DRV Motor Settings Ch.1 / Winding resistance
#- PS;CoE;0x8011:31;0x000061C4 (25028);DRV Motor Settings Ch.1 / Voltage constant
#- PS;CoE;0x8011:33;0x000000C8 (200);DRV Motor Settings Ch.1 / Motor full-steps per revolution
#- PS;CoE;0x8011:1B;0x000002A6 (678);DRV Motor Settings Ch.1 / Motor speed limitation
#- PS;CoE;0x8011:34;0x000007D0 (2000);DRV Motor Settings Ch.1 / Configured motor current
#- PS;CoE;0x8010:13;0x0044 (68);DRV Amplifier Settings Ch.1 / Current loop proportional gain
#- PS;CoE;0x8010:12;0x0030 (48);DRV Amplifier Settings Ch.1 / Current loop integral time
#- PS;CoE;0x8010:15;0x000003E8 (1000);DRV Amplifier Settings Ch.1 / Velocity loop proportional gain
#- PS;CoE;0x8010:14;0x00000096 (150);DRV Amplifier Settings Ch.1 / Velocity loop integral time
#- PS;CoE;0x8008:13;0x00001000 (4096);FB Settings ENC Ch.1 / Encoder Increments per Revolution
#- PS;CoE;0x8008:12;RS422 differential (1);FB Settings ENC Ch.1 / Encoder type
#- PS;CoE;0x8010:64;Stepper FOC with encoder (18);DRV Amplifier Settings Ch.1 / Commutation type
#- PS;CoE;0x8010:17;0x0000000A (10);DRV Amplifier Settings Ch.1 / Position loop proportional gain
#- PS;CoE;0x8010:57;0x64 (100);DRV Amplifier Settings Ch.1 / Position loop velocity feed forward gain
#- PS;CoE;0x7010:03;Cyclic synchronous position mode (CSP) (8);DRV Outputs Ch.1 / Modes of operation
