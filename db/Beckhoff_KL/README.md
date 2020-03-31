## Directory contains configurations for Beckhoff KL terminals

KL terminals are Beckhoffs older range of hardware and use KL-Bus instead of EtherCAT
By using a BK1250 terminal (or BK1150), KL terminals can  be used in a EtherCAT system.

Note: KL terminals normaly have lower performance so EtherCAT terminals should be used where possible

The BL1250 coupler automatically scans the bus and generates pdos for the KL-terminals downstream.
All these pdo entries are accessed through the BK1250 coupler ethercat slave ID (ECMC_EC_SLAVE_NUM).
Terminals are adressed by their position relative the BK1250 starting with the first KL slave with at index 0 (2 digit hex without "0x").

### Outputs:
Outputs of KL slaves are mapped to SM2 pdo index 0x6<ECMC_KL_SLAVE_NUM>0 (for slave 00 => 0x6000, slave 0A 0x60A0...)

### Inputs:
Inputs of KL slaves are mapped to SM3 pdo index 0x7<ECMC_KL_SLAVE_NUM>0 (for slave 00 => 0x7000, slave 1A 0x71A0...)

### Example:
See example in: ecmccfg/examples/test/bk1250/bk1250.script

## Note:
All KL slaves after the BK1250 coupler needs to be configured. Otherwise the BK1250 will not go to "OP" state.
