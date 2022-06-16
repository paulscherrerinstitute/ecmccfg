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

        if self.yamlHandler.hasPlcFile:
            self.loadPlcFile()
        self.plcTemplate.read(self.plcTemplates[self.plc_type])
        if self.yamlHandler.hasVariables:
            self.plcTemplate.setTemplate(self.plcTemplate.render(self.yamlHandler.yamlData))
        self.plcTemplate.render(self.yamlHandler.yamlData)

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


def main():
    plc = EcmcPlc('./test/testPlc.yaml', './templates/')
    # plc = EcmcPlc('pytest/yaml_files/joint_all.yaml', './templates/')
    # plc = EcmcPlc('./test/testJointWithPlc.yaml', './templates/')
    plc.create()
    plc.make()
    print(plc.yamlHandler.yamlData)
    plc.plcTemplate.render(plc.yamlHandler.yamlData)
    plc.plcTemplate.showProduct()


if __name__ == '__main__':
    main()