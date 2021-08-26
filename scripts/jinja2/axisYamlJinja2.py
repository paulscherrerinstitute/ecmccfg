from ecmcJinja2 import JinjaCli
from ecmcAxes import EcmcAxis

if __name__ == '__main__':
    cli = JinjaCli()

    axis = EcmcAxis(cli.cfgFile, cli.templatedir)
    axis.create()
    # if the config has a 'var' key, run renderer twice
    if axis.hasVariables:
        axis.config.setTemplate(axis.config.render(axis.yamlData))
        axis.config.show()
    axis.config.render(axis.yamlData)
    axis.config.show()
    axis.config.write(cli.outFile)

