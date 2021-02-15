#-d /**
#-d   \brief hardware script for EP7211-0034-Motor-Beckhoff-AM8122-0FH1-0000
#-d   \details Parmetrization of EP7211-0034 for motor Beckhoff AM8122-0FH1-0000
#-d   \author Niko Kivel
#-d   \file
#-d   \note For important parameters see TwinCAT CoE startup list for the motor terminal configuration.
#-d */

#- 0x9009 0x0A Effective nominal voltage (mV)
#ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8010,0x19,33900,4)"

#- Index 9009 FB OCT Nameplate
#- 0x9009 0x01 Motor vendor
#- --> Beckhoff
#- 0x9009 0x02 Motor type
#- --> AM8113-xFx1
#- 0x9009 0x03 Serial number
#- --> 00414700
#- 0x9009 0x04 Order number
#- --> AM8122-0FH1-0000
#- 0x9009 0x05 Type of motor
#- --> sync, rot
#- 0x9009 0x06 Number of pole pair
#- --> 3
#- 0x9009 0x07 Effective holding current (mA)
#- --> 4800
#- 0x9009 0x08 Effective rated current (mA)
#- --> 4650
#- 0x9009 0x09 Effective peak current (mA)
#- --> 22400
#- 0x9009 0x0A Effective nominal voltage (mV)
#- --> 33900
#- 0x9009 0x0B Maximum voltage (mV)
#- --> 96000
#- 0x9009 0x0C Maximum permissible voltage rise on the winding (kV/s)
#- --> 8000000
#- 0x9009 0x0D Maximum torque (nNm)
#- --> 4060
#- 0x9009 0x0E Torque constant (mNm/A)
#- --> 200
#- 0x9009 0x0F Reverse voltage (mV/rpm)
#- --> 13
#- 0x9009 0x10 Coil resistance (mOhm)
#- --> 1500
#- 0x9009 0x11 Inductance in the direction of flow (0.1 mH)
#- --> 33
#- 0x9009 0x12 Inductance in the torque-forming direction (0.1 mH)
#- --> 33
#- 0x9009 0x13 Maximum speed (rpm)
#- --> 10000
#- 0x9009 0x14 Mass moment of inertia (g cm^2)
#- --> 330
#- 0x9009 0x15 Motor temperature warning threshold (0.1 °C)
#- --> 1200
#- 0x9009 0x16 Motor temperature error threshold (0.1 °C)
#- --> 1400
#- 0x9009 0x17 Time constant I2T model (s)
#- --> 1010
#- 0x9009 0x18 Thermal time constant of the motor (s)
#- --> 7800
#- 0x9009 0x1B Brake type
#- --> holding brake
#- 0x9009 0x1C Minimum brake voltage (mV)
#- --> 21600
#- 0x9009 0x1D Maximum brake voltage (mV)
#- --> 25400
#- 0x9009 0x1E Minimum current for the monitoring of the brake (mA)
#- --> 199
#- 0x9009 0x1F Brake holding torque (mNm)
#- --> 2000
#- 0x9009 0x20 Time until the brake is applied (ms)
#- --> 25
#- 0x9009 0x21 Time until the brake is released (ms)
#- --> 8
#- 0x9009 0x22 Reduced brake voltage (mV)
#- --> 0
#- 0x9009 0x23 Time from which the brake holds with reduced voltage (ms)
#- --> 3000
#- 0x9009 0x24 Temperature sensor connection
#- --> ---
