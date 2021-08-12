#-d /**
#-d   \brief hardware script for iPOSXXXX
#-d   \details 
#-d   \author Anders Sandstroem
#-d   \file
#-d */

############# Clear sync managers:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C12")
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
epicsThreadSleep(0.01)
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C13")
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
epicsThreadSleep(0.01)

############################################################
############# Configure PDO 0x1A00:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1A00")
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1A00:01,0x60410010 (1614872592),download pdo 0x1A00 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,1614872592,4)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1A00:02,0x60640020 (1617166368),download pdo 0x1A00 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,1617166368,4)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1A00:00,0x03 (3),download pdo 0x1A00 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"
epicsThreadSleep(0.01)

############################################################
############# Configure PDO 0x1A01:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1A01")
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
epicsThreadSleep(0.01)
#Digital Inputs
#<PS>,CoE,0x1A01:01,0x60FD0020 (),download pdo 0x1A01 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x60FD0020,4)"
epicsThreadSleep(0.01)
#Digital Outputs status#Set action if communication is lost (Quickstop=3, Diasble voltage=2, Execute fault routine = 1, No action (continue running)=0)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x6007,0x0,3,2)"
epicsThreadSleep(0.01)

#<PS>,CoE,0x1A01:02,0x20450010 (),download pdo 0x1A01 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x20450010,4)"
epicsThreadSleep(0.01)
#Current Act
#<PS>,CoE,0x1A01:02,0x60770010 (),download pdo 0x1A01 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x3,0x60770010,4)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1A01:00,0x01 (1),download pdo 0x1A01 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,3,1)"
epicsThreadSleep(0.01)

############################################################
############# Configure PDO 0x1A02:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1A02")
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
epicsThreadSleep(0.01)
#Analog input reference
#<PS>,CoE,0x1A02:01,0x20460010 (),download pdo 0x1A02 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x20460010,4)"
epicsThreadSleep(0.01)
#Analog input feedback
#<PS>,CoE,0x1A02:02,0x20470010 (),download pdo 0x1A02 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x20470010,4)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1A02:02,0x20550010 (),download pdo 0x1A02 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x3,0x20550010,4)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1A02:02,0x20580010 (),download pdo 0x1A02 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x4,0x20580010,4)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1A02:00,0x01 (1),download pdo 0x1A02 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,4,1)"
epicsThreadSleep(0.01)

############################################################
############# Configure PDO 0x1A03:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1A03")
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
epicsThreadSleep(0.01)
#Feedback connector 2 position (depends on setup loaded in drive)
#<PS>,CoE,0x1A03:01,0x60630020 (),download pdo 0x1A03 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x60630020,4)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1A03:00,0x01 (1),download pdo 0x1A03 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,1,1)"
epicsThreadSleep(0.01)

############################################################
############# Configure PDO 0x1600:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1600")
#<PS>,CoE,0x1600:00,0x00 (0),clear pdo 0x1600 entries
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1600:01,0x60400010 (1614807056),download pdo 0x1600 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,1614807056,4)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1600:02,0x60FF 0020 (1627324448),download pdo 0x1600 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,1627324448,4)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1600:00,0x02 (2),download pdo 0x1600 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"
epicsThreadSleep(0.01)

############################################################
############# Configure PDO 0x1601:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1601")
#<PS>,CoE,0x1601:00,0x00 (0),clear pdo 0x1601 entries
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,0,1)"
epicsThreadSleep(0.01)
#Digital Outputs
#<PS>,CoE,0x1601:01,0x60FE0120 (1627324448),download pdo 0x1601 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,0x60FE0120,4)"
epicsThreadSleep(0.01)
#Digital Outputs Mask
#<PS>,CoE,0x1601:02,0x60FE0220 (1627324448),download pdo 0x1601 entry
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,0x60FE0220,4)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1601:00,0x02 (2),download pdo 0x1601 entry count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"
epicsThreadSleep(0.01)
############################################################
############# Set sync managers:
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C12")
#<PS>,CoE,0x1C12:01,0x1600 (5632),download pdo 0x1C12:01 index
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,5632,2)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1C12:01,0x1601 (5633),download pdo 0x1C12:02 index
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,5633,2)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1C12:00,0x01 (1),download pdo 0x1C12 count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,2,1)"
epicsThreadSleep(0.01)
epicsEnvSet("ECMC_SDO_INDEX",              "0x1C13")
#<PS>,CoE,0x1C13:01,0x1A00 (6656),download pdo 0x1C13:01 index
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x1,6656,2)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1C13:02,0x1A01 (6657),download pdo 0x1C13:02 index
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x2,6657,2)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1C13:03,0x1A02 (6658),download pdo 0x1C13:03 index
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x3,0x1A02,2)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1C13:04,0x1A03 (6659),download pdo 0x1C13:04 index
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x4,0x1A03,2)"
epicsThreadSleep(0.01)
#<PS>,CoE,0x1C13:00,0x02 (2),download pdo 0x1C13 count
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},$(ECMC_SDO_INDEX),0x0,4,1)"
#epicsThreadSleep(1.0)

#############################################################
############# Configure PDOS:

epicsEnvSet("ECMC_CH_ID",              "01")
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x6040,0x0,16,driveControl${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1600,0x60FF,0x0,32,1,velocitySetpoint${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x60FE,0x1,32,binaryOutputArray${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1601,0x60FE,0x2,32,binaryOutputArrayMask${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6041,0x0,16,driveStatus${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6064,0x0,32,positionActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6077,0x0,16,currentActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x60FD,0x0,32,binaryInputArray${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x2045,0x0,16,binaryOutputArrayReadBack${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2046,0x0,16,analogInput01)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2047,0x0,16,analogInput02)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2055,0x0,16,voltageActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x2058,0x0,16,temperatureActual${ECMC_CH_ID})"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6063,0x0,32,positionActual02)"
epicsEnvUnset(ECMC_CH_ID)

#############################################################
############# Settings:

#Set velocity mode (9)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6060,0x0,9,1)"
epicsThreadSleep(0.01)
#Set sample time 1*10^-3)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x60C2,0x1,1,1)"
epicsThreadSleep(0.01)
#Set sample time exponent =-3
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x60C2,0x2,-3,1)"
epicsThreadSleep(0.01)
#Set action if communication is lost (Quickstop=3, Diasble voltage=2, Execute fault routine = 1, No action (continue running)=0)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6007,0x0,3,2)"
epicsThreadSleep(0.01)
