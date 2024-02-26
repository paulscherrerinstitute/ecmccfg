import ecmcJinja2
import ecmcEnc


def main():
    """
    render encoder configuration to `cli.outFile` based on yaml-config `cli.cfgFile`
    The script will lint the input and validate the encoder against the configured type    
    """
    cli = ecmcJinja2.JinjaCli()

    enc = ecmcEnc.EcmcEnc(cli.cfgFile, cli.templatedir)
    enc.create()
    enc.make()
    enc.encTemplate.writeProduct(cli.outFile)

if __name__ == '__main__':
    main()
