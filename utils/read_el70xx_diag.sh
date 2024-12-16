MID=$1
SID=$2

echo ""
echo "#########################################################"
echo "Reading EL70xx status at master id $MID and slave id $SID:"
echo ""
echo "Saturated:"
ethercat upload -m $MID -p $SID --type uint8  0xA010 0x1

echo "Over temperature:"
ethercat upload -m $MID -p $SID --type uint8  0xA010 0x2

echo "Torque overload:"
ethercat upload -m $MID -p $SID --type uint8  0xA010 0x3

echo "Under voltage:"
ethercat upload -m $MID -p $SID --type uint8  0xA010 0x4

echo "Over voltage:"
ethercat upload -m $MID -p $SID --type uint8  0xA010 0x5

echo "Short circuit A:"
ethercat upload -m $MID -p $SID --type uint8  0xA010 0x6

echo "Short circuit B:"
ethercat upload -m $MID -p $SID --type uint8  0xA010 0x7

echo "No control power:"
ethercat upload -m $MID -p $SID --type uint8  0xA010 0x8

echo "Misc error:"
ethercat upload -m $MID -p $SID --type uint8  0xA010 0x9
echo ""
echo "#########################################################"
echo ""
