# Run from examples/PSI/lab_setup/softlimits. Select ONE startup per IOC.
require ecmccfg "ENG_MODE=1,MASTER_ID=0"

# Adapt slave address and motor electrical settings to the installed hardware.
${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd, "SLAVE_ID=${DRV_SID=14},HW_DESC=EL7041-0052"
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd "COMP=Motor-Generic-2Phase-Stepper, MACROS='I_MAX_MA=1000,I_STDBY_MA=200,U_NOM_MV=48000,R_COIL_MOHM=1230,SPEED_RANGE=2'"
epicsEnvSet(DRV_SID,${ECMC_EC_SLAVE_NUM})
${SCRIPTEXEC} ${ecmccfg_DIR}loadYamlAxis.cmd, "FILE=./cfg/motor_only.yaml,DEV=${IOC},AX_NAME=M1,AXIS_ID=4,DRV_SID=${DRV_SID},ENC_SID=${DRV_SID},ENC_CH=01"

# YAML initializes motor limits at +/-100 degrees. Disable only native limits;
# syncSoftLimits=false keeps the motor limits independent.
ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitBwd(4,0)"
ecmcConfigOrDie "Cfg.SetAxisEnableSoftLimitFwd(4,0)"

