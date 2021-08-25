from ecmcJinja2 import JinjaCli
from ecmcAxes import EcmcBaseAxis

if __name__ == '__main__':
    cli = JinjaCli()
    print(cli.template)
    axis = EcmcBaseAxis(cli.cfgFile, cli.templatedir)
    axis.jt.render(axis.yamlData)
    print(axis.jt.product)
    axis.jt.write(cli.outFile)
