#!/bin/sh

# Open panel for teh first EtherCAT slave configured by ecmccfg->addSlave.cmd
#   Slave index is retrived from the PV $PREFIX:MCU-Cfg-EC-FrstObjId
#   Master index is retrived from the PV $PREFIX:MCU-Cfg-EC-Mst
# Arguments:
#   1 : PREFIX

PREFIX=$1
S_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-EC-FrstObjId | tr -d '"')
S_ID=$(printf  "%03d" $S_ID)
echo "S_ID=$S_ID"
M_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-EC-Mst | tr -d '"')
echo "M_ID=$M_ID"

# get panel type
PV_NAME=$PREFIX":m"$M_ID"s"$S_ID"-PnlTyp"
PANEL=$( caget -noname -nostat $PV_NAME | tr -d '"')
echo "PANEL=$PANEL"
MACROS="SYS=$PREFIX,IOC=$PREFIX,MasterID=$M_ID,SlaveID=$S_ID,PANEL=$PANEL"
echo "MACROS=$MACROS"
caqtdm -macro $MACROS ecmcGenericSlaveOverview.ui
