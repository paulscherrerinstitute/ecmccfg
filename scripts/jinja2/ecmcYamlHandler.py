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
    }

    def __init__(self):
        self.yamlData = None
        self.hasVariables = False
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
                raise ValueError('yaml file does not contain >> {} <<'.format(key))

    def checkForVariables(self):
        if self.checkForKey('var', optional=True):
            self.hasVariables = True

    def setEcmcAxisType(self):
        self.checkForKey('axis')
        self.checkForKey('type', self.yamlData['axis'])
        axisType = str(self.yamlData['axis']['type']).lower()
        if axisType in self.supportedAxisTypes:
            type_ = self.supportedAxisTypes[axisType]
            self.yamlData['axis']['EcmcType'] = type_
            self.axisType = self.supportedAxisTypes[axisType]
        else:
            raise TypeError('unknown axis type "{}".\nSupported type are:\n{}'.format(
                axisType, yaml.dump(self.supportedAxisTypes)))
