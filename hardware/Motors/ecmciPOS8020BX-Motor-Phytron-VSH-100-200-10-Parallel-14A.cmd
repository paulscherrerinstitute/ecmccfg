#-d /**
#-d   \brief hardware script for iPOS8020-Motor--Phytron-VSH-100-200-10-Parallel-14A
#-d   \details Parametrization of technosoft IPOS8020 for motor Phytron VSH.100.200.10 Parallel (14A)
#-d   \author Anders Sandstroem
#-d   \file
#-d */

#- ###########################################################
#- ############ Parametrization of technosoft IPOS8020 for Phytron VSH.100.200.10 Parallel (14A)
#-
#-   Connection Parallel connection
#-   Run current: 14A
#-   Max current protection: (1.25*Run current)
#-   standby current: 1.0A
#-   NoMicroStepsPerStep=256
#-   NoMotorSteps=200
#-
#-
#- ###########################################################
#-d   I_RUN_SET:     Running current in amps (defualts to 10). Allowed range 0..14
#-d   I_STDBY_SET:   Stanbby current in amps (defualts to 1)
#-d   I_MAX_PROT:    Max current protection limit (defaults to 1.25*ECMC_I_RUN_SET)

ecmcFileExist("${ecmccfg_DIR}ecmciPOS8020BX-Motor-Phytron-VSH-100-200-10-Parallel-XA.cmd")
${SCRIPTEXEC} ${ecmccfg_DIR}ecmciPOS8020BX-Motor-Phytron-VSH-100-200-10-Parallel-XA.cmd "I_RUN_SET=14"
