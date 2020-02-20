## Download Technosoft EasyMotion Config over FoE (FileOverEtherCAT)


# Requirements from Technosoft CoE manual (https://technosoftmotion.com/wp-content/uploads/2019/10/P091.064.EtherCAT.iPOS_.UM.pdf):
1. The FoE file must start with “FOESW_”.
2. The entire FoE file name length must not exceed 14 characters. The extension is excluded.
3. A Setup data file can be transferred via FoE protocol only in OP, PREOP and SAFEOP (BOOTSTRAP rejects)
4. The password to program a FoE setup data file is 0.


# Download file:
1. Identify correct bin configuration file (see directories in FoE folder)
2. ethercat -p<slaveid> foe_write <filename>

# Example:
```
ethercat -p0 foe_write FOESW_8020.bin

```

