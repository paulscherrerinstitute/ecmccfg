#-d /**
#-d   \brief hardware script for Festo CMMT-ST Drive
#-d   \details Festo CMMT-ST drive (48V,8A)
#-d   \author Anders Sandstroem
#-d   \file
#-d   \note SDOS
#-d   \param [out] SDO 0x1011:01 --> 1684107116 \b reset
#-d */

#- Configure PDOS
ecmcFileExist(${ecmccfg_DIR}ecmcFesto-CMMT-ST_PDO.cmd,1)
${SCRIPTEXEC} ${ecmccfg_DIR}ecmcFesto-CMMT-ST_PDO.cmd

# Default to PV
#- -128 – Invalid
#- -20 RT Record table
#- -3 PJ Profile jog
#- 0 PP Profile position manufacturer-specific
#- 1 PP Profile position
#- 3 PV Profile velocity
#- 4 PT Profile torque
#- 6 HM Homing
#- 8 CSP Cyclic sync position
#- 9 CSV Cyclic sync velocity
#- 10 CST Cyclic sync torque
ecmcConfigOrDie "Cfg.EcAddSdo(${ECMC_EC_SLAVE_NUM},0x6060,0x0,3,1)"
ecmcConfigOrDie "Cfg.WriteEcEntryIDString(${ECMC_EC_SLAVE_NUM},modeControl01,3)"
