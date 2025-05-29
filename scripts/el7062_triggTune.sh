#!/bin/bash
echo "EL7062: Executing tuning: Prefix=$4, Master=$1, Slave=$2, Ch=$3, "
MID=$1
SID=$2
CID=$3
PREFIX=$4

# Busy
caput "${PREFIX}m${MID}-EcTool-Stat" "BUSY" > /dev/null 2>&1
ok=0

# Trigger tune
if [[ $CID -eq "1" ]]; then
   /opt/etherlab/bin/ethercat download -m${MID} -p$SID 0xfb00 0x1 --type octet_string "$(printf '\x07\x80')"
   ok=1
elif [[ $CID -eq "2" ]]; then
   /opt/etherlab/bin/ethercat download -m${MID} -p$SID 0xfb00 0x1 --type octet_string "$(printf '\x17\x80')"
   ok=1
fi

if [[ $ok -eq "0" ]]; then
  caput "${PREFIX}m${MID}-EcTool-Stat" "ERROR" > /dev/null 2>&1
  echo "Error, wrong channel id"
  exit -1
fi

# Check status
for i in $(seq 1 40);
do
  status=$(/opt/etherlab/bin/ethercat upload -m${MID} -p$SID 0xfb00 0x2 --type uint8 | awk {'print $2'})
  #echo "Status: $status"
  if [[ $status -eq "3" ]]; then
    echo "Error"
    caput "${PREFIX}m${MID}-EcTool-Stat" "ERROR" > /dev/null 2>&1
    break 1
  fi

  if [[ $status -ge "100" ]]; then
    progress=$(($status-100))
    #echo "Progress: $progress"
    caput "${PREFIX}m${MID}-EcTool-Prgs" $progress > /dev/null 2>&1
  fi

  if [[ $status -eq "0" ]]; then
    break 1
  fi

  sleep 0.5
done

if [[ $status -ne "0" ]]; then
   echo "Error"
   caput "${PREFIX}m${MID}-EcTool-Stat" "ERROR" > /dev/null 2>&1
   exit -1
fi

if [[ $ok -eq "0" ]]; then
  echo "Error"
  caput "${PREFIX}m${MID}-EcTool-Stat" "ERROR" > /dev/null 2>&1
  exit -1
fi
 
# Excute readback
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
$DIR/el7062_readBackParams.sh $MID $SID $CID $PREFIX

echo "Tuning successfull"
caput "${PREFIX}m${MID}-EcTool-Prgs" 100 > /dev/null 2>&1

#echo "Progress: Done"
caput "${PREFIX}m${MID}-EcTool-Stat" "IDLE" > /dev/null 2>&1
