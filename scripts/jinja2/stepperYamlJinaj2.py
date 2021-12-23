import yaml

import ecmcYamlHandler
from ecmcJinja2 import JinjaTemplate
from ecmcJinja2 import JinjaCli

'''
call
python stepperYamlJinaj2.py -T templates -t Ex70xx.jinja2 -D pytest/yaml_files/stepper.yaml -H ../../hardware/Beckhoff_7XXX/Ex70xx.yaml -o test.motor -i 0x1b7d3052
'''

if __name__ == '__main__':

    cli = JinjaCli()

    t = JinjaTemplate(cli.templatedir, cli.template)

    stepperDb = ecmcYamlHandler.YamlHandler()
    stepperDb.loadYamlData(cli.hwDb)

    prod_id = cli.prodId

    if prod_id not in stepperDb.yamlData:
        msg = f'this slave >> 0x{prod_id:08x} << is not supported yet.'
        raise NotImplementedError(msg)

    with open(cli.cfgFile) as f:
        motorData = yaml.load(f, Loader=yaml.FullLoader)

    # render the template with merged motor and data and stepper db. The latter provides the scaling for the voltage.
    t.render({**motorData, **stepperDb.yamlData[prod_id]})
    # t.show()
    t.write(cli.outFile)
