import argparse


def getArgs():
    # Construct the argument parser
    ap = argparse.ArgumentParser()

    # Add the arguments to the parser
    ap.add_argument("-d", "--tmpdir", required=False, default='./',
                    help="Directory for temporary storage. Optional, defaults to ${PWD}")
    ap.add_argument("-t", "--template", required=True,
                    help="Jinja2 template")
    ap.add_argument("-D", "--data", required=True,
                    help="File containing the data/configuration.")
    ap.add_argument("-o", "--outfile", required=False, default='ecmc.plc',
                    help="File to use for output. Optional, defaults to stdout")
    return vars(ap.parse_args())
