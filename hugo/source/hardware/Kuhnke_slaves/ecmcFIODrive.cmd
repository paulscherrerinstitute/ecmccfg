#-d /**
#-d   \brief hardware script for FIODrive
#-d   \details Kuhnke FIODrive (stepper and BLDC) with incremental feedback (differential rs422)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

epicsEnvSet("ECMC_EC_HWTYPE"             "FIODrive")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x0048554b")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0x0002ba67")

${SCRIPTEXEC} ${ecmccfg_DIR}slaveVerify.cmd

############# Factory reset
#
#-Reset drive with sdo command:
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x1011,0x1,1684107116,4)"
# NOTE IMPORTANT!! Drive will reboot to restore default parameters. Wait 5s to startup
epicsThreadSleep(1)
# Rebooting ${ECMC_EC_HWTYPE} 1s..
epicsThreadSleep(1)
# Rebooting ${ECMC_EC_HWTYPE} 2s..
epicsThreadSleep(1)
# Rebooting ${ECMC_EC_HWTYPE} 3s..
epicsThreadSleep(1)
# Rebooting ${ECMC_EC_HWTYPE} 4s..
epicsThreadSleep(1)
# Rebooting ${ECMC_EC_HWTYPE} 5s..

#############
#
#-Notes: The drive needs special startup sequence.
#-Control word needs to be set to:
#-1. 0hex
#-2. 80hex (Fault reset)
#-3. 6hex  (Shutdown)
#-4. 7hex  (Switch on)
#-5. Fhex  (Enable operation)
#
#############

############# Clear sync managers:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C12")
#<PS>,CoE,0x1C12:00,0x00 (0),clear sm pdos (0x1C12)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C13")
#<PS>,CoE,0x1C13:00,0x00 (0),clear sm pdos (0x1C13)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"

############# Configure PDO 0x1A00:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1A00")
#<PS>,CoE,0x1A00:00,0x00 (0),clear pdo 0x1A00 entries
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#<PS>,CoE,0x1A00:01,0x60410010 (1614872592),download pdo 0x1A00 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,1614872592,4)"
#<PS>,CoE,0x1A00:02,0x60640020 (1617166368),download pdo 0x1A00 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,1617166368,4)"
#<PS>,CoE,0x1A00:00,0x03 (3),download pdo 0x1A00 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"

############# Configure PDO 0x1A01:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1A01")
#<PS>,CoE,0x1A01:00,0x00 (0),clear pdo 0x1A01 entries
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#<PS>,CoE,0x1A01:01,0x60640020 (1617166368),download pdo 0x1A01 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,1617166368,4)"
#<PS>,CoE,0x1A01:00,0x01 (1),download pdo 0x1A01 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"

############# Configure PDO 0x1A02:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1A02")
#<PS>,CoE,0x1A02:00,0x00 (0),clear pdo 0x1A02
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#<PS>,CoE,0x1A02:01,0x60440010 (1615069200),download pdo 0x1A02 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,1615069200,4)"
#<PS>,CoE,0x1A02:00,0x01 (1),download pdo 0x1A02 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"

############# Configure PDO 0x1A03:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1A03")
#<PS>,CoE,0x1A03:00,0x00 (0),clear pdo 0x1A03 entries
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#<PS>,CoE,0x1A03:01,0x60FD0020 (1627193376),download pdo 0x1A03 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,1627193376,4)"
#<PS>,CoE,0x1A03:00,0x01 (1),download pdo 0x1A03 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"

############# Configure PDO 0x1600:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1600")
#<PS>,CoE,0x1600:00,0x00 (0),clear pdo 0x1600 entries
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#<PS>,CoE,0x1600:01,0x60400010 (1614807056),download pdo 0x1600 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,1614807056,4)"
#<PS>,CoE,0x1600:02,0x60420010 (1614938128),download pdo 0x1600 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,1614938128,4)"
#<PS>,CoE,0x1600:00,0x04 (4),download pdo 0x1600 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"

############# Configure PDO 0x1601:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1601")
#<PS>,CoE,0x1601:00,0x00 (0),clear pdo 0x1601 entries
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#<PS>,CoE,0x1601:01,0x607A0020 (1618608160),download pdo 0x1601 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,1618608160,4)"
#<PS>,CoE,0x1601:02,0x60810020 (1619066912),download pdo 0x1601 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,1619066912,4)"
#<PS>,CoE,0x1601:00,0x02 (2),download pdo 0x1601 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"

############# Configure PDO 0x1602:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1602")
#<PS>,CoE,0x1602:00,0x00 (0),clear pdo 0x1602 entries
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#<PS>,CoE,0x1602:01,0x60420010 (1614938128),download pdo 0x1602 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,1614938128,4)"
#<PS>,CoE,0x1602:00,0x01 (1),download pdo 0x1602 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"

############# Configure PDO 0x1603:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1603")
#<PS>,CoE,0x1603:00,0x00 (0),clear pdo 0x1603 entries
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
#<PS>,CoE,0x1603:01,0x60420010 (1614938128),download pdo 0x1603 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,1614938128,4)"
#<PS>,CoE,0x1603:00,0x01 (1),download pdo 0x1603 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"

############# Set sync managers:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C12")
#<PS>,CoE,0x1C12:01,0x1600 (5632),download pdo 0x1C12:01 index
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,5632,2)"
#<PS>,CoE,0x1C12:00,0x01 (1),download pdo 0x1C12 count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C13")
#<PS>,CoE,0x1C13:01,0x1A00 (6656),download pdo 0x1C13:01 index
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,6656,2)"
#<PS>,CoE,0x1C13:00,0x01 (1),download pdo 0x1C13 count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"

############# Configure PDOS:
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6040,0x0,16,driveControl01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6042,0x0,16,velocitySetpoint01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6041,0x0,16,driveStatus01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6064,0x0,32,positionActual01)"

############# Configure SDOS:
#Setup 256 fold microstepping
#-Encoder increments for 1 rev = 256*200=51200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x608F,0x1,51200,4)"
#-Per revs = 1
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x608F,0x2,1,4)"
#Phys encoder resolution for 1 rev = 256*200=51200
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2052,0x0,51200,4)"
#Mode= Velocity mode = 2 (csv = 9 not possible in open loop due to firmvare)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6060,0x0,2,1)"
#Drive sub mode select
#-Bit 0: Control mode: closed (1)/open loop (0)
#-Bit 1: VoS simulate speed controller: enable (1)/ disable (0)?
#-Bit 2: Brake: enable (1)/ disable (0)
#-Bit 3: Current reduction: enable (1)/ disable (0)
#-Bit 4: Not used
#-Bit 5: Torque (only valid in torque mode)?
#-Bit 6: Motor type: BLDC (1) / stepper (0)
#-Bit 7: Ferr ?
#-Bit 7..0: 2#00001000=>8
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x3202,0x0,8,4)"
#Current reduction delay = 1000ms
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2036,0x0,1000,4)"
#Current reduction  = 10% of max (if set to -50 then a reduction of 50%)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2037,0x0,-10,4)"
#Step counter as position
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x320A,0x4,-1,4)"
#Use ethercat (bit 4=1=>20)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2102,0x0,20,4)"

#Acceleration steps. Set high to minimize effect of the local trajectory generator (10000000 steps for one second)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6048,0x1,1000000,4)"
#Acceleration time. Set high to minimize effect of the local trajectory generator (1 second)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6048,0x2,1,2)"

#Deceleration steps. Set high to minimize effect of the local trajectory generator (10000000 steps for one second)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6049,0x1,1000000,4)"
#Deceleration time. Set high to minimize effect of the local trajectory generator (1 second)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6049,0x2,1,2)"

#Over Voltage limit=52000mv
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2034,0x0,52000,4)"
#Under Voltage limit=46000mv
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x2035,0x0,44000,4)"
