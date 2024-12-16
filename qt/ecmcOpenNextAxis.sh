#!/bin/sh

# Open panel for the next configured motion axis
#   Axis index is retrived from the PV $PREFIX:MCU-Cfg-AX$THIS_AX-NxtObjId

# Arguments:
#   1 : PREFIX
#   2 : Current axis id

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
