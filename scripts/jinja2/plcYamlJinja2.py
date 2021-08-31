from ecmcJinja2 import JinjaCli
from ecmcPlc import EcmcPlc

if __name__ == '__main__':
    cli = JinjaCli()

    plc = EcmcPlc(cli.cfgFile, cli.templatedir)
    plc.create()
    plc.sanityCheckPlc()
    if plc.hasPlcFile:
        print("loading plc file")
        plc.loadPlcFile()
    if plc.hasVariables:
        plc.config.setTemplate(plc.config.render(plc.yamlData))
    plc.config.render(plc.yamlData)
    plc.config.write(cli.outFile)
