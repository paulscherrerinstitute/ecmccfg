# Technosoft EasyMotion Config over FoE (File over EtherCAT)

## Requirements from Technosoft CoE manual (https://technosoftmotion.com/wp-content/uploads/2019/10/P091.064.EtherCAT.iPOS_.UM.pdf):
1. The FoE file must start with “FOESW_”.
2. The entire FoE file name length must not exceed 14 characters (actually including extension).
3. A Setup data file can be transferred via FoE protocol only in OP, PREOP and SAFEOP (BOOTSTRAP rejects download)
4. The password to program a FoE setup data file is 0.

## Configure drive (download file, write file):
1. Identify correct bin configuration file (see sub dirs in FoE dir)
2. ethercat -p<slaveid> foe_write <filename>
3. power cycle of drive is needed in order to load the new config.

### Example:
```
ethercat -p0 foe_write FOESW_8020.bin
# Do not forget power cycle
```
## Upload file (read file):
1. You must know the name of the file on the slave
2. ethercat -p<slaveid> foe_read <filename> > <output filename>
Note: Seems the "-o" or "--output-file" is not working.

### Example:
```
ethercat -p0 foe_read FOESW_8020.bin > test.bin

```

## Generate new config file in EasyMotion Studio:
1. Make your configuration
2. Application->Create EtherCAT FOE File->Setup Only
3. Choose filename and save (note: max 14 chars).
4. Store the file in ecmccfg/hardware/Technosoft_slaves/config/FoE/<suitable_dir_name>/<suitable_file_name>
5. Add a README.md file in cmccfg/hardware/Technosoft_slaves/config/FoE/<suitable_dir_name>/ describing the config:
* Drive type (8020BX-CAT or 4808BX-CAT)
* DC-link voltage (48V)
* Control mode (normally always CSV)
* ...
