import re
import yaml
from jinja2 import Template
import sys
import os
import argparse

# Construct the argument parser
ap = argparse.ArgumentParser()

# Add the arguments to the parser
ap.add_argument("-d", "--tmpdir", required=False,
   help="Directory for temporary storage. Optional, defaults to ${PWD}")
ap.add_argument("-t", "--template", required=True,
   help="Jinja2 template")
ap.add_argument("-D", "--data", required=True,
   help="File containing the data/configuration.")
ap.add_argument("-o", "--outfile", required=True,
   help="File to use for output.")
args = vars(ap.parse_args())

# if no tmp dir was provided, use ${PWD}
if args['tmpdir'] is None:
    args['tmpdir'] = './'

# rest of the arguments
plcConfig = args['data']
jinja2Template = args['template']
PlcFile = args['outfile']

'''
- load PLC from file
- strip empty lines and those starting with '#'
- replace ';' with '|' for `Cfg.AppendPLCExpr()`
- returns the code as an array
'''
def loadPlcFile(fileName):
    code=[]
    with open(fileName, "r") as f:
        for line in f:
            line = line.strip()
            if len(line)==0:
                continue
            x = re.findall("^#.*", line)
            if x:
                continue
            line = line.replace(";","|")
            code.append(line)
    return code

# open yaml file containing the PLC configuration
with open(plcConfig) as f:
    data = yaml.load(f, Loader=yaml.FullLoader)

# if the config contains a 'file', load the file and replace all 'plc.code'
if 'file' in data['plc'] and data['plc']['file'] is not None:
    data['plc']['code'] = loadPlcFile(data['plc']['file'])

# load the jinja2 template
template = Template(open(jinja2Template).read())

# if 'macros' are specified, run the template renderer twice
if 'var' in data:
    template = Template(template.render(data))

# render the template and write to 'outfile' in 'tmpdir'
with open(os.path.join(args['tmpdir'], args['outfile']), "w") as f:
    for line in template.render(data):
        f.write(line)
    f.close()
