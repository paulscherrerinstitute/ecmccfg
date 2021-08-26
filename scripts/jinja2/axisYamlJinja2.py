from ecmcJinja2 import JinjaCli
from ecmcAxes import EcmcAxis

if __name__ == '__main__':
    cli = JinjaCli()
    print(cli.template)
    axis = EcmcAxis(cli.cfgFile, cli.templatedir)
    axis.jt.render(axis.yamlData)
    print(axis.jt.product)
    axis.jt.write(cli.outFile)
