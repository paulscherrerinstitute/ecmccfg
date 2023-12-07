#-PSI ILK anybus slave custom data items
#- Note: Need to be called after the memeory area is set up with entries


epicsEnvSet("ECMC_EC_KEY"   "byteInput")
epicsEnvSet("ECMC_EC_SM"    "3")
#- Note indexing starts at 1!!! Annoying..

s11.sm3.p0.e8.b4
epicsEnvSet("ECMC_EC_BYTE"  "08")
${SCRIPTEXEC} ${ecmccfg_DIR}addEcDataItem.cmd "STRT_ENTRY_NAME=${ECMC_EC_KEY}${BYTE},OFFSET_BYTE=0,OFFSET_BITS={BITS},RW=2,DT=U8,NAME=${}"



# file bitin.template
# { pattern
# {MIDDLE     ,NAME          ,INP                     ,ZNAM           ,ONAM           ,ZSV        ,OSV        ,DESC                       ,CONN}
# {-RILK      ,PSA_IN1       ,"@d0 s11.sm3.p0.e8.b4"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit Hw input 1_1"    ,"X41"}
# {-RILK      ,PSA_IN2       ,"@d0 s11.sm3.p0.e8.b5"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit Hw input 1_2"    ,"X41-internal"}
# 
# {-RILK      ,PSA_SUM1      ,"@d0 s11.sm3.p0.e8.b6"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 1_1 status"      ,"PCB-internal"}
# {-RILK      ,PSA_SUM2      ,"@d0 s11.sm3.p0.e8.b7"  ,0              ,1              ,MAJOR      ,NO_ALARM   ,"ILK unit 1_2 status",     ,"PCB-internal"}
# 
# {-RILK      ,F_IN_5V_1     ,"@d0 s11.sm3.p0.e9.b0"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 5V input 1"      ,"X11_A"}
# {-RILK      ,F_IN_5V_2     ,"@d0 s11.sm3.p0.e9.b1"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 5V input 2"      ,"X11_B"}
# {-RILK      ,F_IN_5V_3     ,"@d0 s11.sm3.p0.e9.b2"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 5V input 3"      ,"X12_A"}
# {-RILK      ,F_IN_5V_4     ,"@d0 s11.sm3.p0.e9.b3"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 5V input 4"      ,"X12_B"}
# 
# {-RILK      ,F_IN_24V_1    ,"@d0 s11.sm3.p0.e9.b4"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 24V input 1"     ,"X54"}
# {-RILK      ,F_IN_24V_2    ,"@d0 s11.sm3.p0.e9.b5"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 24V input 2"     ,"X55"}
# {-RILK      ,F_IN_24V_3    ,"@d0 s11.sm3.p0.e9.b6"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 24V input 3"     ,"X56"}
# {-RILK      ,BYPASS-ENABLE ,"@d0 s11.sm3.p0.e9.b6"  ,idle           ,"byp. enabled" ,NO_ALARM   ,MINOR      ,"bridge 1-2 to ena byp."   ,"X56"}
# {-RILK      ,F_IN_24V_4    ,"@d0 s11.sm3.p0.e9.b7"  ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 24V input 4"     ,"X57"}
# 
# {-RILK      ,F_OUT_5V_1    ,"@d0 s11.sm3.p0.e10.b0" ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 5V output 1"     ,"X14_A"}
# {-RILK      ,F_OUT_5V_2    ,"@d0 s11.sm3.p0.e10.b1" ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 5V output 2"     ,"X14_B"}
# {-RILK      ,F_OUT_5V_3    ,"@d0 s11.sm3.p0.e10.b2" ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 5V output 3"     ,"X13_A"}
# {-RILK      ,F_OUT_5V_4    ,"@d0 s11.sm3.p0.e10.b3" ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 5V output 4"     ,"X13_B"}
# 
# {-RILK      ,F_OUT_24V_1   ,"@d0 s11.sm3.p0.e10.b4" ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 24V output 1"    ,"X50"}
# {-RILK      ,F_OUT_24V_2   ,"@d0 s11.sm3.p0.e10.b5" ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 24V output 2"    ,"X51"}
# {-RILK      ,F_OUT_24V_3   ,"@d0 s11.sm3.p0.e10.b6" ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 24V output 3"    ,"X52"}
# {-RILK      ,F_OUT_24V_4   ,"@d0 s11.sm3.p0.e10.b7" ,0              ,1              ,NO_ALARM   ,NO_ALARM   ,"ILK unit 24V output 4"    ,"X53"}
# 
# # Arc detector latched via EL1034-3 inputs
# {-RCAV      ,Coupler-Arc1   ,"@d0 s4.sm0.p0.e0"     ,"idle"         ,"arc detect"   ,NO_ALARM   ,MINOR      ,"arc detector ch1, latched","EL1034-3 input 1"}
# {-RCAV      ,Coupler-Arc2   ,"@d0 s4.sm0.p1.e0"     ,"idle"         ,"arc detect"   ,NO_ALARM   ,MINOR      ,"arc detector ch2, latched","EL1034-3 input 2"}
# {-RCIR      ,Arc1           ,"@d0 s4.sm0.p2.e0"     ,"idle"         ,"arc detect"   ,NO_ALARM   ,MINOR      ,"arc detector ch3, latched","EL1034-3 input 3"}
# {-RCIR      ,Arc2           ,"@d0 s4.sm0.p3.e0"     ,"idle"         ,"arc detect"   ,NO_ALARM   ,MINOR      ,"arc detector ch4, latched","EL1034-3 input 4"}
# }
