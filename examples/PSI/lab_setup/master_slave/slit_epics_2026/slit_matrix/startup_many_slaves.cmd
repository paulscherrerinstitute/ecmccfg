#- Configuration scripts
#require ecmccfg v11.0.9_RC2 "MASTER_ID=0,ENG_MODE=1,EC_RATE=1000,ECMC_VER=v11.0.9_RC2"
require ecmccfg dc_timing "MASTER_ID=0,ENG_MODE=1,EC_RATE=1000,ECMC_VER=dc_timing"
#require ecmccfg sandst_a "MASTER_ID=0,ENG_MODE=1,EC_RATE=500,ECMC_VER=sandst_a"
#require ecmccfg "MASTER_ID=0,ENG_MODE=1,EC_RATE=500"
#- Only output errors
asynSetTraceMask(${ECMC_ASYN_PORT}, -1, 0x01)

ecmcConfigOrDie "Cfg.SetEcStartupTimeout(100)"


#   0  0:0   PREOP  +  EK1100 EtherCAT Coupler (2A E-Bus)
#   1  0:1   PREOP  +  EL2068 8Ch. Dig Output 24V, 0.5A
#   2  0:2   PREOP  +  EL2819 16K. Dig. Ausgang 24V, 0,5A, Diagnose
#   3  0:3   PREOP  +  EL5001 1K. SSI Encoder
#   4  0:4   PREOP  +  EL6224 (IO Link Master)
#   5  0:5   PREOP  +  EL2008 8K. Dig. Ausgang 24V, 0.5A
#   6  0:6   PREOP  +  EL4132 2Ch. Ana. Ausgang +/-10V, 16bit
#   7  0:7   PREOP  +  EL5072 2Ch. Inductive sensor interface (LVDT, Half Bridge)
#   8  0:8   PREOP  +  EL1008 8K. Dig. Eingang 24V, 3ms
#   9  0:9   PREOP  +  EL5042 2Ch. BiSS-C Encoder
#  10  0:10  PREOP  +  EL1259 8K. Dig. Eingang 24V/8K. Dig. Ausgang 24V mit Multi-.Tim
#  11  0:11  PREOP  +  EK1100 EtherCAT-Koppler (2A E-Bus)
#  12  0:12  PREOP  +  EL7031 1K. Schrittmotor-Endstufe (24V, 1.5A)
#  13  0:13  PREOP  +  EL7201 1K. MDP742 Servo-Motor-Endstufe (50V, 4A)
#  14  0:14  PREOP  +  EL7041-0052 1Ch. Stepper motor output stage (50V, 5A)
#  15  0:15  PREOP  +  EL7342 2Ch. DC motor output stage (50V, 3.5A)
#  16  0:16  PREOP  +  EL7411 BLDC Terminal with incremental encoder/Hall, 50 V DC, 4.
#  17  0:17  PREOP  +  EL7211-9014 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
#  18  0:18  PREOP  +  EL9576 Bremschopper Klemme
#  19  0:19  PREOP  +  EL9501 Netzteilklemme 0...20 V DC, 0...2 A
#  20  0:20  PREOP  +  EL2535-0002 2Ch. Pulse Width Current Output (24V, 2 A)
#  21  0:21  PREOP  +  EL5102 2Ch. Inc. Encoder 5V (RS422,TTL)
#  22  0:22  PREOP  +  ED7062 | 2-ch. motion interface, stepper motor, 48 V DC, 3 A, p
#  23  0:23  PREOP  +  EL7062-0000 2Ch. Stepper motor output stage (48V, 3A)
#  24  0:24  PREOP  +  EK1100 EtherCAT-Koppler (2A E-Bus)
#  25  0:25  PREOP  +  EL9227-5500 Overcurrent protection 24V DC, 2Ch., max. 10A (sum)
#  26  0:26  PREOP  +  EL5042 2Ch. BiSS-C Encoder
#  27  0:27  PREOP  +  EL5042 2Ch. BiSS-C Encoder
#  28  0:28  PREOP  +  EL3204 4K. Ana. Eingang PT100 (RTD)
#  29  0:29  PREOP  +  EL2008 8K. Dig. Ausgang 24V, 0.5A
#  30  0:30  PREOP  +  EL1008 8K. Dig. Eingang 24V, 3ms
#  31  0:31  PREOP  +  EL7211-9014 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
#  32  0:32  PREOP  +  EL7211-9014 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
#  33  0:33  PREOP  +  EL7211-9014 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
#  34  0:34  PREOP  +  EL7211-9014 1K. MDP742 Servo-Motor-Endstufe mit OCT (50V, 4,5A 
#  35  0:35  PREOP  +  EL9576 Bremschopper Klemme

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=0,HW_DESC=EK1100"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=1,HW_DESC=EL2068"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=2,HW_DESC=EL2819"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=3,HW_DESC=EL5001"
#${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=4,HW_DESC=EL6224"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=5,HW_DESC=EL2008"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=6,HW_DESC=EL4132"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=7,HW_DESC=EL5072"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=8,HW_DESC=EL1008"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=9,HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=1"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Encoder-RLS-LA11-26bit-BISS-C,CH_ID=2"
epicsEnvSet(ENC_SID,${ECMC_EC_SLAVE_NUM})

#${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=10,HW_DESC=EL1259"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=11,HW_DESC=EK1100"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=12,HW_DESC=EL7031"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1000, I_STDBY_MA=500, U_NOM_MV=24000, R_COIL_MOHM=1230'"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_ax6_HI.yaml,        DRV_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_CHANNEL=01,M_ID=${ECMC_EC_MASTER_ID}"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlEnc.cmd,    "FILE=./cfg/biss-c.yaml, DEV=${IOC}, ENC_SID=${ENC_SID}"

#${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=13,HW_DESC=EL7201"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=14,HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd  "COMP=Motor-Generic-2Phase-Stepper,  MACROS='I_MAX_MA=1000, I_STDBY_MA=500, U_NOM_MV=48000, R_COIL_MOHM=1230'"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,   "FILE=./cfg/axis_ax5_LO.yaml,        DRV_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_SLAVE=${ECMC_EC_SLAVE_NUM}, ENC_CHANNEL=01,M_ID=${ECMC_EC_MASTER_ID}"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=15,HW_DESC=EL7342"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=16,HW_DESC=EL7411"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=17,HW_DESC=EL7211-9014_STD"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=18,HW_DESC=EL9576"
#${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=19,HW_DESC=EL9501"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=20,HW_DESC=EL2535-0002"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=21,HW_DESC=EL5102"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=22,HW_DESC=ED7062"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=23,HW_DESC=EL7062"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=24,HW_DESC=EK1100"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=25,HW_DESC=EL9227-5500"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=26,HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=27,HW_DESC=EL5042"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=28,HW_DESC=EL3204"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=29,HW_DESC=EL2008"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=30,HW_DESC=EL1008"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=31,HW_DESC=EL7211-9014_STD"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=32,HW_DESC=EL7211-9014_STD"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=33,HW_DESC=EL7211-9014_STD"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=34,HW_DESC=EL7211-9014_STD"
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,       "SLAVE_ID=35,HW_DESC=EL9576"


#- #################################################################
#- Virtual axes
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,      "FILE=./cfg/axis_vax5_YCEN.yaml, AX_ID=${AX_NUM=12},M_ID=${ECMC_EC_MASTER_ID},DRV_SLAVE=${ECMC_EC_SLAVE_NUM}"
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd,      "FILE=./cfg/axis_vax6_YGAP.yaml, AX_ID=${AX_NUM=13},M_ID=${ECMC_EC_MASTER_ID},DRV_SLAVE=${ECMC_EC_SLAVE_NUM}"

#- #################################################################
#- PLCs with kinematics (note the INC var including dirs to search for include files)
#- The group ID:s configured in yaml are stored in GRP_<axis.group>_ID
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}loadPLCFile.cmd,  "FILE=cfg/axis_main.plc, INC=./cfg/:${ecmccfg_DIR}, PLC_MACROS='AX_CEN=12, AX_GAP=13,  AX_LO=5, AX_HI=6'"
#${SCRIPTEXEC} ${ecmccfg_DIR}loadPLCFile.cmd,    "FILE=./cfg/axis_main.plc, PLC_ID=1, INC=.:${ecmccfg_DIR}, PLC_MACROS='PLC_ID=1, AX_M1=12, AX_M2=13, AX_S1=5, AX_S2=6, GRP_ID_SA=${GRP_realAxes_ID}, GRP_ID_MA=${GRP_virtualAxes_ID},DBG='"

#- Add state machine to sync the virtual and physical axes (the groups are defined in the yaml axis-cfg files) 
${SCRIPTEXEC} ${ecmccfg_DIR}addMasterSlaveSM.cmd "NAME=Slit_SM, MST_GRP_NAME=virtualAxes, SLV_GRP_NAME=realAxes"

ecmcConfigOrDie "Cfg.EcAddEntryCyclicWrite(ec0.s9.ZERO,ec0.s9.positionActual01,1)"
ecmcConfigOrDie "Cfg.EcReportEntryCyclicWrites()"
ecmcConfigOrDie "Cfg.EcAddEntryCyclicWrite(ec0.s14.ZERO,ec0.s9.ZERO)"
ecmcConfigOrDie "Cfg.EcReportEntryCyclicWrites()"
#- #############################################################################
#- reset all errors
afterInit("ecmcConfigOrDie 'ControllerErrorReset()'")

