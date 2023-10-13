#-d /**
#-d   \brief hardware script for EL7211-0010-Motor-Beckhoff-AM8112-0F21-0000
#-d   \details Parametrization of EL7211 for motor Beckhoff AM8112-0F21-0000
#-d   \author Niko Kivel
#-d   \file
#-d   \note For important parameters see TwinCAT CoE startup list for the motor terminal configuration.
#-d */

#- 0x9009 0x0A Effective nominal voltage (mV)
#- --> 33900
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x19,33900,4)"
#-
#- 0x9009 0x07 Effective holding current (mA)
#- --> 4700
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x11,4700,4)"
#-
#- 0x9009 0x08 Effective rated current (mA)
#- --> 4500
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x12,4500,4)"
#-
#- 0x9009 0x06 Number of pole pair
#- --> 3
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x13,3,1)"
#-
#- Commutation offset = -90 (reset by auto-configuration)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x15,-90,2)"
#-
#- 0x9009 0x0E Torque constant (mNm/A)
#- --> 80
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x16,80,4)"
#-
#- 0x9009 0x14 Mass moment of inertia (g cm^2)
#- --> 75
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x18,75,4)"
#-
#- 0x9009 0x11 Inductance in the direction of flow (0.1 mH)
#- --> 7
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x19,7,2)"
#-
#- 0x9009 0x18 Thermal time constant of the motor (s)
#- --> 5400
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x2d,5400,2)"
#-
#- 0x9009 0x13 Maximum speed (rpm)
#- --> 10000 (reset by auto-configuration to 3885)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8011,0x1b,4500,4)"
#-
#- Current loop integral time = 5 (reset by auto-configuration to 5)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x12,5,2)"
#-
#- Current loop proportianal gain = 106 (reset by auto-configuration to 106)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x13,106,2)"
#-
#- Velocity loop integral time = 50 (reset by auto-configuration to 50)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x14,50,4)"
#-
#- Velocity loop proportianal gain = 150 (reset by auto-configuration to 150)
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x15,150,4)"

#- INDEX ==== 0x9008 ====
#- 0x11: Encoder Type = 0x0002 2
#- 0x12: Resolution = 0x00040000 262144
#- 0x13: Range = 0x00001000 4096
#- 0x14: Type Code Name = EKM36-0JF0A0S15
#- 0x15: Serial No = Z2090098H
#- 0x16: Firmware Revision = EKX-0_01.07     HW_E
#- 0x17: Firmware Date = 29.01.16
#- 0x18: EEPROM Size = 0x2000 8192
#- 0x19: Temperature = 0x01c4 452
#- 0x1a: LED Current = 0x0061 97
#- 0x1b: Supply voltage = 0x00002e15 11797
#- 0x1c: Operating hour counter = 0x000000f5 245
#- 0x1d: Received Signal = 0x005b 91
#- 0x1e: Slave Received Signal = 0x0064 100
#- 0x1f: Line delay = 0x0096 150
#- 0x20: Encoder position offset = 0x00000000 0
#- INDEX ==== 0x9009 ====
#- 0x01: Motor vendor = Beckhoff
#- 0x02: Electric motor type = AM8112-xFx1
#- 0x03: Serial number = aa400i07
#- 0x04: Order number = AM8112-0F21-0000
#- 0x05: Type of motor = sync, rot
#- 0x06: Number of pole pairs = 0x00000003 3
#- 0x07: Standstill current (rms) = 0x0000125c 4700
#- 0x08: Rated current (rms) = 0x00001194 4500
#- 0x09: Peak current (rms) = 0x00004074 16500
#- 0x0a: Nominal voltage (rms) = 0x0000846c 33900
#- 0x0b: Max voltage (rms) = 0x00017700 96000
#- 0x0c: Max winding du/dt = 0x007a1200 8000000
#- 0x0d: Max torque = 0x0550 1360
#- 0x0e: Torque constant = 0x0050 80
#- 0x0f: EMK (rms) = 0x00000005 5
#- 0x10: Winding resistance = 0x04e2 1250
#- 0x11: Ld Ph-Ph Inductance = 0x0007 7
#- 0x12: Lq Ph-Ph Inductance = 0x0007 7
#- 0x13: Max speed = 0x00002710 10000
#- 0x14: Moment of inertia = 0x004b 75
#- 0x15: T motor warn limit = 0x04b0 1200
#- 0x16: T motor shut down = 0x0578 1400
#- 0x17: Time constant i2t = 0x01a3 419
#- 0x18: Motor thermal constant = 0x1518 5400
#- 0x1b: Brake type = holding brake
#- 0x1c: Min brake voltage = 0x00005460 21600
#- 0x1d: Max brake voltage = 0x00006338 25400
#- 0x1e: Min brake monitor current = 0x000000b5 181
#- 0x1f: Brake holding torque = 0x00000258 600
#- 0x20: Brake T on = 0x0014 20
#- 0x21: Brake T off = 0x0008 8
#- 0x22: Brake reduced holdingvoltage = 0x00000000 0
#- 0x23: Brake time to red.holding volt = 0x0bb8 3000
#- 0x24: Motor temp sensor connection = ---
#- 