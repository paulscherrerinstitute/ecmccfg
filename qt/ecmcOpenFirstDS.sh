#!/bin/sh

# Open panel for the first configured data storage axis
#   DS index is retrived from the PV $PREFIX:MCU-Cfg-DS-FrstObjId

# Arguments:
#   1 : PREFIX

PREFIX=$1
ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-DS-FrstObjId | tr -d '"')
ID_2=$(printf  "%02d" $ID_1)
echo "ID_1=$ID_1"
echo "ID_2=$ID_2"
MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
echo "MACROS=$MACROS"
caqtdm -macro $MACROS ecmcDSxx.ui
