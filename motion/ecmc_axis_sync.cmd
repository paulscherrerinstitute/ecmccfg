#Encoder
ecmcConfigOrDie "Cfg.SetAxisEncTransExpr(${ECMC_AXIS_NO})=${ECMC_ENC_EXPRESSION}"
ecmcConfigOrDie "Cfg.SetAxisEncExtVelFilterEnable(${ECMC_AXIS_NO},${ECMC_ENC_VELO_FILT_ENABLE})"
ecmcConfigOrDie "Cfg.SetAxisEncSourceType(${ECMC_AXIS_NO},${ECMC_ENC_SOURCE})"

#Trajectory
ecmcConfigOrDie "Cfg.SetAxisTrajTransExpr(${ECMC_AXIS_NO})=${ECMC_TRAJ_EXPRESSION}"
ecmcConfigOrDie "Cfg.SetAxisTrajSourceType(${ECMC_AXIS_NO},${ECMC_TRAJ_SOURCE})"

#Commands
ecmcConfigOrDie "Cfg.SetAxisEnableCommandsFromOtherAxis(${ECMC_AXIS_NO},${ECMC_CMD_FRM_OTHER_AXIS_ENABLE})"
ecmcConfigOrDie "Cfg.SetAxisEnableCommandsTransform(${ECMC_AXIS_NO},${ECMC_CMD_EXPRESSION_ENABLE})"
ecmcConfigOrDie "Cfg.SetAxisTransformCommandExpr(${ECMC_AXIS_NO})=${ECMC_CMD_EXPRESSION}"
