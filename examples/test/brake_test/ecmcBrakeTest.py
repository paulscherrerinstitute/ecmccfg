#!/usr/bin/env python
# test brake ecmc control
# python ecmcBrakeTest.py IOC_TEST: Axis1 m0s002-BO01 m0s002-BO02 m0s001-One m0s001-Drv01-Stat 1.0 2.0

import epics
import os
import sys
import time
import math
import unittest

# python ecmcBrakeTest IOC_TEST: Axis1 m0s002-BO01 m0s002-BO02 m0s001-One m0s001-Drv01-Stat 1 2
# 1. prefix                     IOC_TEST:
# 2. Axis:                      Axis1
# 3. Limits:                    m0s001-One
# 4. hwenable output:           m0s002-BO02
# 5. brake output:              m0s002-BO01
# 6. driveStatusWordPV (bit 0)  m0s001-Drv01-Stat
# 7. open time [s]              1.0
# 8. close time  [s]            2.0 

BR_CLOSED = 0
BR_OPEN   = 1

ENABLED   = 1
DISABLED  = 0

class ecmcBrakeTest(unittest.TestCase):
    def __init__(self,prefix,motorPvName,brakePvName,hwEnaPvName,limitsPvName,driveStatWdPv, opentime,closetime):
        self.prefix = prefix
        self.PVs = {}
        self.motorPv = epics.PV(prefix+motorPvName)
        self.brakePv = epics.PV(prefix+brakePvName)
        self.enabledPv = epics.PV(prefix+motorPvName+"-EnaAct")
        self.hwEnaPv = epics.PV(prefix+hwEnaPvName)
        self.rstPv = epics.PV(prefix+motorPvName+"-RstCmd")
        self.errPv = epics.PV(prefix+motorPvName+"-ErrId")
        self.limitsPv = epics.PV(prefix+limitsPvName)
        self.enableCmdPv=epics.PV(prefix+motorPvName + '.CNEN')
        self.driveStatWdPv=epics.PV(prefix+driveStatWdPv)
        self.motorPv.get()
        self.brakePv.get()
        self.enabledPv.get()
        self.hwEnaPv.get()
        self.rstPv.get()
        self.errPv.get()
        self.limitsPv.get()
        self.driveStatWdPv.get()
        self.enableCmdPv.put(0)        
        self.waitForDisabled()
        self.opentime=opentime
        self.closetime=closetime
        
    def getEL70XXStatWdEnabled(self):
        # bit 1 of status word
        status=int(self.driveStatWdPv.get())
        return status & int(2)

    def reset(self):
        self.rstPv.put(1)
        self.rstPv.put(0)

    def waitForDisabled(self):
        while self.enabledPv.get():
            time.sleep(0.1)
        time.sleep(0.1)

    def waitForEnabled(self):
        while not self.enabledPv.get():
            time.sleep(0.1)
        time.sleep(0.1)
    
    # Wait for drive enabled (status word) != axis enabled
    # Axis enabled == drive enabled and brake disenagaged
    def waitForDriveStatWdEnabled(self):
        while not self.getEL70XXStatWdEnabled():
            time.sleep(0.1)  

    def waitForDriveStatWdDisabled(self):
        while self.getEL70XXStatWdEnabled():
            time.sleep(0.1)

    def waitForBrakeClosing(self):
        while self.brakePv.get():
            time.sleep(0.1)

    def verifyBrakeState(self,state):
        if state == BR_OPEN:
            self.assertTrue(self.brakePv.get())
        if state == BR_CLOSED:
            self.assertFalse(self.brakePv.get())
        #self.assertEqual(self.brakePv.get(),state)
    
    def verifyEnabledState(self,state):
        if state == ENABLED:
            self.assertTrue(self.enabledPv.get())
        if state == DISABLED:
            self.assertFalse(self.enabledPv.get())
    
    def verifyDriveStatusWdEnabled(self,state):
        if state == ENABLED:
            self.assertTrue(self.getEL70XXStatWdEnabled())
        if state == DISABLED:
            self.assertFalse(self.getEL70XXStatWdEnabled())
    
    # initialize
    def testInit(self):
        self.enableCmdPv.put(0)
        # Set drive hw enable
        self.hwEnaPv.put(1)
        
        # Ensure limits are high
        self.limitsPv.put(1)

        errId = self.errPv.get()
        if errId:
            #print ('Startup in error state: ' + str(errId))
            self.reset()

    # remove el7031 hw enable (linked to output)
    def testHwDisable(self):

        print ('test tripp hw-enable test:')
        self.enableCmdPv.put(1)
        self.motorPv.put(self.motorPv.get()+100)
        # Ensure enabled
        self.verifyBrakeState(BR_CLOSED)
        self.waitForEnabled()
        self.verifyEnabledState(ENABLED)
        self.verifyBrakeState(BR_OPEN)
        time.sleep(1)
        
        # Induce error by remove HW enable        
        print ('        Remove hw enable')
        self.hwEnaPv.put(0)
        time.sleep(0.1)

        for i in range(1,10):
            self.verifyEnabledState(DISABLED)
            self.verifyBrakeState(BR_CLOSED)
            time.sleep(0.1)
        
        print ('        Set hw enable')
        self.hwEnaPv.put(1)
        self.verifyEnabledState(DISABLED)        
        self.verifyBrakeState(BR_CLOSED)
        time.sleep(1)
        # Check again
        self.verifyEnabledState(DISABLED)
        self.verifyBrakeState(BR_CLOSED)
        
        # Ensure not re-enabling after reset
        print ('        reset errors')
        self.reset()        
        self.verifyEnabledState(DISABLED)
        self.verifyBrakeState(BR_CLOSED)
        time.sleep(1)
        # Check again
        self.verifyEnabledState(DISABLED)
        self.verifyBrakeState(BR_CLOSED)
        
        time.sleep(0.1)
        print('test OK')
        
    # trigger drive interlock by disengaging both limits (linked to "ONE" entry)
    def testDriveInterlock(self):
        print ('tripp both limits test:')
        self.enableCmdPv.put(1)
        self.motorPv.put(self.motorPv.get()+1000)
        self.waitForEnabled()
        self.verifyEnabledState(ENABLED)
        self.verifyBrakeState(BR_OPEN)
        time.sleep(0.1)
        print ('        tripp limits')
        self.limitsPv.put(0)
        time.sleep(0.1)
        self.verifyEnabledState(DISABLED)
        self.verifyBrakeState(BR_CLOSED)
        time.sleep(1)
        # Check again
        self.verifyEnabledState(DISABLED)
        self.verifyBrakeState(BR_CLOSED)
        print('test OK')

    def testEnableDisable(self, opentime,closetime):    
        self.testInit()
        # make sure brake is closed before cont test
        while self.brakePv.get():
            time.sleep(0.1)
        self.waitForDisabled()
        # Now we have a known start state for this test.
        print('test normal enabling sequence:')
        self.enableCmdPv.put(1)
        self.waitForDriveStatWdEnabled()
        if opentime>0.1: # only possible to check from python if time is long
           # Now brake should not be applied    
           self.verifyDriveStatusWdEnabled(ENABLED)
           self.verifyBrakeState(BR_CLOSED)
           print('      enabling: drive enabled and brake closed')
        time.sleep(opentime*1.5)
        self.verifyBrakeState(BR_OPEN)
        self.verifyEnabledState(ENABLED)
        self.verifyDriveStatusWdEnabled(ENABLED)
        print('      enabled: drive enabled and brake open')

        print('test normal disabling sequence:')
        self.verifyBrakeState(BR_OPEN)
        self.enableCmdPv.put(0)
        self.waitForBrakeClosing()
        self.verifyBrakeState(BR_CLOSED)
        if closetime>0.1: # only possible to check from python if time is long        
           self.verifyDriveStatusWdEnabled(ENABLED)
           self.verifyBrakeState(BR_CLOSED)
           print('      disabling: drive enabled and brake closed')

        time.sleep(closetime*1.5)
        self.verifyBrakeState(BR_CLOSED)
        self.verifyEnabledState(DISABLED)
        self.verifyDriveStatusWdEnabled(DISABLED)
        print('      disabled: drive disabled and brake closed')
    
        print('test OK')

    def testAll(self):
        # initialize
        self.testInit()
        # test disable hw enable (input on el7031)
        self.testHwDisable()
        # test trig drive interlock by set both limits to 0
        self.testDriveInterlock()
        # test timing of normal enabling and disabling
        self.testEnableDisable(self.opentime,self.closetime)


if __name__ == '__main__':
    if len(sys.argv)!= 9:
      print('python ecmcBrakeTest.py <prefix> <axis> <brake output> <hw-enable output> <limits output> <drive stat wd> <brake opening time> <brake closing time>')
      print('Example:')
      print('python ecmcBrakeTest.py IOC_TEST: Axis1 m0s002-BO01 m0s002-BO02 m0s001-One m0s001-Drv01-Stat 1.0 2.0')
      exit(1)
    prefix        = sys.argv[1]
    motorPvName   = sys.argv[2]
    brakePvName   = sys.argv[3]
    hwEnaPvName   = sys.argv[4]
    limitsPvName  = sys.argv[5]  # could be ec0.s1.ONE (control both limits)
    driveStatWd   = sys.argv[6]
    opentime      = float(sys.argv[7])
    closetime     = float(sys.argv[8])
    testBrake = ecmcBrakeTest(prefix,motorPvName,brakePvName,hwEnaPvName,limitsPvName,driveStatWd,opentime, closetime)
    while True:
        testBrake.testAll()

