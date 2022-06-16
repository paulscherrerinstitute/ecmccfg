import ecmcJinja2
import ecmcPlc


def main():
    """
    render plc definition to `cli.outFile` based on yaml-config `cli.cfgFile`
    The script will lint the input and validate the axis against the configured type
    In case a PLC is defined within the axis config, the PLC will be validated and added to the product.
    """
    cli = ecmcJinja2.JinjaCli()

    plc = ecmcPlc.EcmcPlc(cli.cfgFile, cli.templatedir)
    plc.create()
    plc.make()
    plc.plcTemplate.writeProduct(cli.outFile)


if __name__ == '__main__':
    main()
