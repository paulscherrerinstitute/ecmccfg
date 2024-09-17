#!/bin/sh

#
# ecmcOpenPanel.sh FIRST_EC <IOC>


# Open panel for prev plugin 
#   Plugin index is retrived from the PV $PREFIX:MCU-Cfg-PLG$ID-PrvObjId 
# Arguments:
#   1 : PREFIX

CMD=$1
IOC=$2    

# get master id
# Arg1 = IOC
function getMasterId() {   
   M_ID=$( caget -noname -nostat -nounit -int $1:MCU-Cfg-EC-Mst | tr -d '"')
   echo "$M_ID"
}

# get first slave id
# Arg1 = IOC
function getFirstSlaveId() {
    S_ID=$( caget -noname -nostat -nounit -int $1:MCU-Cfg-EC-FrstObjId | tr -d '"')
    echo "$S_ID"
    S_ID=$(printf  "%03d" $S_ID)
    echo "$S_ID"
}


# get ec panel type
# Arg1 = IOC
# Arg2 = master id
# Arg3 = slave id
function getEcPanelType() {
   M_ID=$2
   S_ID=$(printf  "%03d" $3)   
   PV_NAME=$1":m"$M_ID"s"$S_ID"-PnlTyp"
   P_TYP=$( caget -noname -nostat $PV_NAME | tr -d '"')
   echo "$P_TYP"
}

case $CMD in

  FIRST_EC)
    M_ID=$(getMasterId $IOC)
    S_ID=$(getFirstSlaveId $IOC)
    P_TYP=$(getEcPanelType $IOC $M_ID $S_ID)
    echo "M_ID=$M_ID"
    echo "S_ID=$S_ID"    
    echo "P_TYP=$P_TYP"    
    MACROS="SYS=$IOC,IOC=$IOC,MasterID=$M_ID,SlaveID=$S_ID,PANEL=$P_TYP"
    echo "MACROS=$MACROS"
    caqtdm -macro $MACROS ecmcGenericSlaveOverview.ui
    ;;

  PREV_EC)
    echo "NOT IMPLEMENTED"
    ;;

  NEXT_EC)
    echo "NOT IMPLEMENTED"
    ;;
  *)
    echo "ERROR NOT VALID COMMAND"

    ;;
esac
