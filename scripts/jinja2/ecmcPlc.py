import re
from ecmcYamlHandler import *
from ecmcJinja2 import JinjaTemplate


class EcmcPlc(YamlHandler):
    def __init__(self, plcconfig, jinjatemplatedir):
        super().__init__()
        self.jinjatemplatedir = jinjatemplatedir
        self.loadYamlData(plcconfig)
        self.checkForVariables()
        self.config = None

    def create(self):
        if self.checkForKey('axis', optional=True):
            self.config = EcmcAxisPlc(self.yamlData, self.jinjatemplatedir)
        else:
            self.config = EcmcStandAlonePlc(self.yamlData, self.jinjatemplatedir)

    def sanityCheckPlc(self):
        self.checkForKey('plc')
        self.checkForPlcFile()
        self.checkForVariables()

    def loadPlcFile(self):
        # replace all 'plc.code' with the content of {{ plc.file }}
        self.yamlData['plc']['code'] = self.readPlcFile(self.yamlData['plc']['file'])

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
                code.append(line)  # append whatever is left
        return code


class EcmcCommonPlc(JinjaTemplate):
    def __init__(self, _jinjatemplatedir, _configuration):
        super(EcmcCommonPlc, self).__init__(directory=_jinjatemplatedir, templateFile=None)
        self.configuration = _configuration
        self.setPlcTemplate()

    def setPlcTemplate(self, type_= 1, template = None):
        if 'axis' in self.configuration:
            type_ = 2
        plcTemplates = {
            0: 'debug.jinja2',
            1: 'plc.jinja2',
            2: 'axisSynchronization.jinja2',
        }
        self.read(plcTemplates[type_])

class EcmcAxisPlc(EcmcCommonPlc):
    def __init__(self, _configuration, _jinjatemplatedir):
        super(EcmcAxisPlc, self).__init__(_jinjatemplatedir=_jinjatemplatedir, _configuration=_configuration)


class EcmcStandAlonePlc(EcmcCommonPlc):
    def __init__(self, _configuration, _jinjatemplatedir):
        super(EcmcStandAlonePlc, self).__init__(_jinjatemplatedir=_jinjatemplatedir, _configuration=_configuration)

if __name__ == '__main__':
    plc = EcmcPlc('./test/testPlc.yaml', './templates/')
    # plc = EcmcPlc('./test/testJointWithPlc.yaml', './templates/')
    plc.create()
    plc.sanityCheckPlc()
    if plc.hasPlcFile:
        print("loading plc file")
        plc.loadPlcFile()
    if plc.hasVariables:
        plc.config.setTemplate(plc.config.render(plc.yamlData))
    plc.config.render(plc.yamlData)
    plc.config.show()
