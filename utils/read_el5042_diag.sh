MID=$1
SID=$2
CH_ID=${$3:-0}

echo ""
echo "#########################################################"
echo "Reading EL5042 ch $CH_ID status at master id $MID and slave id $SID:"
echo ""
echo "Power supply present:"
ethercat upload -m $MID -p $SID --type uint8  0xA0$CH_ID0 0x1

echo "Error:"
ethercat upload -m $MID -p $SID --type uint8  0xA0$CH_ID0 0x2

echo "SDC Error:"
ethercat upload -m $MID -p $SID --type uint8  0xA0$CH_ID0 0x3

echo "WD Error:"
ethercat upload -m $MID -p $SID --type uint8  0xA0$CH_ID0 0x4

echo "Data valid:"
ethercat upload -m $MID -p $SID --type uint8  0xA0$CH_ID0 0x5

echo "Data raw value:"
ethercat upload -m $MID -p $SID --type uint64  0xA0$CH_ID0 0x11

echo ""
echo "#########################################################"
echo ""

