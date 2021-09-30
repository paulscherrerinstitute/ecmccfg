from ecmcYamlHandler import *
from ecmcJinja2 import JinjaTemplate
from pathlib import Path
from ecmcPlc import EcmcPlc


class EcmcAxis(YamlHandler):
    def __init__(self, axisconfig, jinjatemplatedir):
        super().__init__()
        c = Path(axisconfig)
        if c.exists() and c.is_file():
            self.axisconfig = axisconfig
        else:
            raise FileNotFoundError(f'axis configuration >> {axisconfig} << not found!')
        p = Path(jinjatemplatedir)
        if p.exists() and p.is_dir():
            self.jinjatemplatedir = jinjatemplatedir
        else:
            raise FileNotFoundError(f'template directory >> {jinjatemplatedir} << not found!')
        self.config = None

    def create(self):
        self.loadYamlData(self.axisconfig)
        self.setEcmcAxisType()
        if self.axisType == 1:
            self.config = EcmcJoint(self.axisconfig, self.jinjatemplatedir)
        elif self.axisType == 2:
            self.config = EcmcEndEffector(self.axisconfig, self.jinjatemplatedir)
        else:
            ''' this should never happen, as setEcmcAxisType catches unsupported axisTypes '''
            raise NotImplementedError(f'axis ot type >> {self.axisType} << not implemented')


class EcmcCommonAxis(JinjaTemplate, YamlHandler):
    def __init__(self, _jinjatemplatedir, _configuration):
        super(EcmcCommonAxis, self).__init__(directory=_jinjatemplatedir, templateFile=None)
        self.loadYamlData(_configuration)
        self.setEcmcAxisType()
        self.checkForVariables()
        self.setAxisTemplate()

    def setAxisTemplate(self, type_=None, template=None):
        if type_ is None:
            type_ = self.axisType
        axisTemplates = {
            0: 'debug.jinja2',
            1: 'joint.jinja2',
            2: 'endEffector.jinja2',
        }
        self.read(axisTemplates[type_])


class EcmcEndEffector(EcmcCommonAxis):
    def __init__(self, _configuration, _jinjatemplatedir):
        super(EcmcEndEffector, self).__init__(_jinjatemplatedir=_jinjatemplatedir, _configuration=_configuration)
        self.pruneConfiguration()

    def pruneConfiguration(self):
        self.yamlData['drive'] = None
        self.yamlData['controller'] = None


class EcmcJoint(EcmcCommonAxis):
    def __init__(self, _configuration, _jinjatemplatedir):
        super(EcmcJoint, self).__init__(_jinjatemplatedir=_jinjatemplatedir, _configuration=_configuration)


if __name__ == '__main__':
    # axis = EcmcAxis('./test/testEndEffector.yaml', './templates/')
    axis = EcmcAxis('./test/testJoint.yaml', './templates/')
    # axis = EcmcAxis('./test/testJointWithPlc.yaml', './templates/')
    axis.create()
    # axis.config.setAxisTemplate(0) # load 'debug.jinja2'
    ''' if the config has a 'var' key, run renderer twice'''
    if axis.config.hasVariables:
        axis.config.setTemplate(axis.config.render(axis.yamlData))
    axis.config.render(axis.yamlData)
    axis.config.show()
    axis.config.write('test.txt')

