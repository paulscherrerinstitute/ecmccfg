#!/bin/sh

# Open panel for the next configured DS
#   DS index is retrived from the PV $PREFIX:MCU-Cfg-DS$ID-NxtObjId

# Arguments:
#   1 : PREFIX
#   2 : Current DS id

PREFIX=$1
ID=$2
ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-DS$ID-NxtObjId | tr -d '"')
ID_2=$(printf  "%02d" $ID_1)
MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
echo "MACROS=$MACROS"
caqtdm -macro $MACROS ecmcDSxx.ui
