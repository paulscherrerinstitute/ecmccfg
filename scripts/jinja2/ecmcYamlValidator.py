#! /usr/bin/env python

import yaml
import argparse

import ecmcConfigValidator

if __name__ == '__main__':
    ap = argparse.ArgumentParser()

    # Add the arguments to the parser
    ap.add_argument('file', help='file to validate')
    ap.add_argument("-t", "--type", required=False, default='axis',
                    help="type to validate (i.e. 'axis')")
    ap.add_argument("-o", "--output", required=False, default=None,
                    help="output file, defaults to STDOUT")
    ap.add_argument("-f", "--format", required=False, default='yaml',
                    help="output format [yaml|json]")
    ap.add_argument("-s", "--strict", action='store_true', default=False,
                    help="strict validation (raise on error)")

    args = ap.parse_args()

    with open(args.file) as f:
        doc = yaml.load(f, Loader=yaml.FullLoader)
    v = ecmcConfigValidator.ConfigValidator(doc)

    v.validated.data = v.validate_axis(strict=args.strict)
    v.write(args.output, format=args.format)
