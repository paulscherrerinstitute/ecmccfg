import yaml
import sys
import pathlib

def main():
    if(len(sys.argv)<3):
        return
    
    cfgfileName=sys.argv[1]
    outputfileName=sys.argv[2]
    filenameToSet=""
    if len(sys.argv)>3:
      filenameToSet=sys.argv[3]
    print('filenameToSet:' + filenameToSet)
    pathlib.Path(outputfileName).parent.mkdir(parents=True, exist_ok=True)  # make sure the output path exists
    outfile = open(outputfileName,'w')
    infile = open(cfgfileName, 'r')  
    yamldata = yaml.safe_load(infile)            
    
    if len(filenameToSet) < 1:
        yaml.dump(yamldata,outfile)
        return

    if 'plc' in yamldata.keys():
        # Set filename
        if 'file' in yamldata['plc'].keys():
            print('OLD FILENAME: ' + yamldata['plc']['file'])
            yamldata['plc']['file'] = filenameToSet
    yaml.dump(yamldata,outfile)

if __name__ == '__main__':
    main()
