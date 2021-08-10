# ToBas

## SyncManager 2
inputs

### Base address
- 0x1600

#### SDO 0x2003, "3rd ADI - Enable"
- uint8
- 0x2003 0x01 -- 0x28 --> 8 bit

#### SDO 0x2004, "4th ADI - Alarm High"
- uint16
- 0x2004 0x01 -- 0x28 --> 16 bit

#### SDO 0x2005, "5th ADI - Alarm Low"
- uint16
- 0x2005 0x01 -- 0x28 --> 16 bit

#### SDO 0x200b, "11th ADI - Spare Input"
- uint8
- 0x200b 0x01 -- 0x14 --> 8 bit

#### SDO 0x200c, "13th ADI - Mode/Calib"
- uint16
- 0x200c 0x00 8 bit

## SyncManager 3
outputs

### Base address
- 0x1a00

#### SDO 0x2001, "1st ADI - Temperature"
- uint32
- 0x2001 0x01 -- 0x28 --> 32 bit

#### SDO 0x2002, "2nd ADI - Status"
- uint8
- 0x2002 0x01 -- 0x28 --> 8 bit

#### SDO 0x2006, "6th ADI - SUM ILK"
- uint8
- 0x2006 0x00 8 bit

#### SDO 0x2007, "7th ADI - Identification"
- uint8
- 0x2007 0x00 8 bit

#### SDO 0x2008, "8th ADI - Revision"
- uint32
- 0x2008 0x00 32 bit

#### SDO 0x2009, "9th ADI - ExtSens Val"
** NOTE: for some weird reason this starts at '0' **
- uint32
- 0x2009 0x00 -- 0x0c 32 bit

#### SDO 0x200a, "10th ADI - ExtSens Stat"
- uint8
- 0x200a 0x00 8 bit
