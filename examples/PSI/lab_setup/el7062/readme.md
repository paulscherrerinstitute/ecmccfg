
# Start scan motor/tuning
Slave must be in OP and NOT enabled
```
CH1:
ethercat download -m0 -p3 0xfb00 0x1 --type octet_string "$(printf '\x07\x80')"
CH2:
ethercat download -m0 -p3 0xfb00 0x1 --type octet_string "$(printf '\x17\x80')"
```
# Check progress
```
ethercat upload -m0 -p3 0xfb00 0x2
watch -n 0.1 ethercat upload -m0 -p3 0xfb00 0x2

```
    The value of register FB00:02 "Status" indicates the progress of the scan. The values 100dec...199dec correspond to 0...99 %.


    Wait until register FB00:02 "Status" has one of the following values: 0, 1, 2, 3.
    Value 0: the scan has been successfully completed.
    Value 3: error. See chapter Error diagnosis.


# Upload inductance
```
ethercat upload -m0 -p3 0x8011 0x19 --type uint16
ethercat upload -m0 -p3 0x8111 0x19 --type uint16
```

# Upload resistance
```
ethercat upload -m0 -p3 0x8011 0x30 --type uint32
ethercat upload -m0 -p3 0x8111 0x30 --type uint32
```

# Current loop integral time
```
ethercat upload -m0 -p3 0x8010 0x12 --type uint16
ethercat upload -m0 -p3 0x8110 0x12 --type uint16
```

# Current loop proportional gain
```
ethercat upload -m0 -p3 0x8010 0x13 --type uint16
ethercat upload -m0 -p3 0x8110 0x13 --type uint16
```

# Velocity loop integral time
```
ethercat upload -m0 -p3 0x8010 0x14 --type uint32
ethercat upload -m0 -p3 0x8110 0x14 --type uint32
```

# Velocity loop proportional gain
```
ethercat upload -m0 -p3 0x8010 0x15 --type uint32
ethercat upload -m0 -p3 0x8110 0x15 --type uint32
```

# Position loop proportional gain
```
ethercat upload -m0 -p3 0x8010 0x17 --type uint32
ethercat upload -m0 -p3 0x8110 0x17 --type uint32
```

# Voltage Constant
Setting in CoE 0x8011:31 is in microV/min^-1
Example for Beckhoff AS2021 stepper. Data sheet Motor EMF Motor EMF 239 [mV/rad/s] 
This corrsponds to 25028microV/min^-1 which is the setting in CoE

# Other settings for AS2021 motor:

```
PS	CoE	0x1A04 C 0	01 00 10 12 10 60	download pdo 0x1A04 entries
PS	CoE	0x1A05 C 0	01 00 10 13 10 60	download pdo 0x1A05 entries
PS	CoE	0x1A0D C 0	01 00 10 14 10 60	download pdo 0x1A0D entries
PS	CoE	0x1A84 C 0	01 00 10 12 10 61	download pdo 0x1A84 entries
PS	CoE	0x1A85 C 0	01 00 10 13 10 61	download pdo 0x1A85 entries
PS	CoE	0x1A8D C 0	01 00 10 14 10 61	download pdo 0x1A8D entries
PS	CoE	0x1C12 C 0	04 00 00 16 06 16 80 16 86 16	download pdo 0x1C12 index
PS	CoE	0x1C13 C 0	07 00 00 1A 01 1A 03 1A 06 1A 80 1A 81 1A 86 1A	download pdo 0x1C13 index
IP	CoE	0xF081:01	0x00100000 (1048576)	
IP	CoE	0x10F3:05	0x0001 (1)	Enable DiagMessage as emergency
PS	CoE	0xF800:10	0x00005DC0 (24000)	DRV Amplifier Settings / Nominal DC link voltage
PS	CoE	0x8011:12	0x000007D0 (2000)	DRV Motor Settings Ch.1 / Rated current
PS	CoE	0x8011:18	0x000000D2 (210)	DRV Motor Settings Ch.1 / Rotor moment of inertia
PS	CoE	0x8011:19	0x017C (380)	DRV Motor Settings Ch.1 / Winding inductance
PS	CoE	0x8011:30	0x00000320 (800)	DRV Motor Settings Ch.1 / Winding resistance
PS	CoE	0x8011:31	0x000061C4 (25028)	DRV Motor Settings Ch.1 / Voltage constant
PS	CoE	0x8011:33	0x000000C8 (200)	DRV Motor Settings Ch.1 / Motor fullsteps per revolution
PS	CoE	0x8011:1B	0x000002A6 (678)	DRV Motor Settings Ch.1 / Motor speed limitation
PS	CoE	0x8011:34	0x000007D0 (2000)	DRV Motor Settings Ch.1 / Configured motor current
PS	CoE	0x8010:13	0x0044 (68)	DRV Amplifier Settings Ch.1 / Current loop proportional gain
PS	CoE	0x8010:12	0x0030 (48)	DRV Amplifier Settings Ch.1 / Current loop integral time
PS	CoE	0x8010:15	0x000003E8 (1000)	DRV Amplifier Settings Ch.1 / Velocity loop proportional gain
PS	CoE	0x8010:14	0x00000096 (150)	DRV Amplifier Settings Ch.1 / Velocity loop integral time
PS	CoE	0x8008:13	0x00001000 (4096)	FB Settings ENC Ch.1 / Encoder Increments per Revolution
PS	CoE	0x8008:12	RS422 differential (1)	FB Settings ENC Ch.1 / Encoder type
PS	CoE	0x8010:64	Stepper FOC with encoder (18)	DRV Amplifier Settings Ch.1 / Commutation type
PS	CoE	0x8010:17	0x0000000A (10)	DRV Amplifier Settings Ch.1 / Position loop proportional gain
PS	CoE	0x8010:57	0x64 (100)	DRV Amplifier Settings Ch.1 / Position loop velocity feed forward gain
PS	CoE	0x7010:03	Cyclic synchronous position mode (CSP) (8)	DRV Outputs Ch.1 / Modes of operation
```


