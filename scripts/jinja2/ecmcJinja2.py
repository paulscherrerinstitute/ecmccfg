import argparse
import pathlib
import os
import textwrap

import jinja2

class JinjaCli:
    def __init__(self):
        args = self.getArgs()
        self.tmpDir = pathlib.Path(args.tmpdir)
        self.cfgFile = pathlib.Path(args.data)
        self.template = args.template
        self.templatedir = args.templatedir
        self.outFile = pathlib.Path(self.tmpDir, args.outfile)
        self.prodId = self.getProdId(args)
        self.hwDb = pathlib.Path(args.hardwaredb) if args.hardwaredb else None
        pathlib.Path(self.outFile).parent.mkdir(parents=True, exist_ok=True)  # make sure the output path exists

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
        ap.add_argument("-i", "--id", required=False,
                        help=f"This parameter only takes effect for hardware (slave). Product ID as reported by "
                             "`ethercat slaves -v | grep \"Product code:\" | awk -F: '{ gsub(/ /,""); print $2 }'`"
                             " if not specified, the script will obtain the ID from the environment ${"
                             "ECMC_EC_PRODUCT_ID}.")
        ap.add_argument("-H", "--hardwaredb", required=False,
                        help="hardware database to use.")
        return ap.parse_args()

    @staticmethod
    def getFromArg(args) -> int:
        try:
            return int(args.id, 0)
        except:
            raise

    @staticmethod
    def getFromEnv(var) -> int:
        try:
            return int(os.environ[var], 0)
        except KeyError as err:
            return -1

    @classmethod
    def getProdId(cls, args) -> int:
        if args.id is None:
            return cls.getFromEnv("ECMC_EC_PRODUCT_ID")
        return cls.getFromArg(args)


class JinjaTemplate:
    def __init__(self, directory, templateFile=None):
        self.template = None
        self.product = ""
        self.env = jinja2.Environment(loader=jinja2.FileSystemLoader([str(directory),'/tmp']))
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

    def lstrip(self):
        """
        remove leading whitespaces from all lines to allow indented templates
        https://stackoverflow.com/questions/31218253/trim-whitespace-from-multiple-lines
        """
        self.product = '\n'.join([line.strip() for line in self.product.splitlines()])
        return self.product

    def writeProduct(self, filename):
        with open(filename, "w") as f:
            f.writelines(self.product)

    def showProduct(self):
        print(self.product)

