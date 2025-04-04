
# Start scan motor
#ethercat download -m$1 -p$2 0xfb00 0x1 --type octet_string "$(printf '\x07\x80')"
#ethercat download -m$1 -p$2 0xfb00 0x1 --type octet_string "$(printf '\x17\x80')"

echo "Inductance:"
ethercat upload -m$1 -p$2 0x8$311 0x19 --type uint16

echo "Resistance:"
ethercat upload -m$1 -p$2 0x8$311 0x30 --type uint32

echo "Current loop integral time:"
ethercat upload -m$1 -p$2 0x8$310 0x12 --type uint16

echo "Current loop proportional gain:"
ethercat upload -m$1 -p$2 0x8$310 0x13 --type uint16


echo "Velocity loop integral time:"
ethercat upload -m$1 -p$2 0x8$310 0x14 --type uint32


echo "Velocity loop proportional gain:"
ethercat upload -m$1 -p$2 0x8$310 0x15 --type uint32


echo "Position loop proportional gain:"
ethercat upload -m$1 -p$2 0x8$310 0x17 --type uint32
