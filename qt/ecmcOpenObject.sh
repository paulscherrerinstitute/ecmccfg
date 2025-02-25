#!/bin/sh

########
# Open ecmc objects with following args
# CMD:                $1,  $2,    $3,         $4
#  EC_EXP           : CMD, PREFIX 
#  EC_OVERVIEW      : CMD, PREFIX
#  EC_SLAVE         : CMD, PREFIX
#  EC_SLAVE_FIRST   : CMD, PREFIX
#  EC_SLAVE_NEXT    : CMD, PREFIX M_ID        S_ID
#  EC_SLAVE_PREV    : CMD, PREFIX M_ID        S_ID
#  EC_SLAVE_GENERIC : CMD, PREFIX S_ID_PV
#  AXIS             : CMD, PREFIX
#  AXIS_FIRST       : CMD, PREFIX
#  AXIS_NEXT        : CMD, PREFIX THIS_AX_ID
#  DS_FIRST         : CMD, PREFIX
#  DS_NEXT          : CMD, PREFIX THIS_DS_ID
#  DS_PREV          : CMD, PREFIX THIS_DS_ID
#  PLC_FIRST        : CMD, PREFIX
#  PLC_NEXT         : CMD, PREFIX THIS_PLC_ID
#  PLC_PREV         : CMD, PREFIX THIS_PLC_ID
#  PLG_FIRST        : CMD, PREFIX
#  PLG_NEXT         : CMD, PREFIX THIS_PLG_ID
#  PLG_PREV         : CMD, PREFIX THIS_PLG_ID
#  PLG_SAFETY_GRP   : CMD, PREFIX GRP_ID

CMD=$1

# ETHERCAT:
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
  start_ecmc_overview.py --master $M_ID --rows $ROWS $PREFIX
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
  MACROS="SYS=$AX_PREFIX,IOC=$PREFIX,Axis=$AX_NAME,AX_ID=$AX_ID"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcAxisExpert_v2.ui
}

function openFirstAxis() {
  PREFIX=$1
  AX_ID=$( getFirstAxisID $PREFIX)
  echo "AX_ID=$AX_ID"
  AX_PREFIX=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Pfx | tr -d '"' | tr -d ":")
  echo "AX_PREFIX=$AX_PREFIX"
  AX_NAME=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Nam | tr -d '"')
  echo "AX_NAME=$AX_NAME"
  MACROS="SYS=$AX_PREFIX,IOC=$PREFIX,Axis=$AX_NAME,AX_ID=$AX_ID"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcAxisExpert_v2.ui
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
  MACROS="SYS=$AX_PREFIX,IOC=$PREFIX,Axis=$AX_NAME,AX_ID=$AX_ID"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcAxisExpert_v2.ui
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
  MACROS="SYS=$AX_PREFIX,IOC=$PREFIX,Axis=$AX_NAME,AX_ID=$AX_ID"
  echo "MACROS=$MACROS"
  caqtdm -macro $MACROS ecmcAxisExpert_v2.ui
}

# DATA STORAGE
function openFirstDS() {
  PREFIX=$1
  ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-DS-FrstObjId | tr -d '"')
  ID_2=$(printf  "%02d" $ID_1)
  echo "ID_1=$ID_1"
  echo "ID_2=$ID_2"
  MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
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
  "DS_FIRST")
  openFirstDS $2
  ;;
  "DS_NEXT")
  openNextDS $2 $3
  ;;
  "DS_PREV")
  openPrevDS $2  $3
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

  *) echo "Invalid command"
  ;;
esac
