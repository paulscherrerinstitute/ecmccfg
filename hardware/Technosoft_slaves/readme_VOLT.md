# Run drive as pure voltage source
The ecmciPOS8020BX_VOLT is dedicated for pure volatge mode (open loop brushed DC).
The drive needs to be set in a certin mode (MODE VES, see below)
The TML variable access SDOs addresses are used for the communication so must not be used for something else.

## TML code needed
Add the follwing in TML online window (Easy setup). Later a proper software needs to be compiled but the a EasyMotion Studio is needed wich requires a license.

TML code in EasySetup:
```
# Set to voltage mode
MODE VES

# Normally not needed (take voltage ref from ERES variable)
EXTRES 0

# Apply setting (Update)
UPD
```
## Check current voltage setpoint EREF
Check voltage setpoint
```
? EREF
```
# Write new voltage setpoint
16bit (+-15bits +-32768):
```
caput c6025a-04:m0s017-Drv01-Eref 32000
```
In test setup 32000 corresponds to 22V (powersupply 24V)

# Use ethercat tool to write to EREF

source writeToEREF.sh <16 bit data in hex without 0x>:
```
# source writeToEREF.sh <16 bit data in hex without 0x>
# CFG
#0084=16 bit cfg
# 02A9 is the address of EREF(H)
# => write 0x2064 0x0 0x008402A8

CFG=0084
ADR=02A9
DATA=$1

ethercat download --type uint32 -m0 -p17 0x2064 0x0 0x$ADR$CFG
ethercat download --type uint32 -m0 -p17 0x2067 0x0 0x$ADR$DATA
```
