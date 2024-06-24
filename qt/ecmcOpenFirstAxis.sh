PREFIX=$1
AX_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-AX-FrstObjId | tr -d '"')
echo "AX_ID=$AX_ID"
AX_PREFIX=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Pfx | tr -d '"' | tr -d ":")
echo "AX_PREFIX=$AX_PREFIX"
AX_NAME=$( caget -noname -nostat -nounit $PREFIX:MCU-Cfg-AX$AX_ID-Nam | tr -d '"')
echo "AX_NAME=$AX_NAME"
MACROS="SYS=$AX_PREFIX,IOC=$AX_PREFIX,Axis=$AX_NAME"
echo "MACROS=$MACROS"
caqtdm -macro $MACROS ecmcAxisExpert_v1.ui
