#===============================================================================
# applyConfig.cfg
#- Apply hardware configuration

#-d /**
#-d   \brief Script for applying the repviously configured hardware..
#-d   \author Niko Kivel
#-d   \file
#-d   \note call
#-d   \code
#-d     ${SCRIPTEXEC} ${ecmccfg_DIR}applyConfig.cfg
#-d   \endcode
#-d */

ecmcConfigOrDie "Cfg.EcApplyConfig(1)"
