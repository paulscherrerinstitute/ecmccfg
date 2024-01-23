import ecmcJinja2
import ecmcAxes


def main():
    """
    render axis configuration to `cli.outFile` based on yaml-config `cli.cfgFile`
    The script will lint the input and validate the axis against the configured type
    In case a PLC is defined within the axis config, the PLC will be validated and added to the product.
    """
    cli = ecmcJinja2.JinjaCli()

    axis = ecmcAxes.EcmcAxis(cli.cfgFile, cli.templatedir)
    axis.create()
    axis.make()
    axis.axisTemplate.writeProduct(cli.outFile)

if __name__ == '__main__':
    main()
