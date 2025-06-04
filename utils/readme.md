# ecmc utilities
## PDO read

Tool to read data from slaves (actually SDO data).

## esi parser

NOTE: Right now only supports slaves with several alternative PDO mappings..
```
# python3.12 -m venv ~/myhome/python/esi_parser
# source ~/myhome/python/esi_parser/bin/activate
# pip3 install lxm
source ~/myhome/python/esi_parser/bin/activate
python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x1*" --filtSlaves "1" --filtPdoMaps "1,2,3,5" --outputJSON parsed_devices.json --outputECMC "" --mergeEntries 1
python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x1000*" --filtSlaves "1" --filtPdoMaps "1" --outputJSON parsed_devices.json --outputECMC "" --mergeEntries 1
python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL72xx.xml --name "EL7211*" --rev "*" --filtSlaves "1" --outputJSON parsed_devices.json --outputECMC "" --mergeEntries 1


 1122  mv qt/ecmcEL1259_CH8_EV10.ui qt/ecmcEL1259_0x120000_CH8_EV10.ui 
 1123  git status
 1124  git mv utils/ecmcEL1259_0x120000_CH2_EV1.cmd utils/ecmcEL1259_0x120000_CH2_EV10.cmd
 1125  python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*"
 1126  cd utils/
 1127  python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*"
 1128   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "9" --outputJSON parsed_devices.json --outputECMC "_CH2_EV10" --mergeEntries 1
 1129  python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*"
 1130   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "11" --outputJSON parsed_devices.json --outputECMC "_CH2_EV2" --mergeEntries 1
 1131  python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*"
 1132   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "10" --outputJSON parsed_devices.json --outputECMC "_CH2_EV5" --mergeEntries 1
 1133  python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*"
 1134   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "16" --outputJSON parsed_devices.json --outputECMC "_CH1_EV1" --mergeEntries 1
 1135   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "15" --filtPdoMaps "16" --outputJSON parsed_devices.json --outputECMC "_CH1_EV2" --mergeEntries 1
 1136   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "15" --filtPdoMaps "15" --outputJSON parsed_devices.json --outputECMC "_CH1_EV2" --mergeEntries 1
 1137  python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*"
 1138   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "15" --filtPdoMaps "15" --outputJSON parsed_devices.json --outputECMC "_CH1_EV2" --mergeEntries 1
 1139   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "15" --outputJSON parsed_devices.json --outputECMC "_CH1_EV2" --mergeEntries 1
 1140   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "14" --outputJSON parsed_devices.json --outputECMC "_CH1_EV5" --mergeEntries 1
 1141   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "13" --outputJSON parsed_devices.json --outputECMC "_CH1_EV10" --mergeEntries 1
 1142  python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*"
 1143   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "8" --outputJSON parsed_devices.json --outputECMC "_CH4_EV1" --mergeEntries 1
 1144   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "7" --outputJSON parsed_devices.json --outputECMC "_CH4_EV2" --mergeEntries 1
 1145   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "6" --outputJSON parsed_devices.json --outputECMC "_CH4_EV5" --mergeEntries 1
 1146   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "5" --outputJSON parsed_devices.json --outputECMC "_CH4_EV10" --mergeEntries 1
 1147  python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*"
 1148   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "4" --outputJSON parsed_devices.json --outputECMC "_CH8_EV1" --mergeEntries 1
 1149   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "3" --outputJSON parsed_devices.json --outputECMC "_CH8_EV2" --mergeEntries 1
 1150   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "2" --outputJSON parsed_devices.json --outputECMC "_CH8_EV5" --mergeEntries 1
 1151   python3 esi_parser.py --file ../../../beckhoff_xml/Beckhoff\ EL1xxx.xml --name "EL1259*" --rev "0x12000*" --filtSlaves "1" --filtPdoMaps "1" --outputJSON parsed_devices.json --outputECMC "_CH8_EV10" --mergeEntries 1


```
## Read EL70xx diagnostic, read_el70xx_diag.sh

A tool that reads error and warning state of a EL70xx stepper drive. The error and warning diagnostics are read from the 0xA010 register.

Note: The PDO_read tool can also be used to read these diagnostics.

The script must be executed on the ecmc server where the the EL70xx slave is connected.

```bash
bash read_el70xx_diag.sh <master_id> <slave_id>
```

Example: master 0, slave 3, drive under voltage warning
```bash
bash read_el70xx_diag.sh 0 3

#########################################################
Reading el70xx status at masterid 0 and slave id 3:

Saturated:
0x00 0
Over temperature:
0x00 0
Torque overload:
0x00 0
Under voltage:
0x01 1
Over voltage:
0x00 0
Short circuit A:
0x00 0
Short circuit B:
0x00 0
No control power:
0x00 0
Misc error:
0x00 0

#########################################################

```

For more information check docs for [Index A010 STM Diag data Ch.1](https://infosys.beckhoff.com/english.php?content=../content/1033/el70x1/2286662027.html&id=126846504617985959)

## Read EL5042 diagnostic, read_el5042_diag.sh
Read diagnostics from EL5042

Example: master 1, slave 14, ch 0
```bash
bash read_el5042_diag.sh 1 14 0

#########################################################
Reading EL5042 Ch 0 status at master id 1 and slave id 14:

Power supply present:
0x01 1
Error:
0x00 0
SDC Error:
0x00 0
WD Error:
0x00 0
Data valid:
0x01 1
Data raw value:
0xd00000007f231e1b 14987979562022018587

#########################################################
```
For more information check docs for [Index A0p8 FB BiSS-C Diag data (for Ch.1, p = 0; Ch.2, p = 1)](https://infosys.beckhoff.com/english.php?content=../content/1033/el5042/4216754315.html&id=695067345900842552)
