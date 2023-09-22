#===============================================================================
# ecmcEL7411-Encoder-Maxon-228456.cmd
#-d /**
#-d   \brief hardware script for EL7411-Motor-Maxon-228456
#-d 
#-d   \details Parametrization of EL7411 for motor Maxon-228456 incremental encoder (not hall sensors)
#-d 
#-d   \note This config only configures the encoder part of the EL7411.
#-d
#-d   Encoder:
#-d     partnumber: 228456
#-d     name: MR-type L 1000pts (4-fold->4000/rev)
#-d     type: 3 channels with line driver, TTL compatible
#-d     resolution: 4000 / rev
#-d     Supply voltage 5V
#-d     Pinout (connector DIN 41651):
#-d         Looking into the female connector with the red wire to the left. Pin 1 is the upper left, pin two lower left:
#-d         1 3 5 7 9
#-d         2 4 6 8 10
#-d         
#-d         1    : NC
#-d         2    : Vcc
#-d         3    : Gnd
#-d         4    : NC
#-d         5    : A neg
#-d         6    : A
#-d         7    : B neg
#-d         8    : B
#-d         9    : Z neg
#-d         10   : Z
#-d
#-d   \author Anders Sandstroem
#-d   \file
#-d */ 

#- ###################### ENCODER ######################################

#- Invert feedback direction No
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x1,0,1)"
#- Enable encoder power supply yes
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x2,1,1)"
#- Enable encoder c track
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x5,1,1)"
#- Encoder voltage 5000mv
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x11,5000,4)"
#- Encoder type: Test TTL => 2
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x12,2,2)"
#- Encoder resolution per rev: 1000 * 4 = 4000
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x8008,0x13,4000,4)"
