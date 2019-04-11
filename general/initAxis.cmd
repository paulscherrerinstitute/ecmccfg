#General
epicsEnvSet("ECMC_MOTOR_NAME",            "NOT SET")
epicsEnvSet("ECMC_R",                     "NOT SET")
epicsEnvSet("ECMC_AXIS_NO",               "NOT SET")
epicsEnvSet("ECMC_DESC",                  "NOT SET")
epicsEnvSet("ECMC_EGU",                   "NOT SET")                        # Motor Record Unit
epicsEnvSet("ECMC_PREC",                  "NOT SET")                        # Motor Record Precision
epicsEnvSet("ECMC_AXISCONFIG",            "NOT SET")                        # Extra parameters to driver
epicsEnvSet("ECMC_EC_AXIS_HEALTH",        "NOT SET")                        # Entry for axis health output (example: ec0.s1.OUPIN_1.0)

#Encoder
epicsEnvSet("ECMC_ENC_SCALE_NUM"          "NOT SET")
epicsEnvSet("ECMC_ENC_SCALE_DENOM"        "NOT SET")
epicsEnvSet("ECMC_ENC_BITS"               "NOT SET")
epicsEnvSet("ECMC_ENC_TYPE"               "NOT SET")                        # Type: 0=Incremental, 1=Absolute
epicsEnvSet("ECMC_EC_ENC_ACTPOS",         "NOT SET")                        # Ethercat entry for actual position input (encoder)
epicsEnvSet("ECMC_ENC_ABS_BITS",          "NOT SET")                        # Absolute bit count (for absolute encoders) always least significant part
epicsEnvSet("ECMC_ENC_ABS_OFFSET"         "NOT SET")                        # Encoder offset in eng units (for absolute encoders)

#Drive
epicsEnvSet("ECMC_DRV_SCALE_NUM"          "NOT SET") 
epicsEnvSet("ECMC_DRV_SCALE_DENOM"        "NOT SET")
epicsEnvSet("ECMC_EC_DRV_CONTROL",        "NOT SET")                        # Ethercat entry for control word or bit output
epicsEnvSet("ECMC_EC_DRV_STATUS",         "NOT SET")                        # Ethercat entry for status word or bit input
epicsEnvSet("ECMC_EC_DRV_VELOCITY",       "NOT SET")                        # Ethercat entry for velocity setpoint output
epicsEnvSet("ECMC_EC_DRV_BRAKE",          "NOT SET")                        # Ethercat entry for brake output
epicsEnvSet("ECMC_EC_DRV_REDUCE_TORQUE",  "NOT SET")                        # Ethercat entry for reduce torque output
epicsEnvSet("ECMC_DRV_BRAKE_OPEN_DLY_TIME",    "NOT SET")                   # Brake timing parameter in cycles (default 1kHz)
epicsEnvSet("ECMC_DRV_BRAKE_CLOSE_AHEAD_TIME", "NOT SET")                   # Brake timing parameter in cycles (default 1kHz)


#Trajectory
epicsEnvSet("ECMC_VELO",                  "NOT SET")
epicsEnvSet("ECMC_JOG_VEL",               "NOT SET")
epicsEnvSet("ECMC_JAR",                   "NOT SET")                        # JAR defaults to VELO/ACCL
epicsEnvSet("ECMC_ACCL",                  "NOT SET")
epicsEnvSet("ECMC_EMERG_DECEL",           "NOT SET")                        # Emergency deceleration
epicsEnvSet("ECMC_MRES",                  "NOT SET")

#Homing
epicsEnvSet("ECMC_HOME_PROC",             "NOT SET")
epicsEnvSet("ECMC_HOME_POS",              "NOT SET")
epicsEnvSet("ECMC_HOME_VEL_TO",           "NOT SET")
epicsEnvSet("ECMC_HOME_VEL_FRM",          "NOT SET")
epicsEnvSet("ECMC_HOME_ACC",              "NOT SET")
epicsEnvSet("ECMC_HOME_DEC",              "NOT SET")

#Controller
epicsEnvSet("ECMC_CNTRL_KP",              "NOT SET")
epicsEnvSet("ECMC_CNTRL_KI",              "NOT SET")
epicsEnvSet("ECMC_CNTRL_KD",              "NOT SET")
epicsEnvSet("ECMC_CNTRL_KFF",             "NOT SET")

#Monitoring
# Switches
epicsEnvSet("ECMC_EC_MON_LOWLIM",         "NOT SET")                        #  Ethercat entry for low limit switch input
epicsEnvSet("ECMC_EC_MON_HIGHLIM",        "NOT SET")                        #  Ethercat entry for high limit switch inpuit
epicsEnvSet("ECMC_EC_MON_HOME_SWITCH",    "NOT SET")                        #  Ethercat entry for home switch input
epicsEnvSet("ECMC_EC_MON_EXT_INTERLOCK",  "NOT SET")                        #  Ethercat entry for external interlock input

# Softlimits (disable with 0,0,0)
epicsEnvSet("ECMC_SOFT_LOW_LIM",          "NOT SET")
epicsEnvSet("ECMC_SOFT_HIGH_LIM",         "NOT SET")
epicsEnvSet("ECMC_DXLM_ENABLE",           "NOT SET")

# Position lag
epicsEnvSet("ECMC_MON_LAG_MON_TOL",       "NOT SET")
epicsEnvSet("ECMC_MON_LAG_MON_TIME",      "NOT SET")
epicsEnvSet("ECMC_MON_LAG_MON_ENA",       "NOT SET")

# At target
epicsEnvSet("ECMC_MON_AT_TARGET_TOL",     "NOT SET")
epicsEnvSet("ECMC_MON_AT_TARGET_TIME",    "NOT SET")
epicsEnvSet("ECMC_MON_AT_TARGET_ENA",     "NOT SET")

# Velocity
epicsEnvSet("ECMC_MON_VELO_MAX",          "NOT SET")
epicsEnvSet("ECMC_MON_VELO_MAX_TRAJ_TIME","NOT SET")
epicsEnvSet("ECMC_MON_VELO_MAX_DRV_TIME", "NOT SET")
epicsEnvSet("ECMC_MON_VELO_MAX_ENA",      "NOT SET")
