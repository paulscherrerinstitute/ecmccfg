from ecmcYamlHandler import *
from ecmcJinja2 import JinjaTemplate


class EcmcBaseAxis(YamlHandler):
    def __init__(self, axisconfig, jinjatemplatedir):
        super().__init__()
        self.jinjatemplatedir = jinjatemplatedir
        self.loadYamlData(axisconfig)
        self.setEcmcAxisType()
        self.axis = None

    def setAxis(self):
        if self.axisType == 1:
            self.axis = EcmcJoint(self.yamlData, self.jinjatemplatedir)
        else:
            self.axis = EcmcEndEffector(self.yamlData, self.jinjatemplatedir)


class EcmcCommonAxis(YamlHandler):
    def __init__(self, jinjatemplatedir_, configuration_):
        super().__init__()
        print("Setup")
        self.jt = JinjaTemplate(jinjatemplatedir_)
        self.configuration = configuration_
        self.axisType = self.configuration['axis']['EcmcType']
        self.setAxisTemplate()

    def setAxisTemplate(self):
        axisTemplate = {
            1: 'joint.jinja2',
            2: 'endEffector.jinja2',
        }
        self.jt.read(axisTemplate[self.axisType])

    def render(self):
        self.jt.render(self.configuration)


class EcmcEndEffector(EcmcCommonAxis):
    def __init__(self, configuration, jinjatemplatedir):
        super(EcmcEndEffector, self).__init__(jinjatemplatedir_=jinjatemplatedir, configuration_=configuration)
        self.pruneConfiguration()
        self.render()
        print('VIRTUAL AXIS')
        print(self.jt.product)

    def pruneConfiguration(self):
        self.configuration['drive']=None
        self.configuration['controller']=None


class EcmcJoint(EcmcCommonAxis):
    def __init__(self, configuration, jinjatemplatedir):
        super(EcmcJoint, self).__init__(jinjatemplatedir_=jinjatemplatedir, configuration_=configuration)
        self.render()
        print('PHYSICAL AXIS')
        print(self.jt.product)


if __name__ == '__main__':
    axis = EcmcBaseAxis('./test/testEndEffector.yaml', './templates/')
    axis.setAxis()
