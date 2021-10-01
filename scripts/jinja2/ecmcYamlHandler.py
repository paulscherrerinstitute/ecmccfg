import yaml


class YamlHandler:
    supportedAxisTypes = {
        '0': 0,
        'debug': 0,
        '1': 1,
        'j': 1,
        'joint': 1,
        'physical': 1,
        'motor': 1,
        'real': 1,
        '2': 2,
        'e': 2,
        'ee': 2,
        'end effector': 2,
        'end_effector': 2,
        'endeffector': 2,
        'virtual': 2,
    }

    def __init__(self):
        self.yamlData = None
        self.hasVariables = False
        self.hasPlcFile = False
        self.axisType = None

    @staticmethod
    def str2bool(val) -> bool:
        true = ['true', '1', 't', 'y', 'yes']
        false = ['false', '0', 'f', 'n', 'no']
        val = str(val)

        if val.lower() in true:
            return True
        elif val.lower() in false:
            return False
        else:
            raise ValueError(f'unrecognized string >> {val} <<')

    def loadYamlData(self, file):
        # open yaml file containing the PLC configuration
        with open(file) as f:
            self.yamlData = yaml.load(f, Loader=yaml.FullLoader)

    def getKey(self, key, data):
        if data is None:
            raise ValueError(f'cannot obtain key >> {key} << from data of \'NoneType\'')
        if isinstance(key, list):
            for k in key:
                data = self.getKey(k, data=data)  # if not None else None
            return data
        return data[str(key)]

    def checkForKey(self, key, data_=None, optional=False):
        data = data_ if data_ is not None else self.yamlData

        try:
            self.getKey(key, data)
            return True
        except KeyError:
            if optional:
                return False
            else:
                raise
        except ValueError:
            raise

    def checkForVariables(self):
        self.hasVariables = self.checkForKey('var', optional=True)

    def checkForSyncPlc(self):
        if self.checkForKey(['sync','enable'], optional=True):
            if self.str2bool(self.getKey(['sync','enable'], self.yamlData)):
                return True
        return False

    def checkForPlcFile(self):
        # if the config contains a 'file', set the flag to trigger loading {{ plc.file }}
        try:
            self.hasPlcFile = self.checkForKey('file', self.yamlData['plc']) and self.yamlData['plc'][
                'file'] is not None
        except:
            pass

    def getAxisType(self):
        self.checkForKey('axis')
        try:
            self.checkForKey('type', self.yamlData['axis'])
            type_ = str(self.yamlData['axis']['type']).lower()
        except KeyError:
            type_ = '1'

        self.isSupportedAxisType(type_)

        return self.supportedAxisTypes[type_]

    def isSupportedAxisType(self, type_):
        if str(type_) not in self.supportedAxisTypes:
            raise NotImplementedError(f'Axis type >> {type_} << not implemented.\nSupported type are:\n'
                                      f'{yaml.dump(self.supportedAxisTypes)}')
        return True

    def setEcmcAxisType(self, type_=None):
        if type_ is None:
            type_ = self.getAxisType()
        else:
            self.isSupportedAxisType(type_)

        self.axisType = self.supportedAxisTypes[str(type_)]


if __name__ == '__main__':
    h = YamlHandler()

    # print(h.checkForKey('dummy', data_="{'dummy': '0'}"))

    h.yamlData = {'axis': {'type': 'joint'}}
    print(h.checkForKey('axis'))
    print(h.getKey('axis',h.yamlData))
    h.yamlData = {'axis': {'type': 'joint'}, 'sync': {'enable': 'true'}}
    print(h.getKey('sync',h.yamlData))
    syncEna = h.getKey('enable', data=h.getKey('sync',h.yamlData))
    print(h.str2bool(syncEna) == True)
    print(h.getKey('noGood', data=h.getKey('sync',h.yamlData)))
    # print(h.getKey(1, data_=h.getKey('sync')))
    # print(h.getKey(['axis','type'], data_=h.getKey('foo')))
    h.yamlData = {'axis': {'type': 'joint'}, 'sync': {'enable': 'true'}}
    print(h.getKey(['axis', 'type']))
