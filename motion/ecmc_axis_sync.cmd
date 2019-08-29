#Commands
ecmcConfigOrDie "Cfg.SetAxisAllowCommandsFromPLC(${ECMC_AXIS_NO},${ECMC_CMD_FRM_OTHER_PLC_ENABLE})"
ecmcConfigOrDie "Cfg.SetAxisPLCEnable(${ECMC_AXIS_NO},${ECMC_CMD_AXIS_PLC_ENABLE})"
ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=${ECMC_AXIS_EXPR_LINE_1}"
ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=${ECMC_AXIS_EXPR_LINE_2}"
ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=${ECMC_AXIS_EXPR_LINE_3}"
ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=${ECMC_AXIS_EXPR_LINE_4}"
ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=${ECMC_AXIS_EXPR_LINE_5}"
ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=${ECMC_AXIS_EXPR_LINE_6}"
ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=${ECMC_AXIS_EXPR_LINE_7}"
ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=${ECMC_AXIS_EXPR_LINE_8}"
ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=${ECMC_AXIS_EXPR_LINE_9}"
ecmcConfigOrDie "Cfg.AppendAxisPLCExpr(${ECMC_AXIS_NO})=${ECMC_AXIS_EXPR_LINE_10}"

#Encoder
ecmcConfigOrDie "Cfg.SetAxisPLCEncVelFilterSize(${ECMC_AXIS_NO},${ECMC_ENC_VELO_FILT_SIZE})"
ecmcConfigOrDie "Cfg.SetAxisPLCEncVelFilterEnable(${ECMC_AXIS_NO},${ECMC_ENC_VELO_FILT_ENABLE})"
ecmcConfigOrDie "Cfg.SetAxisEncSourceType(${ECMC_AXIS_NO},${ECMC_ENC_SOURCE})"

#Trajectory
ecmcConfigOrDie "Cfg.SetAxisPLCTrajVelFilterSize(${ECMC_AXIS_NO},${ECMC_TRAJ_VELO_FILT_SIZE})"
ecmcConfigOrDie "Cfg.SetAxisPLCTrajVelFilterEnable(${ECMC_AXIS_NO},${ECMC_TRAJ_VELO_FILT_ENABLE})"
ecmcConfigOrDie "Cfg.SetAxisTrajSourceType(${ECMC_AXIS_NO},${ECMC_TRAJ_SOURCE})"
