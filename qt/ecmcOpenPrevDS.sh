PREFIX=$1
ID=$2
ID_1=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-DS$ID-PrvObjId | tr -d '"')
ID_2=$(printf  "%02d" $ID_1)
MACROS="SYS=$PREFIX,IOC=$PREFIX,ID_1=$ID_1,ID_2=$ID_2"
echo "MACROS=$MACROS"
caqtdm -macro $MACROS ecmcDSxx.ui
