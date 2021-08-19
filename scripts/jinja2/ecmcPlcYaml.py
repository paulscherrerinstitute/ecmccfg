import re
import yaml
from pathlib import Path

import cliPlcArgParse


class EcmcPlc:
    def __init__(self):
        self.args = cliPlcArgParse.getArgs()
        self.tmpDir = None
        self.cfgFile = None
        self.template = None
        self.outFile = None
        self.data = None
        self.getCliArgs()
        Path(self.outFile).parent.mkdir(parents=True, exist_ok=True) # make sure the output path exists

    def getCliArgs(self):
        self.tmpDir = Path(self.args['tmpdir'])
        self.template = Path(self.args['template'])
        self.cfgFile = Path(self.args['data'])
        self.outFile = Path(self.tmpDir, self.args['outfile'])

    def loadPlcConfig(self):
        # open yaml file containing the PLC configuration
        with open(self.cfgFile) as f:
            self.data = yaml.load(f, Loader=yaml.FullLoader)
        # TODO: add sanity check
        if 'file' in self.data['plc']:
            self.loadPlcFile()

    def loadPlcFile(self):
        # if the config contains a 'file', load the file and replace all 'plc.code'
        if 'file' in self.data['plc'] and self.data['plc']['file'] is not None:
            self.data['plc']['code'] = self.readPlcFile(self.data['plc']['file'])

    @staticmethod
    def readPlcFile(filename):
        code = []
        with open(filename, "r") as f:
            for line in f:
                line = line.strip()  # strip new lines
                if len(line) == 0:  # remove empty lines
                    continue
                x = re.findall("^#.*", line)  # remove commented lines
                if x:
                    continue
                line = line.replace(";",
                                    "|")  # statements are terminated with a pipe, but plc-files use a semi colon ';'
                code.append(line)  # append whatever is left
        return code

    def debug(self):
        print('cliArgs   = \n{}'.format(yaml.dump(self.args)))
        print('tmpDir    = {}'.format(self.tmpDir))
        print('template  = {}'.format(self.template))
        print('cfgFile   = {}'.format(self.cfgFile))
        print('outFile   = {}'.format(self.outFile))
        print('data      = \n{}'.format(yaml.dump(self.data)))
