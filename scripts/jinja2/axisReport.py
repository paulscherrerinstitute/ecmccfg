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

    axis.yamlHandler.yamlData['yamlFile'] = cli.cfgFile
    # axis.yamlHandler.yamlData['author'] = "Dr. Niko Kivel"
    # axis.yamlHandler.yamlData['date'] = datetime.datetime.today().isoformat("|")

    axis.axisTemplate.read("axisReport_main.tex")
    axis.axisTemplate.render(axis.yamlHandler.yamlData)
    axis.axisTemplate.writeProduct(cli.outFile)

    output_file = pathlib.Path.joinpath(cli.tmpDir, cli.cfgFile)
    output_file.parent.mkdir(exist_ok=True, parents=True)
    output_file.write_text(yaml.dump(axis.yamlHandler.yamlData))
    # axis.v.validated.write(output_file)

    print(f'output written to: {cli.outFile}')
    print(f'to compile the LaTeX output run:\n'
          f'docker run -v {cli.tmpDir}:/doc/ -t -i thomasweise/texlive pdflatex {cli.outFile.relative_to(cli.tmpDir)}')


if __name__ == '__main__':
    main()
