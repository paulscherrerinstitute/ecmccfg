# EtherCAT slave description file parser (ESI/XML) WIP

## Call
```
#- Generate hw snippet (WIP) PDOS in top and (commented) SDOs in bottom:
python3 parse_ec_esi_xml.py -b ../../beckhoff_xml/ -d CMMT-ST-MP-S0 -r 0x00000021 -o test.txt | tee test.test 
python3 parse_ec_esi_xml.py -b ../../beckhoff_xml/ -d EL7041-0052 -r 0x00100034 -o test.cmd
#- List available devices and version in the xml lib
python3 parse_ec_esi_xml.py -b ../../beckhoff_xml/ -l
```
