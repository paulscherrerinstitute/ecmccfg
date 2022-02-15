import yaml

import ecmcJinja2
import ecmcAxes
import pathlib

import datetime


def main():
    cli = ecmcJinja2.JinjaCli()

    axis = ecmcAxes.EcmcAxis(cli.cfgFile, cli.templatedir)

    axis.create()
    axis.make()

    if axis.hasSyncPLC:
        axis.yamlHandler.yamlData['plc'] = axis.plc.yamlHandler.yamlData['plc']

    axis.yamlHandler.yamlData['yamlFile'] = str(cli.cfgFile)
    # axis.yamlHandler.yamlData['author'] = "Dr. Niko Kivel"
    # axis.yamlHandler.yamlData['date'] = datetime.datetime.today().isoformat("|")

    output_file = pathlib.Path.joinpath(cli.tmpDir, cli.cfgFile)
    output_file.parent.mkdir(exist_ok=True, parents=True)
    output_file.write_text(yaml.dump(axis.yamlHandler.yamlData))

    axis.axisTemplate.read("axisReport_main.tex")
    axis.axisTemplate.render(axis.yamlHandler.yamlData)
    axis.axisTemplate.writeProduct(cli.outFile)

    print(f'output written to: {cli.outFile}')
    print(f'to compile the LaTeX output run:\n'
          f'docker run -v {cli.tmpDir}:/doc/ -t -i thomasweise/texlive pdflatex {cli.outFile.relative_to(cli.tmpDir)}\n'
          f'or use the mighty LaTeX-->PDF webUI docker by, Dr. K')

    if axis.hasSyncPLC:
        # print(axis.plc.yamlHandler.yamlData)
        print(axis.yamlHandler.yamlData['plc'])


if __name__ == '__main__':
    main()
