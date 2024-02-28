#-d /**
#-d   \brief hardware script for ecmcEL33XX-Sensor-generic
#-d   \details Parametrization default SDO settings for EL33XX
#-d   \author Anders Sandstroem
#-d   \file
#-d */

############################################################
############# Parametrization default SDO settings for EL33XX
#
#- Environment variables needed:
#- -ECMC_EC_SDO_INDEX "0x80n0" where n is channel 0..3
#- -ECMC_EC_SLAVE_NUM = slave number
#-

#- Enable user scale
#- 0 = Disabled (default)
#- 1 = Enabled
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x1")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Presentation
#-  Index   EL3314-0002, EL3314-0010     All other EL33XX
#-          EL3314-0020, EL3314-0030
#- ------- ---------------------------- -----------------------
#-      0   0.1   degC/digit             Signed (default)
#-      1                                Absolute, MSB as sign
#-      2   0.01  degC/digit (default)   High resolution
#-      3   0.001 degC/digit
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x2")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
ecmcEpicsEnvSetCalcTernary("ECMC_EC_SDO_VALUE", "'${ECMC_EC_HWTYPE}'='EL3314-0002' or '${ECMC_EC_HWTYPE}'='EL3314-0010' or '${ECMC_EC_HWTYPE}'='EL3314-0020' or '${ECMC_EC_HWTYPE}'='EL3314-0030'", "2", "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Enable Siemens S5 bits
#- Note: not available for EL3314-0010, EL3314-0020 and EL3314-0030
#- 0 = Disabled (default)
#- 1 = Enabled
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x5")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcEpicsEnvSetCalcTernary("ECMC_SKIP_ME", "'${ECMC_EC_HWTYPE}'='EL3314-0010' or '${ECMC_EC_HWTYPE}'='EL3314-0020' or '${ECMC_EC_HWTYPE}'='EL3314-0030'", "#", "")
${ECMC_SKIP_ME}ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"
epicsEnvUnset("ECMC_SKIP_ME")

#- Enable filter
#- Note: according to documentation the filter is always enabled independent of setting since needed for measure process. So rely on default value.
#- 0 = Disabled
#- 1 = Enabled (default)
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x6")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Enable limit 1
#- Note: not available for EL3314-0010, EL3314-0020, EL3314-0030 and EL3318
#- 0 = Disabled (default)
#- 1 = Enabled
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x7")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcEpicsEnvSetCalcTernary("ECMC_SKIP_ME", "'${ECMC_EC_HWTYPE}'='EL3314-0010' or '${ECMC_EC_HWTYPE}'='EL3314-0020' or '${ECMC_EC_HWTYPE}'='EL3314-0030' or '${ECMC_EC_HWTYPE}'='EL3318'", "#", "")
${ECMC_SKIP_ME}ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"
epicsEnvUnset("ECMC_SKIP_ME")

#- Enable limit 2
#- Note: not available for EL3314-0010, EL3314-0020, EL3314-0030 and EL3318
#- 0 = Disabled (default)
#- 1 = Enabled
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x8")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcEpicsEnvSetCalcTernary("ECMC_SKIP_ME", "'${ECMC_EC_HWTYPE}'='EL3314-0010' or '${ECMC_EC_HWTYPE}'='EL3314-0020' or '${ECMC_EC_HWTYPE}'='EL3314-0030' or '${ECMC_EC_HWTYPE}'='EL3318'", "#", "")
${ECMC_SKIP_ME}ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"
epicsEnvUnset("ECMC_SKIP_ME")

#- Enable user calibration
#- 0 = Disabled (default)
#- 1 = Enabled
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0xA")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Enable vendor calibration
#- 0 = Disabled
#- 1 = Enabled (default)
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0xB")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "1")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Cold junction compensation
#- 0 = Internal (default)
#- 1 = No compensation
#- 2 = Extern process data
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0xC")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Disable wirebreak detection
#- Note: not available for EL3311 and EL3312
#- 0 = Wire break detection active (default)
#- 1 = Wire break detection not active
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0xE")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "1")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcEpicsEnvSetCalcTernary("ECMC_SKIP_ME", "'${ECMC_EC_HWTYPE}'='EL3311' or '${ECMC_EC_HWTYPE}'='EL3312'", "#", "")
${ECMC_SKIP_ME}ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"
epicsEnvUnset("ECMC_SKIP_ME")

#- User scale offset
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x11")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- User scale gain
#- Note: represented in fixed point format with factor 2^16 (gain = 1 corresponds to 65535)
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x12")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "4")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "65535")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Limit 1
#- Note: not available for EL3314-0010, EL3314-0020, EL3314-0030 and EL3318
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x13")
ecmcEpicsEnvSetCalcTernary("ECMC_EC_SDO_SIZE", "'${ECMC_EC_HWTYPE}'='EL3314-0002'", "4", "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcEpicsEnvSetCalcTernary("ECMC_SKIP_ME", "'${ECMC_EC_HWTYPE}'='EL3314-0010' or '${ECMC_EC_HWTYPE}'='EL3314-0020' or '${ECMC_EC_HWTYPE}'='EL3314-0030' or '${ECMC_EC_HWTYPE}'='EL3318'", "#", "")
${ECMC_SKIP_ME}ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"
epicsEnvUnset("ECMC_SKIP_ME")

#- Limit 2
#- Note: not available for EL3314-0010, EL3314-0020, EL3314-0030 and EL3318
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x14")
ecmcEpicsEnvSetCalcTernary("ECMC_EC_SDO_SIZE", "'${ECMC_EC_HWTYPE}'='EL3314-0002'", "4", "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcEpicsEnvSetCalcTernary("ECMC_SKIP_ME", "'${ECMC_EC_HWTYPE}'='EL3314-0010' or '${ECMC_EC_HWTYPE}'='EL3314-0020' or '${ECMC_EC_HWTYPE}'='EL3314-0030' or '${ECMC_EC_HWTYPE}'='EL3318'", "#", "")
${ECMC_SKIP_ME}ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"
epicsEnvUnset("ECMC_SKIP_ME")

#- Filter settings
#- Note: per channel configuration is not possible. All channels use channel 1 setting.
#- Note: there are undocumented options for EL3314-0002.
#-  Index   All EL33XX except EL3314-0002   EL3314-0002
#- ------- ------------------------------- ------------------
#-      0   50 Hz (default)                 2.5 Hz (default)
#-      1   60 Hz                           5 Hz
#-      2   100 Hz                          10 Hz
#-      3   500 Hz                          16.6 Hz
#-      4   1 kHz                           20 Hz
#-      5   2 kHz                           50 Hz
#-      6   3.75 kHz                        60 Hz
#-      7   7.5 kHz                         100 Hz
#-      8   15 kHz                          200 Hz
#-      9   30 kHz                          400 hz
#-     10   5 Hz                            800 Hz
#-     11   10 Hz                           1000 Hz
#-     12                                   2000 Hz
#-     13                                   4000 Hz
#-     20                                   50/60 Hz
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x15")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- User calibration offset
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x17")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- User calibration gain
#- Note: represented in fixed point format with factor 2^16 (gain = 1 corresponds to 65535)
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x18")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "65535")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Thermocouple element
#-  Index   All EL33XX except          EL3314-0002                EL3314-0010, EL3314-0020
#-          EL3314-0010, EL3314-0020                              EL3314-0030
#-          EL3314-0030, EL3314-0002
#- ------- -------------------------- -------------------------- ----------------------------
#-      0   K (default)                K (default)                K (default)
#-      1   J                          J                          J
#-      2   L                          L                          L
#-      3   E                          E                          E
#-      4   T                          T                          T
#-      5   N                          N                          N
#-      6   U                          U                          U
#-      7   B                          B                          B
#-      8   R                          R                          R
#-      9   S                          S                          S
#-     10   C                          C                          C
#-    100   ±30 mV (1 µV resolution)   ±78 mV (1 µV resolution)
#-    101   ±60 mV (2 µV resolution)
#-    102   ±90 mV (4 µV resolution)
#-    103                              ±2.5 V (1 µV resolution)
#-    104                                                         ±78 mV (10 nV resolution)
#-
#- Thermocouple ranges:
#- type K from -200 to 1370 degC
#- type J from -100 to 1200 degC
#- type L from  0   to 900  degC
#- type E from -100 to 1000 degC
#- type T from -200 to 400  degC
#- type N from -100 to 1300 degC
#- type U from  0   to 600  degC
#- type B from  600 to 1800 degC
#- type R from  0   to 1767 degC
#- type S from  0   to 1760 degC
#- type C from  0   to 2320 degC
#-
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x19")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"

#- Microcontroller filter
#- Note: only available for EL3314-0002, EL3314-0010, EL3314-0020 and EL3314-0030
#- 0 = Inactive (default)
#- 1 = IIR 1
#- 2 = IIR 2
#- 3 = IIR 3
#- 4 = IIR 4
#- 5 = FIR 4 (only EL3314-00X0)
#- 6 = FIR 8 (only EL3314-00X0)
#- 7 = FIR 16 (only EL3314-00X0)
#- 8 = FIR 32 (only EL3314-00X0)
epicsEnvSet("ECMC_EC_SDO_INDEX_OFFSET",  "0x1A")
epicsEnvSet("ECMC_EC_SDO_SIZE",          "2")
epicsEnvSet("ECMC_EC_SDO_VALUE",         "0")
ecmcEpicsEnvSetCalcTernary("ECMC_SKIP_ME", "'${ECMC_EC_HWTYPE}'='EL3314-0002' or '${ECMC_EC_HWTYPE}'='EL3314-0010' or '${ECMC_EC_HWTYPE}'='EL3314-0020' or '${ECMC_EC_HWTYPE}'='EL3314-0030'", "", "#")
${ECMC_SKIP_ME}ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},${ECMC_EC_SDO_INDEX},$(ECMC_EC_SDO_INDEX_OFFSET),$(ECMC_EC_SDO_VALUE),$(ECMC_EC_SDO_SIZE))"
epicsEnvUnset("ECMC_SKIP_ME")

#- Cleanup
epicsEnvUnset("ECMC_EC_SDO_INDEX_OFFSET")
epicsEnvUnset("ECMC_EC_SDO_SIZE")
epicsEnvUnset("ECMC_EC_SDO_VALUE")
