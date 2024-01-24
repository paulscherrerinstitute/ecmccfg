import yaml
import sys
import pathlib

'''
Opens up a yaml cfg file reads the plc.file filename. This is needed in order to evaluate macros in the filename
arg1: yaml cfg file
arg2: output file wich can be executed in epics env (epicsEnvSet()). Value is is set in ECMC_PLC_FILENAME
'''


def main():
    if(len(sys.argv)<3):
        return

    cfgfileName=sys.argv[1]
    outputfileName=sys.argv[2]
    pathlib.Path(outputfileName).parent.mkdir(parents=True, exist_ok=True)  # make sure the output path exists
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
