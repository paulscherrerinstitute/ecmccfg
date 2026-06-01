#!/bin/sh

########
# Open ecmc objects with following args
# CMD:                   $1,  $2,    $3,         $4
#  EC_EXP              : CMD, PREFIX 
#  EC_OVERVIEW         : CMD, PREFIX
#  EC_SLAVE            : CMD, PREFIX
#  EC_SLAVE_FIRST      : CMD, PREFIX
#  EC_SLAVE_NEXT       : CMD, PREFIX, M_ID        S_ID
#  EC_SLAVE_PREV       : CMD, PREFIX, M_ID        S_ID
#  EC_SLAVE_GENERIC    : CMD, PREFIX, S_ID_PV
#  AXIS                : CMD, PREFIX
#  AXIS_FIRST          : CMD, PREFIX
#  AXIS_NEXT           : CMD, PREFIX, THIS_AX_ID
#  AXIS_NAME           : CMD, IOC DEV, AX_NAME
#  AXIS_OVERVIEW       : CMD, IOC, PANEL_TYPE(optional)
#  AXIS_OVERVIEW_BY_GROUP_ID : CMD, IOC, GRP_ID, PANEL_TYPE(optional)
#  AXIS_OVERVIEW_BY_GROUP_NAME : CMD, IOC, GRP_NAME, PANEL_TYPE(optional)
#  AXIS_OVERVIEW_GROUP_BY_AX_ID : CMD, IOC, AX_ID, PANEL_TYPE(optional)
#  AXIS_OVERVIEW_GROUP_BY_AX_NAME : CMD, IOC, AX_NAME, PANEL_TYPE(optional)
#  AXIS_OVERVIEW_GROUP_BY_SM_ID_MST : CMD, IOC, SM_ID, PANEL_TYPE(optional)
#  AXIS_OVERVIEW_GROUP_BY_SM_ID_SLV : CMD, IOC, SM_ID, PANEL_TYPE(optional)
#  AXES_GROUP_OVERVIEW : CMD, IOC 
#  SM_OVERVIEW         : CMD, IOC
#  DS_OVERVIEW         : CMD, PREFIX
#  DS_FIRST            : CMD, PREFIX
#  DS_NEXT             : CMD, PREFIX, THIS_DS_ID
#  DS_PREV             : CMD, PREFIX, THIS_DS_ID
#  PLC_OVERVIEW        : CMD, PREFIX
#  PLC_FIRST           : CMD, PREFIX
#  PLC_NEXT            : CMD, PREFIX, THIS_PLC_ID
#  PLC_PREV            : CMD, PREFIX, THIS_PLC_ID
#  PLG_OVERVIEW        : CMD, PREFIX
#  PLG_FIRST           : CMD, PREFIX
#  PLG_NEXT            : CMD, PREFIX, THIS_PLG_ID
#  PLG_PREV            : CMD, PREFIX, THIS_PLG_ID
#  PLG_SAFETY_GRP      : CMD, PREFIX, GRP_ID
#  PLG_SAFETY_GRP_AXIS : CMD, PREFIX, DEV,        AX_NAME
#  CPP_LOGIC          : CMD, IOC,    CPP_ID
#  CPP_LOGIC_OVERVIEW : CMD, IOC
#  PVT_MAIN            : CMD, PREFIX
#  SM_FIRST            : CMD, PREFIX
#  SM_NEXT             : CMD, PREFIX, THIS_PLC_ID
#  SM_PREV             : CMD, PREFIX, THIS_PLC_ID
#  TRG_EC_TOOL_HW_DIAG : CMD, PREFIX, M_ID        S_ID
#  OPEN_EC_TOOL_HW_DIAG_MAIN : CMD, PREFIX, M_ID S_ID

CMD=$1

# ETHERCAT:
function getEcOverviewCmd() {
  EC_OVERVIEW_CMD=$( command -v start_ecmc_overview.py 2>/dev/null )
  if [ -n "$EC_OVERVIEW_CMD" ]; then
    echo "$EC_OVERVIEW_CMD"
    return 0
  fi

  for EC_OVERVIEW_CMD in \
    /sls/controls/bin/start_ecmc_overview.py \
    /sf/controls/bin/start_ecmc_overview.py \
    /hipa/controls/bin/start_ecmc_overview.py \
    /proscan/controls/bin/start_ecmc_overview.py
  do
    if [ -x "$EC_OVERVIEW_CMD" ]; then
      echo "$EC_OVERVIEW_CMD"
      return 0
    fi
  done

  echo "ERROR: start_ecmc_overview.py not found in PATH or known controls bin directories." >&2
  return 1
}

function getMasterID() {
  PREFIX=$1
  M_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-EC-Mst | tr -d '"')
  echo "$M_ID"
}

function openEcExpert() {
  PREFIX=$1
  M_ID=$( getMasterID $PREFIX )
  MACROS="MasterID=$M_ID,SYS=$PREFIX,IOC=$PREFIX"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcEcExpert.ui
}

function openEcOverview() {
  PREFIX=$1
  M_ID=$( getMasterID $PREFIX )
  ROWS=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-UI-EC-Rows | tr -d '"')
  EC_OVERVIEW_CMD=$( getEcOverviewCmd ) || return 1
  "$EC_OVERVIEW_CMD" --master $M_ID --rows $ROWS $PREFIX
}

function openEcSlaveFirst() {
  PREFIX=$1
  S_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-EC-FrstObjId | tr -d '"')
  S_ID=$(printf  "%03d" $S_ID)
  echo "S_ID=$S_ID"
  M_ID=$( getMasterID $PREFIX )
  echo "M_ID=$M_ID"
  # get panel type
  PV_NAME=$PREFIX":m"$M_ID"s"$S_ID"-PnlTyp"
  PANEL=$( caget -noname -nostat $PV_NAME | tr -d '"')
  echo "PANEL=$PANEL"
  MACROS="SYS=$PREFIX,IOC=$PREFIX,MasterID=$M_ID,SlaveID=$S_ID,PANEL=$PANEL"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcGenericSlaveOverview.ui
}

function openEcSlave() {
  PREFIX=$1
  # Get slave id tom open from PV
  S_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-UI-EC-SlvId | tr -d '"')
  S_ID=$(printf  "%03d" $((10#$S_ID)))
  echo "S_ID=$S_ID"
  
  # Get master id
  M_ID=$( getMasterID $PREFIX )
  echo "M_ID=$M_ID"
  
  # Get panel type
  PV_NAME=$PREFIX":m"$M_ID"s"$S_ID"-PnlTyp"
  PANEL=$( caget -noname -nostat $PV_NAME | tr -d '"')
  echo "PANEL=$PANEL"
  
  # Assemnbe macros string
  MACROS="SYS=$PREFIX,IOC=$PREFIX,MasterID=$M_ID,SlaveID=$S_ID,PANEL=$PANEL"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcGenericSlaveOverview.ui
}

function openEcSlaveGeneric() {
  PREFIX=$1
  SLAVE_ID_PV=$2
  
  # Get slave id to open from PV
  S_ID=$( caget -noname -nostat -nounit -int $SLAVE_ID_PV | tr -d '"')
  S_ID=$(printf  "%03d" $((10#$S_ID)))
  echo "S_ID=$S_ID"
  
  # Get master id
  M_ID=$( getMasterID $PREFIX )
  echo "M_ID=$M_ID"
  
  # Get panel type
  PV_NAME=$PREFIX":m"$M_ID"s"$S_ID"-PnlTyp"
  PANEL=$( caget -noname -nostat $PV_NAME | tr -d '"')
  echo "PANEL=$PANEL"
  
  # Assemble macros string
  MACROS="SYS=$PREFIX,IOC=$PREFIX,MasterID=$M_ID,SlaveID=$S_ID,PANEL=$PANEL"
  echo "MACROS=$MACROS"
  
  caqtdm -macro $MACROS ecmcGenericSlaveOverview.ui
}

function openEcSlaveNext() {
  PREFIX=$1
  M_ID=$2
  echo "M_ID=$M_ID"
  S_ID=$3
  echo "S_ID=$S_ID"
  S_ID=$(printf  "%03d" $((10#$S_ID)))
  echo "S_ID=$S_ID"
  PV_NAME=$PREFIX":m"$M_ID"s"$S_ID"-NxtObjId"
  echo "PV_NAME=$PV_NAME"
  NXT_S_ID=$( caget -noname -nostat -nounit -int $PV_NAME | tr -d '"')
  NXT_S_ID=$(printf  "%03d" $NXT_S_ID)
  echo "NXT_S_ID=$NXT_S_ID"
  # get panel type
  PV_NAME=$PREFIX":m"$M_ID"s"$NXT_S_ID"-PnlTyp"
  PANEL=$( caget -noname -nostat $PV_NAME | tr -d '"')
  echo "PANEL=$PANEL"
  MACROS="SYS=$PREFIX,IOC=$PREFIX,MasterID=$M_ID,SlaveID=$NXT_S_ID,PANEL=$PANEL"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS --attach ecmcGenericSlaveOverview.ui
}

function openEcSlavePrev() {
  PREFIX=$1
  M_ID=$2
  echo "M_ID=$M_ID"
  S_ID=$3
  echo "S_ID=$S_ID"
  S_ID=$(printf  "%03d" $((10#$S_ID)))
  echo "S_ID=$S_ID"
  PV_NAME=$PREFIX":m"$M_ID"s"$S_ID"-PrvObjId"
  echo "PV_NAME=$PV_NAME"
  NXT_S_ID=$( caget -noname -nostat -nounit -int $PV_NAME | tr -d '"')
  NXT_S_ID=$(printf  "%03d" $NXT_S_ID)
  echo "NXT_S_ID=$NXT_S_ID"
  # get panel type
  PV_NAME=$PREFIX":m"$M_ID"s"$NXT_S_ID"-PnlTyp"
  PANEL=$( caget -noname -nostat $PV_NAME | tr -d '"')
  echo "PANEL=$PANEL"
  MACROS="SYS=$PREFIX,IOC=$PREFIX,MasterID=$M_ID,SlaveID=$NXT_S_ID,PANEL=$PANEL"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS --attach ecmcGenericSlaveOverview.ui
}

# MOTION:
function getAxisID() {
  PREFIX=$1
  AX_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-UI-AX-Id| tr -d '"')
  echo $AX_ID
}

function getFirstAxisID() {
  PREFIX=$1
  AX_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-AX-FrstObjId | tr -d '"')
  echo $AX_ID
}

function openAxis() {
  PREFIX=$1
  AX_ID=$( getAxisID $PREFIX)
  echo "AX_ID=$AX_ID"
  AX_PREFIX=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Pfx | tr -d '"' | tr -d ":")
  echo "AX_PREFIX=$AX_PREFIX"
  AX_NAME=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Nam | tr -d '"')
  echo "AX_NAME=$AX_NAME"
  MACROS="DEV=$AX_PREFIX,IOC=$PREFIX,Axis=$AX_NAME,AX_ID=$AX_ID"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcAxisExpert.ui
}

function openAxisByName() {
  IOC=$1
  AX_PREFIX=$2
  AX_NAME=$3
  echo "DEV=$AX_PREFIX"
  echo "NAME=$AX_NAME"
  # AX_ID is needed as macro in panel
  AX_ID=$( caget -noname -nostat -nounit $AX_PREFIX:$AX_NAME-Id | tr -d '"')
  MACROS="DEV=$AX_PREFIX,IOC=$IOC,Axis=$AX_NAME,AX_ID=$AX_ID"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcAxisExpert.ui
}

function openFirstAxis() {
  PREFIX=$1
  AX_ID=$( getFirstAxisID $PREFIX)
  echo "AX_ID=$AX_ID"
  AX_PREFIX=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Pfx | tr -d '"' | tr -d ":")
  echo "AX_PREFIX=$AX_PREFIX"
  AX_NAME=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Nam | tr -d '"')
  echo "AX_NAME=$AX_NAME"
  MACROS="DEV=$AX_PREFIX,IOC=$PREFIX,Axis=$AX_NAME,AX_ID=$AX_ID"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcAxisExpert.ui
}

function openNextAxis() {
  PREFIX=$1
  THIS_AX=$2  
  AX_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-AX$THIS_AX-NxtObjId | tr -d '"')
  echo "AX_ID=$AX_ID"
  AX_PREFIX=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Pfx | tr -d '"' | tr -d ":")
  echo "AX_PREFIX=$AX_PREFIX"
  AX_NAME=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Nam | tr -d '"')
  echo "AX_NAME=$AX_NAME"
  MACROS="DEV=$AX_PREFIX,IOC=$PREFIX,Axis=$AX_NAME,AX_ID=$AX_ID"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcAxisExpert.ui
}

function openPrevAxis() {
  PREFIX=$1
  THIS_AX=$2
  AX_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-AX$THIS_AX-PrvObjId | tr -d '"')
  echo "AX_ID=$AX_ID"
  AX_PREFIX=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Pfx | tr -d '"' | tr -d ":")
  echo "AX_PREFIX=$AX_PREFIX"
  AX_NAME=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Nam | tr -d '"')
  echo "AX_NAME=$AX_NAME"
  MACROS="DEV=$AX_PREFIX,IOC=$PREFIX,Axis=$AX_NAME,AX_ID=$AX_ID"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcAxisExpert.ui
}

function openAxisOverview() {
  PREFIX=$1
  PANEL_TYPE=${2:-default}
  ROWS=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-UI-AX-Rows | tr -d '"')
  if [ "$PANEL_TYPE" = "mini" ]; then
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows $ROWS --panel-type mini $PREFIX
  else
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows $ROWS $PREFIX
  fi
}

function openAxisOverviewByGrpId() {
  PREFIX=$1
  GRP_ID=$2
  PANEL_TYPE=${3:-default}
  if [ "$PANEL_TYPE" = "mini" ]; then
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --grp_id $GRP_ID --panel-type mini $PREFIX
  else
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --grp_id $GRP_ID $PREFIX
  fi
}

function openAxisOverviewByGrpName() {
  PREFIX=$1
  GRP_NAME=$2
  PANEL_TYPE=${3:-default}
  if [ "$PANEL_TYPE" = "mini" ]; then
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --grp_name $GRP_NAME --panel-type mini $PREFIX
  else
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --grp_name $GRP_NAME $PREFIX
  fi
}

function openAxisOverviewGroupByAxId() {
  PREFIX=$1
  AX_ID=$2
  PANEL_TYPE=${3:-default}
  if [ "$PANEL_TYPE" = "mini" ]; then
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --grp_ax_id $AX_ID --panel-type mini $PREFIX
  else
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --grp_ax_id $AX_ID $PREFIX
  fi
}

function openAxisOverviewGroupByAxName() {
  PREFIX=$1
  AX_NAME=$2
  PANEL_TYPE=${3:-default}
  if [ "$PANEL_TYPE" = "mini" ]; then
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --grp_ax_name $AX_NAME --panel-type mini $PREFIX
  else
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --grp_ax_name $AX_NAME $PREFIX
  fi
}

function openAxisOverviewGroupBySMIdMst() {
  PREFIX=$1
  SM_ID=$2
  PANEL_TYPE=${3:-default}
  if [ "$PANEL_TYPE" = "mini" ]; then
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --sm_id_mst $SM_ID --panel-type mini $PREFIX
  else
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --sm_id_mst $SM_ID $PREFIX
  fi
}

function openAxisOverviewGroupBySMIdSlv() {
  PREFIX=$1
  SM_ID=$2
  PANEL_TYPE=${3:-default}
  if [ "$PANEL_TYPE" = "mini" ]; then
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --sm_id_slv $SM_ID --panel-type mini $PREFIX
  else
    python3 /ioc/modules/qt/ecmc_start_axis_overview.py --rows 1 --sm_id_slv $SM_ID $PREFIX
  fi
}

function openAxesGroupOverview() {
  PREFIX=$1
  python3 /ioc/modules/qt/ecmc_start_axesgroup_overview.py --rows 1 $PREFIX
}

function openSMOverview() {
  PREFIX=$1
  python3 /ioc/modules/qt/ecmc_start_sm_overview.py --rows 1 $PREFIX
}

function openDSOverview() {
  PREFIX=$1
  python3 /ioc/modules/qt/ecmc_start_ds_overview.py --rows 1 $PREFIX
}

# DATA STORAGE
function openFirstDS() {
  PREFIX=$1
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-DS-FrstObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  echo "ID_1=$ID_1"
  echo "ID_2=$ID_2"
  MACROS="DEV=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcDSxx.ui
}

function openNextDS() {
  PREFIX=$1
  ID=$2
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-DS$ID-NxtObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcDSxx.ui
}

function openPrevDS() {
  PREFIX=$1
  ID=$2
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-DS$ID-PrvObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcDSxx.ui
}

function openPLCOverview() {
  PREFIX=$1
  python3 /ioc/modules/qt/ecmc_start_plc_overview.py --rows 1 $PREFIX
}

function openPLGOverview() {
  PREFIX=$1
  python3 /ioc/modules/qt/ecmc_start_plg_overview.py --rows 1 $PREFIX
}


# PLC
function openPLCFirst() {
  PREFIX=$1
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-PLC-FrstObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  echo "ID_1=$ID_1"
  echo "ID_2=$ID_2"
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcPLCxx.ui
}

function openPLCNext() {
  PREFIX=$1
  ID=$2
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-PLC$ID-NxtObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcPLCxx.ui
}

function openPLCPrev() {
  PREFIX=$1
  ID=$2
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-PLC$ID-PrvObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcPLCxx.ui
}

# PLG
function openPLGFirst() {
  PREFIX=$1
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-PLG-FrstObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  echo "ID_1=$ID_1"
  echo "ID_2=$ID_2"
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcPLGxx.ui
}

function openPLGNext() {
  PREFIX=$1
  ID=$2
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-PLG$ID-NxtObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcPLGxx.ui
}

function openPLGPrev() {
  PREFIX=$1
  ID=$2
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-PLG$ID-PrvObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcPLGxx.ui
}

#- safety plugin related
function openPLGSafetyGrp() {
  PREFIX=$1
  ID=$2
  NAME=$( caget -noname -nostat -nounit -int $PREFIX:SS1-Grp$ID-Nam | tr -d '"')
  MACROS="SYS=$PREFIX,IOC=$PREFIX,SAFETY_GRP=$NAME"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmc_plugin_safety_group.ui
}

function openPLGSafetyMain() {
  PREFIX=$1  
  MACROS="SYS=$PREFIX,IOC=$PREFIX"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmc_plugin_safety_main.ui
}

function openPLGSafetyGrpAxis() {
  PREFIX=$1
  DEV=$2
  AX_NAME=$3
  NAME=$( caget -noname -nostat -nounit -int $DEV:$AX_NAME-SS1-GrpNam | tr -d '"')
  MACROS="SYS=$PREFIX,IOC=$PREFIX,SAFETY_GRP=$NAME"
  caqtdm -macro $MACROS ecmc_plugin_safety_group.ui
}

function openPVTMain() {
  #  c6025a-04:MCU-PVT-Cfg-AX1-Id
  #  c6025a-04:MCU-PVT-Cfg-AX2-Id
  #  c6025a-04:MCU-PVT-Cfg-AX1-Pfx
  #  c6025a-04:MCU-PVT-Cfg-AX1-Nam
  #  c6025a-04:MCU-PVT-Cfg-AX2-Pfx
  #  c6025a-04:MCU-PVT-Cfg-AX2-Nam

  IOC=$1
  AX_COUNT=$( caget -noname -nostat -nounit -int $IOC:PVT-NumAxes | tr -d '"')
  AXES=""
  DEVS=""
  for ((i = 1 ; i <= AX_COUNT ; i++ )); do 
    M=$( caget -noname -nostat -nounit -int $IOC:MCU-PVT-Cfg-AX$i-Nam | tr -d '"')
    D=$( caget -noname -nostat -nounit -int $IOC:MCU-PVT-Cfg-AX$i-Pfx | tr -d '"')
    AXES="M$i=$M,$AXES"
    DEVS="DEV$i=$D,$DEVS"
  done
  MACROS="IOC=$IOC,$AXES,$DEVS"
  echo "Macro=$MACROS"
  
  caqtdm -macro "$MACROS" ecmcProfileMove.ui
}

# SM
function openSMFirst() {
  PREFIX=$1
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-SM-FrstObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  echo "ID_1=$ID_1"
  echo "ID_2=$ID_2"
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcSMxx.ui
}

function openSMNext() {
  PREFIX=$1
  ID=$2
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-SM$ID-NxtObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcSMxx.ui
}

function openSMPrev() {
  PREFIX=$1
  ID=$2
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-SM$ID-PrvObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcSMxx.ui
}

function ecToolReadHwDiag() {
  PREFIX=$1
  MID=$2
  SID=$3

  # master
  caput $PREFIX:m$MID-EcTool.A $MID
  # slave
  caput $PREFIX:m$MID-EcTool.D $SID
  # comamnd (read diags)
  caput $PREFIX:m$MID-EcTool-Cmd "ethercat hw diag"
  # trigger
  caput $PREFIX:m$MID-EcTool.U 0
  # trigger
  caput $PREFIX:m$MID-EcTool.U 1
  caput $PREFIX:m$MID-EcTool.PROC 1
}

function openEcToolReadHwDiagMain() {
  PREFIX=$1
  MID=$2  
  SID=$3
  # master
  caput $PREFIX:m$MID-EcTool.A $MID
  # slave
  caput $PREFIX:m$MID-EcTool.D $SID
  # comamnd (read diags)
  caput $PREFIX:m$MID-EcTool-Cmd "ethercat hw diag"
  caput $PREFIX:m$MID-EcTool.U 1
  MACROS="SYS=$PREFIX,IOC=$PREFIX,MasterID=$MID,SlaveID=$$SID"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcEcToolMain.ui
  caput $PREFIX:m$MID-EcTool.PROC 1
}

function openCppLogic() {
  IOC=$1
  CPP_ID=$2
  MACROS="IOC=$IOC,CPP_ID=$CPP_ID"
  echo "MACROS=$MACROS"
  caqtdm -macro "$MACROS" ecmcCppLogic.ui
}

function openCppLogicOverview() {
  IOC=$1
  MACROS="IOC=$IOC"
  echo "MACROS=$MACROS"
  caqtdm -macro "$MACROS" ecmcCppLogicOverview.ui
}

# Parse commands
case $CMD in
  "EC_EXP")
  openEcExpert $2
  ;;
  "EC_OVERVIEW")
  openEcOverview $2
  ;;
  "EC_SLAVE")
  openEcSlave $2
  ;;
  "EC_SLAVE_GENERIC")
  openEcSlaveGeneric $2 $3
  ;;
  "EC_SLAVE_FIRST")
  openEcSlaveFirst $2
  ;;
  "EC_SLAVE_NEXT")
  openEcSlaveNext $2 $3 $4
  ;;
  "EC_SLAVE_PREV")
  openEcSlavePrev $2 $3 $4
  ;;
  "AXIS")
  openAxis $2
  ;;
  "AXIS_FIRST")
  openFirstAxis $2
  ;;
  "AXIS_NEXT")
  openNextAxis $2 $3
  ;;
  "AXIS_PREV")
  openPrevAxis $2 $3
  ;;
  "AXIS_NAME")
  openAxisByName $2 $3 $4
  ;;
  "AXIS_OVERVIEW")
  openAxisOverview $2 $3
  ;;
  "AXIS_OVERVIEW_BY_GROUP_ID")
  openAxisOverviewByGrpId $2 $3 $4
  ;;
  "AXIS_OVERVIEW_BY_GROUP_NAME")
  openAxisOverviewByGrpName $2 $3 $4
  ;;
  "AXIS_OVERVIEW_GROUP_BY_AX_ID")
  openAxisOverviewGroupByAxId $2 $3 $4
  ;;
  "AXIS_OVERVIEW_GROUP_BY_AX_NAME")
  openAxisOverviewGroupByAxName $2 $3 $4
  ;;
  "AXIS_OVERVIEW_GROUP_BY_SM_ID_MST")
  openAxisOverviewGroupBySMIdMst $2 $3 $4
  ;;
  "AXIS_OVERVIEW_GROUP_BY_SM_ID_SLV")
  openAxisOverviewGroupBySMIdSlv $2 $3 $4
  ;;
  "AXES_GROUP_OVERVIEW")
  openAxesGroupOverview $2
  ;;
  "SM_OVERVIEW")
  openSMOverview $2
  ;;
  "DS_OVERVIEW")
  openDSOverview $2
  ;;
  "DS_FIRST")
  openFirstDS $2
  ;;
  "DS_NEXT")
  openNextDS $2 $3
  ;;
  "DS_PREV")
  openPrevDS $2  $3
  ;;
  "PLC_OVERVIEW")
  openPLCOverview $2
  ;;
  "PLG_OVERVIEW")
  openPLGOverview $2
  ;;
  "PLC_FIRST")
  openPLCFirst $2 $3
  ;;
  "PLC_NEXT")
  openPLCNext $2 $3
  ;;
  "PLC_PREV")
  openPLCPrev $2 $3
  ;;
  "PLG_FIRST")
  openPLGFirst $2 $3
  ;;
  "PLG_NEXT")
  openPLGNext $2 $3
  ;;
  "PLG_PREV")
  openPLGPrev $2 $3
  ;;
  "PLG_SAFETY_GRP")
  openPLGSafetyGrp $2 $3
  ;;
  "PLG_SAFETY_MAIN")
  openPLGSafetyMain $2
  ;;
  "PLG_SAFETY_GRP_AXIS")
  openPLGSafetyGrpAxis $2 $3 $4
  ;;
  "CPP_LOGIC")
  openCppLogic $2 $3
  ;;
  "CPP_LOGIC_OVERVIEW")
  openCppLogicOverview $2
  ;;
  "PVT_MAIN")
  openPVTMain $2
  ;;
  "SM_FIRST")
  openSMFirst $2
  ;;
  "SM_NEXT")
  openSMNext $2 $3
  ;;
  "SM_PREV")
  openSMPrev $2 $3
  ;;
  "TRG_EC_TOOL_HW_DIAG")
  ecToolReadHwDiag $2 $3 $4
  ;;
  "OPEN_EC_TOOL_HW_DIAG_MAIN")
  openEcToolReadHwDiagMain $2 $3 $4
  ;;
  *) echo "Invalid command"
  ;;
esac
