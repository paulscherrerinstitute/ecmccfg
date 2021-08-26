import argparse
from pathlib import Path
import jinja2


class JinjaCli:
    def __init__(self):
        args = self.getArgs()
        self.tmpDir = Path(args.tmpdir)
        self.cfgFile = Path(args.data)
        self.template = args.template
        self.templatedir = args.templatedir
        self.outFile = Path(self.tmpDir, args.outfile)
        Path(self.outFile).parent.mkdir(parents=True, exist_ok=True)  # make sure the output path exists

    @staticmethod
    def getArgs():
        # Construct the argument parser
        ap = argparse.ArgumentParser()

        # Add the arguments to the parser
        ap.add_argument("-d", "--tmpdir", required=False, default='./',
                        help="Directory for temporary storage. Optional, defaults to ${PWD}")
        ap.add_argument("-T", "--templatedir", required=False, default='./',
                        help="Jinja2 template directory. Optional, defaults to ${PWD}")
        ap.add_argument("-t", "--template", required=False, default=None,
                        help="Jinja2 template")
        ap.add_argument("-D", "--data", required=True,
                        help="File containing the data/configuration.")
        ap.add_argument("-o", "--outfile", required=False, default='ecmcScriptFromYaml.txt',
                        help="File to use for output. Optional, defaults to stdout")
        return ap.parse_args()


class JinjaTemplate:
    def __init__(self, directory, templateFile=None):
        self.template = None
        self.product = None
        self.env = jinja2.Environment(loader=jinja2.FileSystemLoader(str(directory)))
        if templateFile is not None:
            self.read(templateFile)

    def read(self, filename):
        self.template = self.env.get_template(str(filename))
        return self.template

    def setTemplate(self, template):
        self.template = jinja2.Template(template)

    def render(self, data):
        self.product = self.template.render(data)
        return self.product

    def write(self, filename):
        with open(filename, "w") as f:
            f.writelines(self.product)

    def show(self):
        print(self.product)
