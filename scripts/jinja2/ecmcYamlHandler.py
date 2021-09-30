import yaml


class YamlHandler:
    supportedAxisTypes = {
        '1': 1,
        'j': 1,
        'joint': 1,
        'physical': 1,
        'motor': 1,
        'real': 1,
        '2': 2,
        'ee': 2,
        'end effector': 2,
        'end_effector': 2,
        'endeffector': 2,
        'virtual': 2,
        'debug': 0,
    }

    def __init__(self):
        self.yamlData = None
        self.hasVariables = False
        self.hasPlcFile = False
        self.axisType = None

    def loadYamlData(self, file):
        # open yaml file containing the PLC configuration
        with open(file) as f:
            self.yamlData = yaml.load(f, Loader=yaml.FullLoader)

    def checkForKey(self, key, data_=None, optional=False):
        if data_ is not None:
            data = data_
        else:
            data = self.yamlData
        if key in data:
            return True
        else:
            if optional:
                return False
            else:
                raise KeyError(f'yaml file does not contain >> {key} <<')

    def checkForVariables(self):
        self.hasVariables = self.checkForKey('var', optional=True)

    def checkForPlcFile(self):
        # if the config contains a 'file', set the flag to trigger loading {{ plc.file }}
        self.hasPlcFile = self.checkForKey('file', self.yamlData['plc']) and self.yamlData['plc']['file'] is not None

    def getAxisType(self):
        self.checkForKey('axis')
        try:
            self.checkForKey('type', self.yamlData['axis'])
            type_ = str(self.yamlData['axis']['type']).lower()
        except KeyError:
            type_ = '1'

        if type_ not in self.supportedAxisTypes:
            raise NotImplementedError(f'Axis type >> {type_} << not implemented.\nSupported type are:\n'
                                      f'{yaml.dump(self.supportedAxisTypes)}')

        return self.supportedAxisTypes[type_]

    def setEcmcAxisType(self, type_=None):
        if type_ is None:
            type_ = self.getAxisType()
        self.axisType = self.supportedAxisTypes[str(type_)]
