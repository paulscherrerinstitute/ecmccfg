#!/bin/sh

# Open hw panels for a axis
# Arguments:
#   1 : IOC
#   2 : SLAVE_ID_PV 

IOC=$1
SLAVE_ID_PV=$2

#echo "IOC=$IOC"
#echo "SLAVE_ID_PV=$SLAVE_ID_PV"

# Get slave id to open from PV
S_ID=$( caget -noname -nostat -nounit -int $SLAVE_ID_PV | tr -d '"')
S_ID=$(printf  "%03d" $((10#$S_ID)))
echo "S_ID=$S_ID"

# Get master id
M_ID=$( caget -noname -nostat -nounit -int $IOC:MCU-Cfg-EC-Mst | tr -d '"')
echo "M_ID=$M_ID"

# Get panel type
PV_NAME=$IOC":m"$M_ID"s"$S_ID"-PnlTyp"
PANEL=$( caget -noname -nostat $PV_NAME | tr -d '"')
echo "PANEL=$PANEL"

# Assemble macros string
MACROS="SYS=$IOC,IOC=$IOC,MasterID=$M_ID,SlaveID=$S_ID,PANEL=$PANEL"
echo "MACROS=$MACROS"

caqtdm -macro $MACROS ecmcGenericSlaveOverview.ui
