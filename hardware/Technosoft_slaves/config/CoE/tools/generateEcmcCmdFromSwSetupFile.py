#!/usr/bin/python
# coding: utf-8
import sys
import time

class techosoftSetupParser:
  def __init__(self):
    self.inputFileName = ''
    self.outputFileName = ''
    self.epicsSleepTime = 0.01

  def setInputFileName(self,dataFileName):
    self.inputFileName = dataFileName

  def setOutputFileName(self,dataFileName):
    self.outputFileName = dataFileName

  def setEpicsSleepTime(self,time):
    self.epicsSleepTime = time


  def parse(self):
    inputFile = open(self.inputFileName,'r')
    outputFile = open(self.outputFileName,'w')
    startAdressFound = 0
    print("WARNING: The Technosoft configuration file needs to be a pure setup file without any custom TML programs.")
    print("Parsing technosoft setup file: " + self.inputFileName)
    checksum = 0
    lineNumber = 0
    parameterCounter = 0

    for line in inputFile.readlines():
      lineNumber += 1
      line = line.strip()

      if len(line) == 0:
        print("Found end of block at line number: " + str(lineNumber))
        lineNumber = 0

        low16bits = checksum & 0xffff
        stopAdress = startAdress + parameterCounter - 1
        outputFile.write('# Setup drive to calculate online checksum (' + '0x{:02x}'.format(startAdress) + ':' + '0x{:02x}'.format(stopAdress) + '):\n')
        tempString = '0x{:02x}'.format(stopAdress) + '{:02x}'.format(startAdress)  # From to adress
        outputFile.write('ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2069,0x0,' + tempString + ',4)"\n')
        outputFile.write('epicsThreadSleep(' + str(self.epicsSleepTime) + ')\n')  # Sadly needed for this drive for some reason?

        outputFile.write('\n')
        outputFile.write('#########################################################\n')
        outputFile.write('#      Total number of lines parsed: ' + str(parameterCounter) + '\n')
        outputFile.write('#      Offline calculated checksum: ' + '0x{:02x}'.format(low16bits) + ' (' + str(low16bits) + ')\n')
        outputFile.write('#      Online calculated checksum (in drive) (in dec..):\n')
        outputFile.write('ecmcConfig "EcReadSdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,2)"\n')
        outputFile.write('ecmcConfigOrDie "Cfg.EcVerifySdo(${ECMC_EC_SLAVE_NUM},0x206A,0x0,' + '0x{:02x}'.format(low16bits) + ',2)"\n')
        outputFile.write('#########################################################\n')
        outputFile.write('\n')
        startAdressFound = 0
        parameterCounter = 0
        checksum = 0
        continue

      if lineNumber == 1:
        startAdress = int(line,16)
        startAdressString = '0x' + line + '0008'  # 0008 = 16 bit access, auto increment adress. See technosoft CoE manual ch16.4
        print("Start adress is " + startAdressString)

        outputFile.write('#########################################################\n')
        outputFile.write('#  Parsing of Technosoft setup-file to ECMC format.\n')
        outputFile.write('#      Input file name: ' + self.inputFileName + '\n')
        outputFile.write('#      Block start adress: ' + '0x{:02x}'.format(startAdress) + '\n')
        outputFile.write('#      Output file name: ' + self.outputFileName + '\n')
        outputFile.write('#      Date: ' + time.strftime("%Y/%m/%d %H:%M:%S") + '\n')
        outputFile.write('#########################################################\n')
        outputFile.write('\n')

        outputFile.write('ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2064,0x0,' + startAdressString + ',4)"\n')
        outputFile.write('epicsThreadSleep(' + str(self.epicsSleepTime) + ')\n')  #Sadly needed for this drive for some reason?
        startAdressFound = 1
        continue

      if lineNumber>1 and not startAdressFound:
        print("Error: Start adress not found. Parsing aborted.")
        return

      print(line + " length: " + str(len(line)))
      checksum = checksum + int(line,16)
      data = '0x' + line
      outputFile.write('ecmcConfigOrDie "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2065,0x0,' + data + ',4)"\n')
      outputFile.write('epicsThreadSleep(' + str(self.epicsSleepTime) + ')\n')  #Sadly needed for this drive for some reason?
      parameterCounter += 1

    outputFile.write('# Reset drive to apply settings:\n')
    outputFile.write('# NOTE: Reset drive command will return error -5 since no repsonse is sent back to the master! The drive will be reset anyway!\n')
    outputFile.write('ecmcConfig "Cfg.EcWriteSdo(${ECMC_EC_SLAVE_NUM},0x2080,0x0,1,2)"\n')
    outputFile.write('epicsThreadSleep(' + str(self.epicsSleepTime) + ')\n')  #Sadly needed for this drive for some reason?
    inputFile.close()


def main():
  if len(sys.argv) != 3:
    print(str(sys.argv[0]) + ' <fileToParse> <outputFile>')
    return

  tp = techosoftSetupParser()
  tp.setInputFileName(sys.argv[1])
  tp.setOutputFileName(sys.argv[2])
  tp.parse()

if __name__ == "__main__":
    main()
