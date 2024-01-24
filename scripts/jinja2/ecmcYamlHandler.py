import yaml
import string
import hashlib
from pathlib import Path


import ecmcYamlLinter

from ecmcYamlSchema import supportedAxisTypes


class YamlHandler:
    supportedAxisTypes = supportedAxisTypes

    def __init__(self):
        self.yamlData = {}
        self.hasVariables = False
        self.hasPlcFile = False
        self.axisType = None
        self.md5 = None

    @staticmethod
    def str2bool(val) -> bool:
        true = ['true', '1', 't', 'y', 'yes']
        false = ['false', '0', 'f', 'n', 'no']
        val = str(val).lower()
        if val in true:
            return True
        elif val in false:
            return False
        else:
            raise ValueError(f'unrecognized string >> {val} <<')

    @staticmethod
    def calculate_md5(file: Path) -> str:
        md5_hash = hashlib.md5()
        a_file = open(file, "rb")
        content = a_file.read()
        md5_hash.update(content)
        return md5_hash.hexdigest()

    def loadYamlData(self, file, lint=False, relaxed=True):
        if lint:
            # lint the yaml file
            linter = ecmcYamlLinter.YamlLinter()
            linter.run(file, relaxed)

        digest = self.calculate_md5(file)

        with open(file) as f:
            self.yamlData = yaml.load(f, Loader=yaml.FullLoader)

        if not self.checkForKey('meta', optional=True):
            self.yamlData['meta'] = {}
        self.yamlData['meta']['md5'] = digest

    def getKey(self, key, data):
        if isinstance(key, list):
            for k in key:
                data = self.getKey(k, data=data)
            return data
        return data[str(key)]

    def checkForKey(self, key, data_=None, optional=False):
        data = data_ if data_ is not None else self.yamlData

        try:
            self.getKey(key, data)
            return True
        except KeyError as err:
            if optional:
                return False
            else:
                raise err
        except ValueError as err:
            raise err

    def checkForVariables(self):
        self.hasVariables = self.checkForKey('var', optional=True)

    def checkForSyncPlc(self):
        try:
            return self.str2bool(self.getKey(['sync', 'enable'], self.yamlData))
        except KeyError:
            return False

    def checkForPlcFile(self):
        try:
            plc_file = Path(self.getKey(['plc', 'file'], self.yamlData))
            
            self.hasPlcFile = plc_file.is_file()
        except KeyError:        
            self.hasPlcFile = False

        # Above will not catch error if wrong filename is set in plc.file            
        if len(str(plc_file)) > 0 and not self.hasPlcFile:
            raise FileNotFoundError("File not found: " + str(plc_file))

    def getAxisType(self, type_=None):
        if type_ is None:
            try:
                type_ = self.getKey(['axis', 'type'], self.yamlData)
            except KeyError:
                type_ = 1
        return self.supportedAxisTypes[self.isSupportedAxisType(type_)]

    def isSupportedAxisType(self, type_=None):
        # make lower case and remove all white spaces
        type_str = str(type_).lower().translate(str.maketrans('', '', string.whitespace))
        if type_str not in self.supportedAxisTypes:
            raise NotImplementedError(f'Axis type >> {type_str} << not implemented.\nSupported type are:\n'
                                      f'{yaml.dump(self.supportedAxisTypes)}')
        return type_str

    def setEcmcAxisType(self, type_=None):
        if type_ is None:
            type_ = self.getAxisType()
        self.axisType = self.supportedAxisTypes[self.isSupportedAxisType(type_)]


if __name__ == '__main__':
    h = YamlHandler()

    h.loadYamlData('pytest/yaml_files/joint_all.yaml', relaxed=False)

    # print(yaml.dump(h.yamlData))
    # print(h.getAxisType('j'))
    # print(h.getAxisType())
    #
    # h.yamlData = {'axis': {'type': 'joint'}}
    # print(h.checkForKey('axis'))
    # print(h.getKey('axis', h.yamlData))
    # h.yamlData = {'axis': {'type': 'joint'}, 'sync': {'enable': 'true'}}
    # print(h.getKey('sync', h.yamlData))
    # syncEna = h.getKey('enable', data=h.getKey('sync', h.yamlData))
    # print(h.str2bool(syncEna) == True)
    # print(h.getKey('noGood', data=h.getKey('sync', h.yamlData)))
    # # print(h.getKey(1, data_=h.getKey('sync')))
    # # print(h.getKey(['axis','type'], data_=h.getKey('foo')))
    # h.yamlData = {'axis': {'type': 'joint'}, 'sync': {'enable': 'true'}}
    # print(h.getKey(['axis', 'type']))
