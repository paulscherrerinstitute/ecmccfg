import pathlib
import re

import ecmcYamlHandler
import ecmcJinja2
import ecmcConfigValidator


class EcmcPlc:
    plcTemplates = {
        0: 'debug.jinja2',
        1: 'plc.jinja2',
        2: 'axisSynchronization.jinja2',
    }

    def __init__(self, config_file, jinja_template_dir):
        if not pathlib.Path(jinja_template_dir).is_dir():
            raise FileNotFoundError(f'template directory >> {jinja_template_dir} << not found!')
        if not pathlib.Path(config_file).is_file():
            raise FileNotFoundError(f'axis configuration >> {config_file} << not found!')

        self.config_file = config_file
        self.plc_type = 1
        self.yamlHandler = ecmcYamlHandler.YamlHandler()

        self.plcTemplate = ecmcJinja2.JinjaTemplate(jinja_template_dir)
        self.v = ecmcConfigValidator.ConfigValidator()

        # self.jinjatemplatedir = jinja_template_dir

        # self.loadYamlData(config_file)
        # self.checkForVariables()
        # self.config = None

    def create(self):
        """
        plc object
        """
        self.yamlHandler.loadYamlData(self.config_file, lint=True)
        self.v.document = self.yamlHandler.yamlData
        self.plc_type = self.v.get_plc_type()  # obtain plc type from data, this pre-validates the 'axis' key

    def make(self):
        """
        wrapper
        """
        self.yamlHandler.yamlData = self.v.validate_plc()
        self.yamlHandler.checkForVariables()
        self.yamlHandler.checkForPlcFile()
        print(f'has PLC file: {self.yamlHandler.hasPlcFile}')
        if self.yamlHandler.hasPlcFile:
            self.loadPlcFile()
        self.plcTemplate.read(self.plcTemplates[self.plc_type])

    def loadPlcFile(self):
        key = 'plc'
        # replace all 'code' with the content of {{ file }}
        self.yamlHandler.yamlData[key]['code'] = self.readPlcFile(self.yamlHandler.yamlData[key]['file'])

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


# class EcmcCommonPlc(JinjaTemplate):
#     def __init__(self, _jinjatemplatedir, _configuration):
#         super(EcmcCommonPlc, self).__init__(directory=_jinjatemplatedir, templateFile=None)
#         self.configuration = _configuration
#         self.setPlcTemplate()
#
#     def setPlcTemplate(self, type_= 1, template = None):
#         if 'axis' in self.configuration:
#             type_ = 2
#
#         self.read(plcTemplates[type_])
#
# class EcmcAxisPlc(EcmcCommonPlc):
#     def __init__(self, _configuration, _jinjatemplatedir):
#         super(EcmcAxisPlc, self).__init__(_jinjatemplatedir=_jinjatemplatedir, _configuration=_configuration)
#
#
# class EcmcStandAlonePlc(EcmcCommonPlc):
#     def __init__(self, _configuration, _jinjatemplatedir):
#         super(EcmcStandAlonePlc, self).__init__(_jinjatemplatedir=_jinjatemplatedir, _configuration=_configuration)

if __name__ == '__main__':
    plc = EcmcPlc('./test/testPlc.yaml', './templates/')
    # plc = EcmcPlc('pytest/yaml_files/joint_all.yaml', './templates/')
    # plc = EcmcPlc('./test/testJointWithPlc.yaml', './templates/')
    plc.create()
    plc.make()
    print(plc.yamlHandler.yamlData)
    plc.plcTemplate.render(plc.yamlHandler.yamlData)
    plc.plcTemplate.show()

    # if plc.hasVariables:
    #     plc.config.setTemplate(plc.config.render(plc.yamlData))
    # plc.config.render(plc.yamlData)
    # plc.config.show()
