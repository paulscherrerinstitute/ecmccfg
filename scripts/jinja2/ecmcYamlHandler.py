import yaml


class YamlHandler:
    def __init__(self):
        self.yamlData = None
        self.hasVariables = False

    def loadYamlData(self, file):
        # open yaml file containing the PLC configuration
        with open(file) as f:
            self.yamlData = yaml.load(f, Loader=yaml.FullLoader)

    def checkForVariables(self):
        if 'var' in self.yamlData:
            self.hasVariables = True
