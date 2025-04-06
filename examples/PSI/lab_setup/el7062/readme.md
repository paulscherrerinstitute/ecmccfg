
# Start scan motor/tuning
Slave must be in OP and NOT enabled
´´´
CH1:
ethercat download -m0 -p3 0xfb00 0x1 --type octet_string "$(printf '\x07\x80')"
CH2:
ethercat download -m0 -p3 0xfb00 0x1 --type octet_string "$(printf '\x17\x80')"
´´´
# Check progress
´´´
ethercat upload -m0 -p3 0xfb00 0x2
watch -n 0.1 ethercat upload -m0 -p3 0xfb00 0x2

´´´
    The value of register FB00:02 "Status" indicates the progress of the scan. The values 100dec...199dec correspond to 0...99 %.


    Wait until register FB00:02 "Status" has one of the following values: 0, 1, 2, 3.
    Value 0: the scan has been successfully completed.
    Value 3: error. See chapter Error diagnosis.


# Upload inductance
´´´
ethercat upload -m0 -p3 0x8011 0x19 --type uint16
ethercat upload -m0 -p3 0x8111 0x19 --type uint16
´´´

# Upload resistance
´´´
ethercat upload -m0 -p3 0x8011 0x30 --type uint32
ethercat upload -m0 -p3 0x8111 0x30 --type uint32
´´´

# Current loop integral time
´´´
ethercat upload -m0 -p3 0x8010 0x12 --type uint16
ethercat upload -m0 -p3 0x8110 0x12 --type uint16
´´´

# Current loop proportional gain
´´´
ethercat upload -m0 -p3 0x8010 0x13 --type uint16
ethercat upload -m0 -p3 0x8110 0x13 --type uint16
´´´

# Velocity loop integral time
´´´
ethercat upload -m0 -p3 0x8010 0x14 --type uint32
ethercat upload -m0 -p3 0x8110 0x14 --type uint32
´´´

# Velocity loop proportional gain
´´´
ethercat upload -m0 -p3 0x8010 0x15 --type uint32
ethercat upload -m0 -p3 0x8110 0x15 --type uint32
´´´

# Position loop proportional gain
´´´
ethercat upload -m0 -p3 0x8010 0x17 --type uint32
ethercat upload -m0 -p3 0x8110 0x17 --type uint32
´´´

# Voltage Constant
Setting in CoE 0x8011:31 is in microV/min^-1
Example for Beckhoff AS2021 stepper. Data sheet Motor EMF Motor EMF 239 [mV/rad/s] 
This corrsponds to 25028microV/min^-1 which is the setting in CoE




