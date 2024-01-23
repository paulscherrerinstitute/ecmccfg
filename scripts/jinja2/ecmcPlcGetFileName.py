import yaml
import sys

def main():
    if(len(sys.argv)<3):
        return

    cfgfileName=sys.argv[1]
    outputfileName=sys.argv[2]
    outfile = open(outputfileName,'w')
    infile = open(cfgfileName, 'r')     
    yamldata = yaml.safe_load(infile)            
    outfile.write("#- Temp command file for retriving plc file name from yaml cfg\n")
    if 'plc' in yamldata.keys():
        # Get filename
        if 'file' in yamldata['plc'].keys(): 
            filename=yamldata['plc']['file']
            print('plc.file: ' + filename)
            outfile.write("epicsEnvSet(ECMC_PLC_FILENAME,\"" + filename + "\")\n")
        # Get macros
        if 'macros' in yamldata['plc'].keys(): 
            macros=yamldata['plc']['macros']
            print('plc.macros: ' + macros)
            outfile.write("epicsEnvSet(ECMC_PLC_MACROS,\"" + macros + "\")\n")

if __name__ == '__main__':
    main()
