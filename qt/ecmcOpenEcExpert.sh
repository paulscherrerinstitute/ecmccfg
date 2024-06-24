PREFIX=$1
M_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-EC-Mst | tr -d '"')
MACROS="MasterID=$M_ID,SYS=$PREFIX,IOC=$PREFIX"
echo "MACROS=$MACROS"
caqtdm -macro $MACROS ecmcEcExpert.ui
