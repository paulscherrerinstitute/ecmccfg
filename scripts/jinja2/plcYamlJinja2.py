from ecmcJinja2 import JinjaCli
from ecmcPlc import EcmcPlc

if __name__ == '__main__':
    cli = JinjaCli()
    plc = EcmcPlc(cli.cfgFile, cli.template)
    plc.write(cli.outFile)
