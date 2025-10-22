##############################################################################
# Example config for ep7211-0034 CSP
# Use of centralized position loop in CSP-mode (dual position loops).
#
# Description of use-case:
#    Normally, in CSP-mode, no centralized position control will be executed,
#    instead, the position control loop is moved to the drive. It's however
#    possible to activate the centralized ecmc position loop also if needed.
#    A use case could be a rotary servo motor (in CSP-mode) driving a stage equipped with 
#    a linear encoder.
#
# Details:
#    CSP normally must be based on the encoder connected to the drive/motor, in this 
#    case the position control loop is only performed in the drive and ecmc
#    will only send position setpoints. In order to enable (ecmc) position control
#    on the linear encoder, then, also the linear encoder needs to be configured.
#    In this example, the linear encoder is simulated with the same rotary encoder but 
#    with a different scaling (in order for the two encoders to show different 
#    values). The simulated linear encoder should be selected as primary (for control).
#    The drive object still needs to know the drive actual position in order to send
#    accurate position setpoints. This is done by selecting the encoder with 
#    "ecmcConfigOrDie "Cfg.SelectAxisEncCSPDrv(<axis id>,<enc_id>)".
#    This encoder needs to have the proper scaling for the drive.
#    The system will now also use the centralized ecmc position control loop,
#    resulting in 2 position loops are activated, one in ecmc and one in the drive.
#    In this case, the ecmc-PID parameters needs to be defined and then also tuned.
#    Normally a PI controller is needed. The control output to the drive will be 
#    a position setpoint that is controller by the normal ecmc PID controller.
#    If the "Cfg.SelectAxisEncCSPDrv(<axis id>,<enc_id>)" is not executed or if the 
#    primary encoder is selected, then the drive object will by default use the
#    the primary encoder and the position loop in ecmc will be disabled (normal CSP).
#    So, in order to use dual loops, the primary encoder and the CSP drive encoder 
#    needs to be different.
#

require ecmccfg v11.0.0_RC1 "ENG_MODE=1,ECMC_VER=v11.0.0_RC1,MASTER_ID=1"

${SCRIPTEXEC} ${ecmccfg_DIR}addSlave.cmd,        "SLAVE_ID=0, HW_DESC=EP7211-0034_CSP_STD"
#- Limit torque to 50% of motor rated torque.  Rated current = 2710mA, set to half I_MAX_MA=1355
${SCRIPTEXEC} ${ecmccfg_DIR}applyComponent.cmd   "COMP=Motor-Beckhoff-AM8121-XFX0, MACROS='I_MAX_MA=1355'"
$(SCRIPTEXEC) $(ecmccfg_DIR)loadYamlAxis.cmd     "FILE=./cfg/axis_csp.yaml, DRV_ID=$(ECMC_EC_SLAVE_NUM), AX_NAME='Axis1', AX_ID=1"
$(SCRIPTEXEC) $(ecmccfg_DIR)loadYamlEnc.cmd      "FILE=./cfg/enc_sim_linear.yaml, DRV_ID=$(ECMC_EC_SLAVE_NUM)"

