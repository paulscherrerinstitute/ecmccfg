
SUBST=$1
TEMP=$2
FILE=$3
ECMCCFGPATH=$4
msi -S $1  | sed 's/#.*//' | sed 's/ *$//' | awk -v f=$TEMP$FILE -f $ECMCCFGPATH/multiAxis.awk

