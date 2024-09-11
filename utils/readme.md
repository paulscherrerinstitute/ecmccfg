# ecmc utilities
## PDO read

Tool to read data from slaves (actually SDO data).

## EtherCAT slave description file parser (ESI/XML) WIP

Call:
```
#- Generate hw snippet (WIP) PDOS in top and (commented) SDOs in bottom:
python3 parse_ec_esi_xml.py -b ../../beckhoff_xml/ -d CMMT-ST-MP-S0 -r 0x00000021 -o test.txt | tee test.test 
python3 parse_ec_esi_xml.py -b ../../beckhoff_xml/ -d EL7041-0052 -r 0x00100034 -o test.cmd
#- List available devices and version in the xml lib
python3 parse_ec_esi_xml.py -b ../../beckhoff_xml/ -l -o slask.txt
```

### Known issues
* Outputfile seems not to be written. Pipe to file instead..
* Outpuit need manual editing


## Read EL70xx diagnostic, read_el70xx_diag.sh

A tool that reads error and warning state of a EL70xx stepper drive. The error and warning diagnostics are read from the 0xA010 register.

Note: The PDO_read tool can also be used to read these diagnostics.

The script must be executed on the ecmc server where the the EL70xx slave is connected.

```bash
bash read_el70xx_diag.sh <master_id> <slave_id>
```

Example: master 0, slave 3, drive under voltage warning
```bash
bash read_el7041_diag.sh 0 3

#########################################################
Reading EL7041 status at masterid 0 and slave id 3:

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

