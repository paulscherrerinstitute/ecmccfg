import yaml


class YamlHandler:
    def __init__(self):
        self.yamlData = None

    def loadYamlData(self, file):
        # open yaml file containing the PLC configuration
        with open(file) as f:
            self.yamlData = yaml.load(f, Loader=yaml.FullLoader)
