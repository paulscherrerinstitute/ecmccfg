
# control
bash ctrlMainTestOneAxis.bash ~/projects/e3-7.0.4/ecat/e3-ecmccfg/ecmccfg-dev/examples/mcu1025_fat_sat/control.cfg 

# data acq

IOC_TEST:m0s003-Enc01-PosAct  : resolver simulation (SSI)
IOC_TEST:m0s012-Enc01-PosAct  : reference ILD 2300
IOC_TEST:Axis1-PosAct         : open loop counter
IOC_TEST:Axis1-PosSet         : position setpoint / target pos
IOC_TEST:m0s001-BI01          : Fwd limit
IOC_TEST:m0s002-BI02          : Bwd limit 
camonitor -n -g10 IOC_TEST:m0s003-Enc01-PosAct IOC_TEST:m0s012-Enc01-PosAct IOC_TEST:TestNumber IOC_TEST:Axis1-PosAct  IOC_TEST:m0s001-BI01 IOC_TEST:m0s001-BI02 IOC_TEST:Axis1-PosSet | tee ~/tempdata/data.log

# report
bash reportMain.bash ~/projects/e3-7.0.4/ecat/e3-ecmccfg/ecmccfg-dev/examples/mcu1025_fat_sat/report.cfg ~/tempdata/data.log ~/projects/e3-7.0.4/ecat/e3-ecmccfg/ecmccfg-dev/examples/mcu1025_fat_sat/report.md
