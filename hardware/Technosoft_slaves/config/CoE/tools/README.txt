Some notes regarding technosoft drives.
The Technosoft drives are normally configured in an engineering tool called EasySetup or EasyMotion (running under windows).
The configurations inlcude what kind of motor and encoder and so on that will be used. This configuration then can be downloaded over RS232 to the drive from the EasySetup/Motion software. The configurations made in EasySetup can be exported to a sw file containing the configured data. The sw file can be parsed and downloaded to the drive over ethercat instead of rs232 by accessing the sdos, 2063,2064,2065.

Workflow:
1. Export configurations made in EasySetup/Motion to an SW file (EasyMotion->Application->Create EEPROM Programmer File->Setup Only-> <choose filename>)
2. Convert the sw-file to something that ECMC can read by executing the Python script stored in ecmccfg/hardware/Technosoft_slaves/tools/generateEcmcCmdFromSwSetupFile.py
   generateEcmcCmdFromSwSetupFile.py <inputfile.sw> <ecmcSDOfile>
3. Download the new config file (ecmcSDOfile) to the drive by using the ecmcIPOS8020-Init.cmd script. NOTE: The scripts needs to be edited with the new filename inside (ecmcSDOfile).
   The row that needs editing looks:
  # Download base config (parsed from Techosoft EasySetup configuration): Only needed first time a drive is used..
   ${SCRIPTEXEC} ${ecmccfg_DIR}ecmcIPOS8020-BaseConfig-StepperOpenLoopCSV.cmd
   change to:
   ${SCRIPTEXEC} ${ecmccfg_DIR}<ecmcSDOfile>

4. Check that online and offline checksums match (see print outs from ecmcIPOS8020-Init.cmd)
5. Now the new configuration is loaded!
