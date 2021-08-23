from ecmcJinja2 import JinjaCli
from ecmcPlc import EcmcPlc

if __name__ == '__main__':
    cli = JinjaCli()
    plc = EcmcPlc(cli.cfgFile, cli.templatedir, cli.template)
    plc.jt.write(cli.outFile)
