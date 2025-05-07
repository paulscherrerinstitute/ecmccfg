#########################################################
#  Parsing of Technosoft setup-file to ECMC format.
#      Input file name: DC48V_TRQ_MODE_40A_AND_TML.sw
#      Block start adress: 0x7abf
#      Output file name: DC48V_TRQ_MODE_40A_AND_TML.cmd
#      Date: 2024/06/28 10:03:30
#########################################################

ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2064,0x0,0x7ABF0008,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x649C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2E45,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x16E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x198,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1E5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x252,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8CA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x250,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x251,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x14,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x257,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x98D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x928,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x253,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1E1E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x299,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7837,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x29A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD227,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x29B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1B85,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x986,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FFC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x98C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9B6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x254,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA3D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8CC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x917,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x913,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x300,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9100,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x304,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x302,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x6206,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x303,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x912,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4104,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x272,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x271,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x274,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x273,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x275,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA3D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x276,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA3D,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x267,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x501F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x269,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7CBA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4CCE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x25F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x25E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4135,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x261,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x260,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x22C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x263,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x262,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5182,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x264,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x266,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x6664,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x265,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FF8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2C4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2C5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2C6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBB8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x879,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xCCC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x819,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8BD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x25D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x25C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x151,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x63E,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7D17,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E8,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2FB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF28,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF29,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2FA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB40,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x855,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x854,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2327,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x847,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9E9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5643,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9B6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x201,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5002,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2A7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3CE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x823,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9F6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9F7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9F4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9F5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7E0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7E1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7E2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7E3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7E4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7E5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x64,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7E6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x25E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7E7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x25F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x260,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7E9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x261,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7EA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x262,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7EB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x263,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7EC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x266,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7ED,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x267,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7EE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x268,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7EF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x269,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7F0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7F1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x26C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7D6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2B4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF36,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBE8A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF10,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7993,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x99A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x90BA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9FC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9FD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFFFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x805,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x916,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x289,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x23B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9F8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x64,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9F0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x932,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB9F2,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x99D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x230,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x947,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x948,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF04,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF05,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF0A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF19,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF24,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF18,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7DC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x32C8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF2F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF6F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFEC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFED,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF7E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF7F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF78,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF73,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x926,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x965,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFFFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF82,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF9A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF9B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF79,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF7A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF7B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7FFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF83,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF8A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF72,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF9D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2402,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x980,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x95C3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x70,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x24E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7D0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x24C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC49C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x20,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9E0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x814,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x43DB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2A2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2EE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x64,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2AC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9CA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2726,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1813,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9CC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3817,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x908,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9CE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x38C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x38E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x390,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E8,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x122A,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x918,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB7CC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBE80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5C29,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x28F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBE82,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBE84,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBE86,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBE88,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF00,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4B86,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F92,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF02,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5285,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3ED3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF04,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9012,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F23,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF06,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9014,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FA3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF08,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9014,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F23,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFC35,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x37C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x992,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF00,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF02,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF1A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x92EF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBF46,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF1C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF1E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB445,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3DE5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF20,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB445,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3DE5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF22,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFDC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7043,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F02,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFDE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3822,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F41,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFE2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7043,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F02,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFE4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3822,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F41,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFE8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBFEA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAAE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7D0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAB0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAB6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7D0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAB8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAB2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAB4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBACA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBACC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAA2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAA4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAAA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAAC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAA6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAA8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBABE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x100,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAC0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAC2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBAC4,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF80,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF94,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF70,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9C40,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xAF98,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA950,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4CAB,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4140,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x42A4,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x41A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8052,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4220,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4220,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8061,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4080,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8064,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD70A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3D23,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8065,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xF50A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4048,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8066,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x20FB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3B17,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8067,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xED8D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xA0B5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xC6F7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3EE0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8068,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x806A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1F4,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9BA6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3D44,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x447A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8075,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x457A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8076,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x44FA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8077,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x597C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4644,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x41F0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x800D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x43C8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x801A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x42C8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x807D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xD4A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4768,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB77C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E91,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8036,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x803D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFDB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x42C9,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x41F0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8010,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x43C8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x801B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x42C8,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xCCCD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E4C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xCCCD,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E4C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x999A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E99,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x804A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x999A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3E99,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8081,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8017,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB694,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5B46,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xADA3,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4091,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8018,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x810A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x810B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8013,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x801D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x801E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x801C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80B9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80BA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80BB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB439,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x76C8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9FBE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80BC,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4079,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4079,4)"
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
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8084,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8085,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C5,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB439,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x76C8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9FBE,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3FE6,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C7,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4079,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x80C8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4079,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8105,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x432D,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xEB1C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x36E2,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3F2A,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8114,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8024,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xCB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8025,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xBA,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8026,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xE1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8027,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x235,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8020,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8021,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8022,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8023,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8110,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x40A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8111,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4120,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8112,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x40A0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8113,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4120,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8106,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x43C8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8107,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x43C8,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x3175,4)"
epicsThreadSleep(0.01)
# Setup drive to calculate online checksum (0x7abf:0x7faf):
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2069,0x0,0x7faf7abf,4)"
epicsThreadSleep(0.01)

#########################################################
#      Total number of lines parsed: 1265
#      Offline calculated checksum: 0x62ea (25322)
#      Online calculated checksum (in drive) (in dec..):
ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,2)"
ecmcConfigOrDie "Cfg.EcVerifySdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,0x62ea,2)"
#########################################################

#########################################################
#  Parsing of Technosoft setup-file to ECMC format.
#      Input file name: DC48V_TRQ_MODE_40A_AND_TML.sw
#      Block start adress: 0x7fbf
#      Output file name: DC48V_TRQ_MODE_40A_AND_TML.cmd
#      Date: 2024/06/28 10:03:30
#########################################################

ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2064,0x0,0x7FBF0008,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x50,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x30,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x32,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x39,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x30,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x32,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x36,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x45,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x32,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x32,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x31,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x46,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x35,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x31,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x35,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x389,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFE4B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFAA2,4)"
epicsThreadSleep(0.01)
# Setup drive to calculate online checksum (0x7fbf:0x7fe0):
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2069,0x0,0x7fe07fbf,4)"
epicsThreadSleep(0.01)

#########################################################
#      Total number of lines parsed: 34
#      Offline calculated checksum: 0xffff (65535)
#      Online calculated checksum (in drive) (in dec..):
ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,2)"
ecmcConfigOrDie "Cfg.EcVerifySdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,0xffff,2)"
#########################################################

#########################################################
#  Parsing of Technosoft setup-file to ECMC format.
#      Input file name: DC48V_TRQ_MODE_40A_AND_TML.sw
#      Block start adress: 0x7fff
#      Output file name: DC48V_TRQ_MODE_40A_AND_TML.cmd
#      Date: 2024/06/28 10:03:30
#########################################################

ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2064,0x0,0x7FFF0008,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7ABF,4)"
epicsThreadSleep(0.01)
# Setup drive to calculate online checksum (0x7fff:0x7fff):
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2069,0x0,0x7fff7fff,4)"
epicsThreadSleep(0.01)

#########################################################
#      Total number of lines parsed: 1
#      Offline calculated checksum: 0x7abf (31423)
#      Online calculated checksum (in drive) (in dec..):
ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,2)"
ecmcConfigOrDie "Cfg.EcVerifySdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,0x7abf,2)"
#########################################################

#########################################################
#  Parsing of Technosoft setup-file to ECMC format.
#      Input file name: DC48V_TRQ_MODE_40A_AND_TML.sw
#      Block start adress: 0x4000
#      Output file name: DC48V_TRQ_MODE_40A_AND_TML.cmd
#      Date: 2024/06/28 10:03:30
#########################################################

ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2064,0x0,0x40000008,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x649C,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x23C9,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4014,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x23BF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x4013,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2398,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x400B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x74C0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x9C0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x400B,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x404,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5A57,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFFFF,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x20,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x7484,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x2FB,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x400F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x102,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x1,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x401E,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5909,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xFF3F,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x5909,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0xB0C0,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x8000,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x108,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x404,4)"
epicsThreadSleep(0.01)
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,0x0,4)"
epicsThreadSleep(0.01)
# Setup drive to calculate online checksum (0x4000:0x4026):
ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2069,0x0,0x40264000,4)"
epicsThreadSleep(0.01)

#########################################################
#      Total number of lines parsed: 39
#      Offline calculated checksum: 0xcbf (3263)
#      Online calculated checksum (in drive) (in dec..):
ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,2)"
ecmcConfigOrDie "Cfg.EcVerifySdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,0xcbf,2)"
#########################################################

# Reset drive to apply settings:
# NOTE: Reset drive command will return error -5 since no repsonse is sent back to the master! The drive will be reset anyway!
ecmcConfig "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2080,0x0,1,2)"
epicsThreadSleep(0.01)
