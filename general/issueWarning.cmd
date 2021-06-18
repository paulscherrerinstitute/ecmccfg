#==============================================================================
# issueWarning.cmd
#-d /** 
#-d   \brief Generic verification script for expressions
#-d          if the evaluated expression is true then issue WARNING TEXT
#-d
#-d   \author Anders Sandstroem
#-d
#-d    Arguments: 
#-d      EXPR_STR         :  Expression.    
#-d      WARNING_STR      :  Error Mesage (if EXPR is false)
#-d
#-d   \file
#-d */

ecmcEpicsEnvSetCalcTernary(ECMC_EXE_CMD,"${EXPR_STR}","", "#-")
${ECMC_EXE_CMD}############## WARNING ##################################################
${ECMC_EXE_CMD}#${WARNING_STR = ""}
${ECMC_EXE_CMD}#########################################################################
epicsEnvUnset(ECMC_EXE_CMD)
