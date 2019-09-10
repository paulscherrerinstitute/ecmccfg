#-d /**
#-d   \brief hardware script for EL3632_s50
#-d   \details 2-channel analog input terminal for Condition Monitoring (IEPE) with oversampling
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- ###########################################################
#- ############ Information:
#-  Description: 2-channel analog input terminal for Condition Monitoring (IEPE) with oversampling
#-  Oversampling factor = 50
#-
#- ###########################################################

epicsEnvSet("ECMC_EC_HWTYPE"             "EL3632_s50")
epicsEnvSet("ECMC_EC_VENDOR_ID"          "0x2")
epicsEnvSet("ECMC_EC_PRODUCT_ID"         "0xe303052")

ecmcConfigOrDie "Cfg.EcSlaveVerify(0,${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID})"

#- ############################################

#-  CH 1
#-  Configuration for sync manager 3
#-  Configuration for pdoIndex 6656
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a00,0x6000,0x1,16,CH1_STATUS)"

#-  Configuration for pdoIndex 6657
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a01,0x6001,0x1,16,sm3.p1.e0,0)"
#-  Configuration for pdoIndex 6658
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a02,0x6001,0x2,16,sm3.p2.e0,0)"
#-  Configuration for pdoIndex 6659
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a03,0x6001,0x3,16,sm3.p3.e0,0)"
#-  Configuration for pdoIndex 6660
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a04,0x6001,0x4,16,sm3.p4.e0,0)"
#-  Configuration for pdoIndex 6661
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a05,0x6001,0x5,16,sm3.p5.e0,0)"
#-  Configuration for pdoIndex 6662
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a06,0x6001,0x6,16,sm3.p6.e0,0)"
#-  Configuration for pdoIndex 6663
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a07,0x6001,0x7,16,sm3.p7.e0,0)"
#-  Configuration for pdoIndex 6664
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a08,0x6001,0x8,16,sm3.p8.e0,0)"
#-  Configuration for pdoIndex 6665
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a09,0x6001,0x9,16,sm3.p9.e0,0)"
#-  Configuration for pdoIndex 6666
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0a,0x6001,0xa,16,sm3.p10.e0,0)"
#-  Configuration for pdoIndex 6667
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0b,0x6001,0xb,16,sm3.p11.e0,0)"
#-  Configuration for pdoIndex 6668
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0c,0x6001,0xc,16,sm3.p12.e0,0)"
#-  Configuration for pdoIndex 6669
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0d,0x6001,0xd,16,sm3.p13.e0,0)"
#-  Configuration for pdoIndex 6670
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0e,0x6001,0xe,16,sm3.p14.e0,0)"
#-  Configuration for pdoIndex 6671
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a0f,0x6001,0xf,16,sm3.p15.e0,0)"
#-  Configuration for pdoIndex 6672
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a10,0x6001,0x10,16,sm3.p16.e0,0)"
#-  Configuration for pdoIndex 6673
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a11,0x6001,0x11,16,sm3.p17.e0,0)"
#-  Configuration for pdoIndex 6674
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a12,0x6001,0x12,16,sm3.p18.e0,0)"
#-  Configuration for pdoIndex 6675
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a13,0x6001,0x13,16,sm3.p19.e0,0)"
#-  Configuration for pdoIndex 6676
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a14,0x6001,0x14,16,sm3.p20.e0,0)"
#-  Configuration for pdoIndex 6677
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a15,0x6001,0x15,16,sm3.p21.e0,0)"
#-  Configuration for pdoIndex 6678
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a16,0x6001,0x16,16,sm3.p22.e0,0)"
#-  Configuration for pdoIndex 6679
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a17,0x6001,0x17,16,sm3.p23.e0,0)"
#-  Configuration for pdoIndex 6680
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a18,0x6001,0x18,16,sm3.p24.e0,0)"
#-  Configuration for pdoIndex 6681
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a19,0x6001,0x19,16,sm3.p25.e0,0)"
#-  Configuration for pdoIndex 6682
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a1a,0x6001,0x1a,16,sm3.p26.e0,0)"
#-  Configuration for pdoIndex 6683
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a1b,0x6001,0x1b,16,sm3.p27.e0,0)"
#-  Configuration for pdoIndex 6684
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a1c,0x6001,0x1c,16,sm3.p28.e0,0)"
#-  Configuration for pdoIndex 6685
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a1d,0x6001,0x1d,16,sm3.p29.e0,0)"
#-  Configuration for pdoIndex 6686
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a1e,0x6001,0x1e,16,sm3.p30.e0,0)"
#-  Configuration for pdoIndex 6687
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a1f,0x6001,0x1f,16,sm3.p31.e0,0)"
#-  Configuration for pdoIndex 6688
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a20,0x6001,0x20,16,sm3.p32.e0,0)"
#-  Configuration for pdoIndex 6689
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a21,0x6001,0x21,16,sm3.p33.e0,0)"
#-  Configuration for pdoIndex 6690
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a22,0x6001,0x22,16,sm3.p34.e0,0)"
#-  Configuration for pdoIndex 6691
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a23,0x6001,0x23,16,sm3.p35.e0,0)"
#-  Configuration for pdoIndex 6692
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a24,0x6001,0x24,16,sm3.p36.e0,0)"
#-  Configuration for pdoIndex 6693
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a25,0x6001,0x25,16,sm3.p37.e0,0)"
#-  Configuration for pdoIndex 6694
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a26,0x6001,0x26,16,sm3.p38.e0,0)"
#-  Configuration for pdoIndex 6695
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a27,0x6001,0x27,16,sm3.p39.e0,0)"
#-  Configuration for pdoIndex 6696
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a28,0x6001,0x28,16,sm3.p40.e0,0)"
#-  Configuration for pdoIndex 6697
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a29,0x6001,0x29,16,sm3.p41.e0,0)"
#-  Configuration for pdoIndex 6698
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a2a,0x6001,0x2a,16,sm3.p42.e0,0)"
#-  Configuration for pdoIndex 6699
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a2b,0x6001,0x2b,16,sm3.p43.e0,0)"
#-  Configuration for pdoIndex 6700
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a2c,0x6001,0x2c,16,sm3.p44.e0,0)"
#-  Configuration for pdoIndex 6701
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a2d,0x6001,0x2d,16,sm3.p45.e0,0)"
#-  Configuration for pdoIndex 6702
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a2e,0x6001,0x2e,16,sm3.p46.e0,0)"
#-  Configuration for pdoIndex 6703
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a2f,0x6001,0x2f,16,sm3.p47.e0,0)"
#-  Configuration for pdoIndex 6704
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a30,0x6001,0x30,16,sm3.p48.e0,0)"
#-  Configuration for pdoIndex 6705
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a31,0x6001,0x31,16,sm3.p49.e0,0)"
#-  Configuration for pdoIndex 6706
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a32,0x6001,0x32,16,sm3.p50.e0,0)"

#-  CH 2
#-  Configuration for pdoIndex 6720
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a40,0x6010,0x1,16,CH2_STATUS)"
#-  Configuration for pdoIndex 6721
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a41,0x6011,0x1,16,sm3.p52.e0,0)"
#-  Configuration for pdoIndex 6722
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a42,0x6011,0x2,16,sm3.p53.e0,0)"
#-  Configuration for pdoIndex 6723
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a43,0x6011,0x3,16,sm3.p54.e0,0)"
#-  Configuration for pdoIndex 6724
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a44,0x6011,0x4,16,sm3.p55.e0,0)"
#-  Configuration for pdoIndex 6725
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a45,0x6011,0x5,16,sm3.p56.e0,0)"
#-  Configuration for pdoIndex 6726
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a46,0x6011,0x6,16,sm3.p57.e0,0)"
#-  Configuration for pdoIndex 6727)"
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a47,0x6011,0x7,16,sm3.p58.e0,0)"
#-  Configuration for pdoIndex 6728
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a48,0x6011,0x8,16,sm3.p59.e0,0)"
#-  Configuration for pdoIndex 6729
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a49,0x6011,0x9,16,sm3.p60.e0,0)"
#-  Configuration for pdoIndex 6730
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a4a,0x6011,0xa,16,sm3.p61.e0,0)"
#-  Configuration for pdoIndex 6731
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a4b,0x6011,0xb,16,sm3.p62.e0,0)"
#-  Configuration for pdoIndex 6732
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a4c,0x6011,0xc,16,sm3.p63.e0,0)"
#-  Configuration for pdoIndex 6733
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a4d,0x6011,0xd,16,sm3.p64.e0,0)"
#-  Configuration for pdoIndex 6734
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a4e,0x6011,0xe,16,sm3.p65.e0,0)"
#-  Configuration for pdoIndex 6735
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a4f,0x6011,0xf,16,sm3.p66.e0,0)"
#-  Configuration for pdoIndex 6736
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a50,0x6011,0x10,16,sm3.p67.e0,0)"
#-  Configuration for pdoIndex 6737
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a51,0x6011,0x11,16,sm3.p68.e0,0)"
#-  Configuration for pdoIndex 6738
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a52,0x6011,0x12,16,sm3.p69.e0,0)"
#-  Configuration for pdoIndex 6739
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a53,0x6011,0x13,16,sm3.p70.e0,0)"
#-  Configuration for pdoIndex 6740
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a54,0x6011,0x14,16,sm3.p71.e0,0)"
#-  Configuration for pdoIndex 6741
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a55,0x6011,0x15,16,sm3.p72.e0,0)"
#-  Configuration for pdoIndex 6742
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a56,0x6011,0x16,16,sm3.p73.e0,0)"
#-  Configuration for pdoIndex 6743
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a57,0x6011,0x17,16,sm3.p74.e0,0)"
#-  Configuration for pdoIndex 6744
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a58,0x6011,0x18,16,sm3.p75.e0,0)"
#-  Configuration for pdoIndex 6745
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a59,0x6011,0x19,16,sm3.p76.e0,0)"
#-  Configuration for pdoIndex 6746
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a5a,0x6011,0x1a,16,sm3.p77.e0,0)"
#-  Configuration for pdoIndex 6747
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a5b,0x6011,0x1b,16,sm3.p78.e0,0)"
#-  Configuration for pdoIndex 6748
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a5c,0x6011,0x1c,16,sm3.p79.e0,0)"
#-  Configuration for pdoIndex 6749
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a5d,0x6011,0x1d,16,sm3.p80.e0,0)"
#-  Configuration for pdoIndex 6750
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a5e,0x6011,0x1e,16,sm3.p81.e0,0)"
#-  Configuration for pdoIndex 6751
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a5f,0x6011,0x1f,16,sm3.p82.e0,0)"
#-  Configuration for pdoIndex 6752
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a60,0x6011,0x20,16,sm3.p83.e0,0)"
#-  Configuration for pdoIndex 6753
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a61,0x6011,0x21,16,sm3.p84.e0,0)"
#-  Configuration for pdoIndex 6754
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a62,0x6011,0x22,16,sm3.p85.e0,0)"
#-  Configuration for pdoIndex 6755
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a63,0x6011,0x23,16,sm3.p86.e0,0)"
#-  Configuration for pdoIndex 6756
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a64,0x6011,0x24,16,sm3.p87.e0,0)"
#-  Configuration for pdoIndex 6757
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a65,0x6011,0x25,16,sm3.p88.e0,0)"
#-  Configuration for pdoIndex 6758
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a66,0x6011,0x26,16,sm3.p89.e0,0)"
#-  Configuration for pdoIndex 6759
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a67,0x6011,0x27,16,sm3.p90.e0,0)"
#-  Configuration for pdoIndex 6760
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a68,0x6011,0x28,16,sm3.p91.e0,0)"
#-  Configuration for pdoIndex 6761
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a69,0x6011,0x29,16,sm3.p92.e0,0)"
#-  Configuration for pdoIndex 6762
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a6a,0x6011,0x2a,16,sm3.p93.e0,0)"
#-  Configuration for pdoIndex 6763
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a6b,0x6011,0x2b,16,sm3.p94.e0,0)"
#-  Configuration for pdoIndex 6764
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a6c,0x6011,0x2c,16,sm3.p95.e0,0)"
#-  Configuration for pdoIndex 6765
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a6d,0x6011,0x2d,16,sm3.p96.e0,0)"
#-  Configuration for pdoIndex 6766
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a6e,0x6011,0x2e,16,sm3.p97.e0,0)"
#-  Configuration for pdoIndex 6767
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a6f,0x6011,0x2f,16,sm3.p98.e0,0)"
#-  Configuration for pdoIndex 6768
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a70,0x6011,0x30,16,sm3.p99.e0,0)"
#-  Configuration for pdoIndex 6769
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a71,0x6011,0x31,16,sm3.p100.e0,0)"
#-  Configuration for pdoIndex 6770
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a72,0x6011,0x32,16,sm3.p101.e0,0)"
#-  Configuration for pdoIndex 6784
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a80,0x6020,0x1,64,sm3.p102.e0,0)"
#-  Configuration for pdoIndex 6785
ecmcConfigOrDie "Cfg.EcAddEntryComplete(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},2,3,0x1a81,0x6021,0x1,16,sm3.p103.e0,0)"

#-  Configure DC clock 20000ns update for oversampling (50 values oversampling in 1kHz)
#- ecmcConfigOrDie "Cfg.EcSlaveConfigDC(${ECMC_EC_SLAVE_NUM},0x730,20000,-20000,1000000,0)"
