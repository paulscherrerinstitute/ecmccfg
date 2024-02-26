
SUBST=$1
TEMP=$2
CMDFILE=$3
AXISFILE=$4
ECMCCFGPATH=$5
MACROS=$6
msi -M '$MACROS' -S $1  | sed 's/ *$//' | awk -v fcmd=$TEMP$CMDFILE -v faxis=$TEMP$AXISFILE -f $ECMCCFGPATH/loadCompleteCfgSubst.awk

