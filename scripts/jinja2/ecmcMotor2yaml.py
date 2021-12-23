import yaml
import pathlib
import re

import argparse

'''
script to convert existing ecmc iocsh stepper motor drive config files to yaml
Disclaimer: This ain't perfect. It's quick-n-dirty and untestable.
It's written to convert the majority, not the most special configs :)
'''

yamlData = {}
yamlData['current'] = {'run': 0}

stepperDict = {
    1: 'run',
    2: 'hold',
    3: 'voltage',
    4: 'resistance',
    6: 'steps',
    10: 'inductance'
}


def getPair(line):
    d = line.split(',')
    return int(d[2], 0), int(d[3])


def isStepperDrive(fname):
    '''
    https://regex101.com/
    ecmcE matches the characters ecmcE literally (case sensitive)
    \D matches any character that's not a digit (equivalent to [^0-9])
    {1,2} matches the previous token between 1 and 2 times, as many times as possible, giving back as needed (greedy)
    70 matches the characters 70 literally (case sensitive)
    \d matches a digit (equivalent to [0-9])
    {1} matches the previous token exactly one time (meaningless quantifier)
    1st Capturing Group (1|7)
    1st Alternative 1
    1 matches the character 1 with index 4910 (3116 or 618) literally (case sensitive)
    2nd Alternative 7
    7 matches the character 7 with index 5510 (3716 or 678) literally (case sensitive)
    '''
    match = re.search(r'^ecmcE\D{1,2}70\d{1}(1|7)', fname.stem)
    if match:
        return True
    return False


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('file', nargs='+')
    args = parser.parse_args()

    for f in args.file:
        fname = pathlib.Path(f)
        if not isStepperDrive(fname):
            continue

        with open(fname) as f:
            lines = f.read().splitlines()

        for line in lines:
            if len(line) == 0: continue
            if line[0] == '#': continue
            if not re.search(r'.*EcAddSdo.*', line):
                continue
            try:
                idx, val = getPair(line)
            except ValueError as err:
                print(f'Error: failed to convert {fname}:\n'
                      f'{line}\n'
                      f'{err}')
                break
            try:
                if idx < 3:
                    yamlData['current'][stepperDict[idx]] = val
                else:
                    yamlData[stepperDict[idx]] = val
            except KeyError as err:
                raise err

        outFile = fname.stem.split('-Motor-')[1]
        outFile = f'{outFile}.yaml'

        try:
            with open(outFile, "w") as f:
                f.writelines(yaml.dump(yamlData))
        except:
            raise
