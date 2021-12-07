import yaml
import datetime

from ecmcJinja2 import JinjaCli
from ecmcAxes import EcmcAxis

if __name__ == '__main__':
    cli = JinjaCli()

    # axis = EcmcAxis(cli.cfgFile, cli.templatedir)
    axis = EcmcAxis('pytest/yaml_files/joint_benchmark.yaml', './templates/')
    axis.create()
    ''' if the config has a 'var' key, run renderer twice'''
    if axis.config.hasVariables:
        axis.config.setTemplate(axis.config.render(axis.config.yamlData))
    axis.config.read("axisReport_template.adoc")
    axis.config.yamlData['author'] = "Dr. Niko Kivel"
    axis.config.yamlData['date'] = datetime.datetime.today().isoformat("|")
    axis.config.render(axis.config.yamlData)
    axis.config.show()
    axis.config.write("/tmp/axisReport.adoc")

    # if axis.config.hasSyncPLC:
    #     plc = axis.config.axisPlc
    #     plc.checkForPlcFile()
    #     plc.checkForVariables()
    #     if plc.hasPlcFile:
    #         plc.loadPlcFile()
    #     if plc.hasVariables:
    #         plc.config.setTemplate(plc.config.render(plc.yamlData))
    #     plc.config.render(plc.yamlData)
    #     axis.config.product += plc.config.product
    # axis.config.write(cli.outFile)