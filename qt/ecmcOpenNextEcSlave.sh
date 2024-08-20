PREFIX=$1
M_ID=$2
echo "M_ID=$M_ID"
S_ID=$3
echo "S_ID=$S_ID"
S_ID=$(printf  "%03d" $((10#$S_ID)))
echo "S_ID=$S_ID"
PV_NAME=$PREFIX":m"$M_ID"s"$S_ID"-NxtObjId"
echo "PV_NAME=$PV_NAME"
NXT_S_ID=$( caget -noname -nostat -nounit -int $PV_NAME | tr -d '"')
NXT_S_ID=$(printf  "%03d" $NXT_S_ID)
echo "NXT_S_ID=$NXT_S_ID"
# get panel type
PV_NAME=$PREFIX":m"$M_ID"s"$NXT_S_ID"-PnlTyp"
PANEL=$( caget -noname -nostat $PV_NAME | tr -d '"')
echo "PANEL=$PANEL"
MACROS="SYS=$PREFIX,IOC=$PREFIX,MasterID=$M_ID,SlaveID=$NXT_S_ID,PANEL=$PANEL"
echo "MACROS=$MACROS"
caqtdm -macro $MACROS --attach ecmcGenericSlaveOverview.ui
