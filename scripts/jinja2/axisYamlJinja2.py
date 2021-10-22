from ecmcJinja2 import JinjaCli
from ecmcAxes import EcmcAxis

if __name__ == '__main__':
    cli = JinjaCli()

    axis = EcmcAxis(cli.cfgFile, cli.templatedir)
    axis.create()
    ''' if the config has a 'var' key, run renderer twice'''
    if axis.config.hasVariables:
        axis.config.setTemplate(axis.config.render(axis.config.yamlData))
    axis.config.render(axis.config.yamlData)
    if axis.config.hasSyncPLC:
        plc = axis.config.axisPlc
        plc.checkForPlcFile()
        plc.checkForVariables()
        if plc.hasPlcFile:
            plc.loadPlcFile()
        if plc.hasVariables:
            plc.config.setTemplate(plc.config.render(plc.yamlData))
        plc.config.render(plc.yamlData)
        axis.config.product += plc.config.product
    axis.config.write(cli.outFile)
