#==============================================================================
# verifyOrDie.cmd
#-d  /**
#-d   \brief Generic verification script
#-d   \details Generic verification script for expressions
#-d          if the evaluated expression is true the execution will continue otherwise exit
#-d   \author Anders Sandstroem
#-d
#-d    Arguments:
#-d      EXPR_STR       :  Expression.
#-d      SUCCESS_STR    :  Success String (if EXPR is true).
#-d      ERROR_STR      :  Error Mesage (if EXPR is false)
#-d
#-d   \file
#-d */

ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD,"${EXPR_STR}","# ${SUCCESS_STR}", "ecmcExit Error: ${ERROR_STR}")
#- Result:
${ECMC_EXE_CMD}
epicsEnvUnset(ECMC_EXE_CMD)
