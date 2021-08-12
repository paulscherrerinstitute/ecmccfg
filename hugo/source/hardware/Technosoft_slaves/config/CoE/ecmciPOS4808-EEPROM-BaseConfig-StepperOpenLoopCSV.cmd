#-d /**
#-d   \brief hardware script for iPOS4808-EEPROM-BaseConfig-StepperOpenLoopCSV
#-d   \details
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note
#-d */

#-########################################################
#-  Parsing of Technosoft setup-file to ECMC format.
#-     Input file name: ipos4808/ESM_projects/iPOS4808-BX-CAT_Base_V1_0_EEPROM_prog_file.sw
#-     Input file start adress: 0x7b78
#-     Output file name: ../ecmcIPOS4808-EEPROM-BaseConfig-StepperOpenLoopCSV
#-     Date: 2018/01/24 09:40:21
#-########################################################
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2064,0x0,0x7B780008,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x649C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2711,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x152,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x132,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1AE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x252,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x465,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x250,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x251,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x257,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x928,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x253,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB0B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x299,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7837,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x29A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8499,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x29B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1684,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x986,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3330,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x98C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x15D8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x254,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x147B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8CC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x917,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x913,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x300,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC53F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x304,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x302,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x6006,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x303,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x912,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2501,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x272,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x271,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5E9D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x274,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x273,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2AEF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x275,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x147B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x276,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x147B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x982,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x223,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x268,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x267,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x66EA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x269,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x41DE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x775C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x6334,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x25F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x25E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x62CC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x261,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x260,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x544F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x263,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x262,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4D30,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x264,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xCCD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x266,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7EC6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x265,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x79E1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x292,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x291,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x270,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x295,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1CCB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2C4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x10,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2C5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7D0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2C6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBB8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x879,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x87A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBB8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x298,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x818,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x17AD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x819,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA17,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x25D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x25C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x246,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FF8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x249,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x29D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7B2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x86F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x876,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x255,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x256,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x284,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x64,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x285,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x64,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x90C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x90A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xE000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x90B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC00F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x95C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1F40,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x953,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x64,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x36A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x6400,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x36B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x857,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FBB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x832,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x27D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4BD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x27E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x27B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x17AD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x27C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x281,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2BF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x282,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x27F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x641,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x287,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x42AB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x280,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x24A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x666,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2FB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x120,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9E9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8543,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x396,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x397,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x398,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x399,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x39A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x39B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x380,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x381,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9B6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x201,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2A7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x386,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x823,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x805,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x801,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x802,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC800,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x806,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x286,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1600,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9F9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9FA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9FF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x64,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9DD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x99C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x32,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x99D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x230,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x807,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9E2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7AB0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9DE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x881,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x880,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x999,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x820,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x99A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x863B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9FC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9FD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x51E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x833,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x803,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x14,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2C7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x89B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x333,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x888,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x12,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x896,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1F4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x892,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x893,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x148,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x894,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x895,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x89C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9F8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x14,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x39F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8AC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8AD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x916,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2FD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2FE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2FC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x6E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2FF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2FA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x140A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x855,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x854,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2BF1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x841,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x842,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x843,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x844,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x845,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x846,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2F9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF06,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF07,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x289,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x847,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x849,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7D00,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x948,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x947,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x980,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x16E2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x24E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFA0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x24C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3333,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x333,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x37C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xCCCD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9E0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7D0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x814,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC953,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x10,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2A2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xF93E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAAAE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x29,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2AC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x874,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x50,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9CA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2726,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1813,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9CC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2038,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1721,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9CE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x808,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA09,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9D0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9D2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8B96,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA49B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9D4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9D6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9D8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x386,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x388,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x38A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x38C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x38E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x390,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x392,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x394,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x88A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x88C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFFFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x84C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x84A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC800,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7F0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x800,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7F2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFFFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x22A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7F4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x30B3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7F6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x808,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x800,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7F8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA080,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x918,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFF8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFFA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFFC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFFE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF00,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF02,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF04,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF06,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF08,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF0C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF0E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF10,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF12,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF14,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF18,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF1A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF1C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF1E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF20,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF24,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF26,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF28,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF2A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF2C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF30,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF32,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF34,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF36,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF38,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF3C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF3E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF40,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF42,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF44,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF48,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF4A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF4C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF4E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF50,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF54,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF56,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF58,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF5A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF5C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF60,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF62,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF64,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF66,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF68,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF6C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF6E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF70,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF72,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF74,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8C8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8B0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8B2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFA0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8C0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFFFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x89E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFD71,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8A4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x808,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3A4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3A2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3A6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x199A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80A3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80A4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x100,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA950,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4CAB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8150,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x806E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8002,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x40A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80A5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3333,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4053,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8058,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4130,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4250,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8050,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4100,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8051,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4220,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8053,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4100,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8052,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x41A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8054,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x999A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x42CC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8056,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD70A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3C23,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8057,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F00,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8001,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8016,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4240,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8060,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8061,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xCCCD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x406C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8064,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD70A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3D23,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8065,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xDF03,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3EF5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8066,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x277,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3B12,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8067,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8376,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xF40D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x21F5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3EB4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8068,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80B2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1F4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80AA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC5AC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x36A7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80A6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80A7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFDB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x40C9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80A8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFDB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x40C9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8073,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8074,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8075,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x457A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8076,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x44D4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x800B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x800C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x800D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x447A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x801A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x42A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x807D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x68F1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x88E3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xF8B5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3EF4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8036,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x803D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA0D8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x42D5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x803B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F00,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x803A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F00,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8039,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xCCCD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3DCC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8038,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xCCCD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3DCC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8037,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x800E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x800F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8010,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x447A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x801B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x42A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8080,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8047,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFDB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4149,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F00,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F00,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8081,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8082,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8083,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8084,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x810A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80B9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80BA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80BB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2DE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80BC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80BD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80BE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80BF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2DE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2DE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80D5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80D6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80D7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80D8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80D9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4079,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80DA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80DB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80DC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80DD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80DE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80DF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80E0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80E1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80E2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80E3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80E4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80E5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80E6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80E7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80E9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80EA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80EB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2DE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80EC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80ED,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80EE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80EF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2DE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80F0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80F1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80F2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80F3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2DE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80F4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80F5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80F6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80F7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2DE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80F8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80F9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80FA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80FB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2DE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80FC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80FD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80FE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80FF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2DE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8100,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8101,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8102,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8103,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2DE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA090,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8104,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x407F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8009,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x800A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80A1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80A9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8085,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80B6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80B7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x458D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80B8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4449,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80B3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80B4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5C29,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x403F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80B5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB53E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x809A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC5AC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x36A7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x809B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC5AC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x36A7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8003,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x37BD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3706,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8004,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC5AC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3727,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8005,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB717,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x37D1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8006,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB717,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3851,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xE95A,4)"
epicsThreadSleep(0.01)
#-Setup drive to calculate online checksum (0x7b78:0x7faf):
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2069,0x0,0x7faf7b78,4)"
epicsThreadSleep(0.01)
#-########################################################
#-     Total number of lines parsed: 1080
#-     Offline calculated checksum: 0xd2b4 (53940)
#-     Online calculated checksum (in drive) (in dec..):
ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,2)"
ecmcConfigOrDie "Cfg.EcVerifySdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,0xd2b4,2)"
#-########################################################
#-Reset drive to apply settings:
#-NOTE: Reset drive command will return error -5 since no repsonse is sent back to the master! The drive will be reset anyway!
ecmcConfig "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2080,0x0,1,2)"
epicsThreadSleep(0.01)
