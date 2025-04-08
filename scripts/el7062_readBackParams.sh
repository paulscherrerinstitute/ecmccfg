echo "EL7062: Executing readback of tuning parameters: Prefix=$4, Master=$1, Slave=$2, Ch=$3, "
MID=$1
SID=$2
SID_3_CHARS=$(printf "%03d\n" "$SID")
CID=$3
CID_2_CHARS=$(printf "%02d\n" "$CID")
CID_FRM_ZER0=$((${CID}-1))
PREFIX=$4
PREFIX_PVS=${PREFIX}m${MID}s${SID_3_CHARS}-Drv${CID_2_CHARS}-Tune

#echo "CID_2_CHARS = $CID_2_CHARS"
#echo "CID_FRM_ZER0 = $CID_FRM_ZER0"
#echo "SID_3_CHARS = $SID_3_CHARS"

# Busy
caput "${PREFIX}m${MID}-EcTool-Stat" "BUSY" > /dev/null 2>&1

SDOINDEX=0x8${CID_FRM_ZER0}11

# Inductance
# ethercat upload -m$1 -p$2 0x8$311 0x19 --type uint16
data=$(/opt/etherlab/bin/ethercat upload -m${MID} -p$SID $SDOINDEX 0x19 --type uint16 | awk {'print $2'})
# convert to ecmccomp unit microHenry
data=$((${data}*10))
caput "${PREFIX_PVS}-L" $data > /dev/null 2>&1

# Progress
caput "${PREFIX}m${MID}-EcTool-Prgs" 15 > /dev/null 2>&1

# Resistance
#ethercat upload -m$1 -p$2 0x8$311 0x30 --type uint32
data=$(/opt/etherlab/bin/ethercat upload -m${MID} -p$SID $SDOINDEX 0x30 --type uint32 | awk {'print $2'})
caput "${PREFIX_PVS}-R" $data > /dev/null 2>&1

# Progress
caput "${PREFIX}m${MID}-EcTool-Prgs" 30 > /dev/null 2>&1

SDOINDEX=0x8${CID_FRM_ZER0}10

# Current loop integral time:
#ethercat upload -m$1 -p$2 0x8$310 0x12 --type uint16
data=$(/opt/etherlab/bin/ethercat upload -m${MID} -p$SID $SDOINDEX 0x12 --type uint16 | awk {'print $2'})
caput "${PREFIX_PVS}-C-Ti" $data > /dev/null 2>&1

# Progress
caput "${PREFIX}m${MID}-EcTool-Prgs" 45 > /dev/null 2>&1

# Current loop proportional gain:
#ethercat upload -m$1 -p$2 0x8$310 0x13 --type uint16
data=$(/opt/etherlab/bin/ethercat upload -m${MID} -p$SID $SDOINDEX 0x13 --type uint16 | awk {'print $2'})
caput "${PREFIX_PVS}-C-Kp" $data > /dev/null 2>&1

# Progress
caput "${PREFIX}m${MID}-EcTool-Prgs" 60 > /dev/null 2>&1

# Velocity loop integral time:
#ethercat upload -m$1 -p$2 0x8$310 0x14 --type uint32
data=$(/opt/etherlab/bin/ethercat upload -m${MID} -p$SID $SDOINDEX 0x14 --type uint32 | awk {'print $2'})
caput "${PREFIX_PVS}-V-Ti" $data > /dev/null 2>&1

# Progress
caput "${PREFIX}m${MID}-EcTool-Prgs" 75 > /dev/null 2>&1

# Velocity loop proportional gain:
#ethercat upload -m$1 -p$2 0x8$310 0x15 --type uint32
data=$(/opt/etherlab/bin/ethercat upload -m${MID} -p$SID $SDOINDEX 0x15 --type uint32 | awk {'print $2'})
caput "${PREFIX_PVS}-V-Kp" $data > /dev/null 2>&1

# Progress
caput "${PREFIX}m${MID}-EcTool-Prgs" 90 > /dev/null 2>&1

# Position loop proportional gain:
#ethercat upload -m$1 -p$2 0x8$310 0x17 --type uint32
data=$(/opt/etherlab/bin/ethercat upload -m${MID} -p$SID $SDOINDEX 0x17 --type uint32 | awk {'print $2'})
caput "${PREFIX_PVS}-P-Kp" $data > /dev/null 2>&1

# Progress
caput "${PREFIX}m${MID}-EcTool-Prgs" 100 > /dev/null 2>&1

# Busy
caput "${PREFIX}m${MID}-EcTool-Stat" "IDLE" > /dev/null 2>&1
