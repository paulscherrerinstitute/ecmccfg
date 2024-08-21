#!/bin/sh

# Open panel for a certain EtherCAT slave 
#   Slave index is retrived from the PV $PREFIX:MCU-Cfg-UI-EC-SlvId
#   Master index is retrived from the PV $PREFIX:MCU-Cfg-EC-Mst
# Arguments:
#   1 : PREFIX

PREFIX=$1
# Get slave id tom open from PV
S_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-UI-EC-SlvId | tr -d '"')
S_ID=$(printf  "%03d" $((10#$S_ID)))
echo "S_ID=$S_ID"

# Get master id
M_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-EC-Mst | tr -d '"')
echo "M_ID=$M_ID"

# Get panel type
PV_NAME=$PREFIX":m"$M_ID"s"$S_ID"-PnlTyp"
PANEL=$( caget -noname -nostat $PV_NAME | tr -d '"')
echo "PANEL=$PANEL"

# Assemnbe macros string
MACROS="SYS=$PREFIX,IOC=$PREFIX,MasterID=$M_ID,SlaveID=$S_ID,PANEL=$PANEL"
echo "MACROS=$MACROS"

caqtdm -macro $MACROS ecmcGenericSlaveOverview.ui
