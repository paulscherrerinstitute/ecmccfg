#! /usr/bin/env python

import argparse
import yaml
import json

import subprocess

def process_index(index, subindeces, master=0, slave=0) -> list:
    root_cmd = f'ethercat -m{master} -p{slave} upload {index:#x}'
    results = []
    for subindexDict in subindeces:
        for subindex, value in subindexDict.items():
            data_type = value.get('type')
            description = f'{subindex:#04x}: {value.get("desc", "")}'
            cmd = f'{root_cmd} {subindex:#x} -t{data_type}'
            result = subprocess.run(cmd.split(), stdout=subprocess.PIPE, text=True)
            results.append(f'{description} = {result.stdout}')
    return results

# Create the parser
parser = argparse.ArgumentParser(description='Read a dictionary from a file.')

# Add arguments
parser.add_argument('-y', '--yaml', type=str, help='YAML file to read')
parser.add_argument('-j', '--json', type=str, help='JSON file to read')
parser.add_argument('-m', '--master', type=int, default=0)
parser.add_argument('-p', '--position', type=int, default=1)

# Parse the arguments
args = parser.parse_args()

# Function to read and process the data
def read_and_process(file_path):
    with open(file_path, 'r') as file:
        if file_path.endswith('.yaml'):
            data = yaml.safe_load(file)
        elif file_path.endswith('.json'):
            data = json.load(file)
        else:
            raise ValueError('Unsupported file type')

    for index, subindeces in data.items():
        print(f'INDEX ==== {index:#x} ====')
        for response in process_index(index, subindeces, args.master, args.position):
            print(response.strip())

# Call the function with the respective file path
if args.yaml:
    read_and_process(args.yaml)
elif args.json:
    read_and_process(args.json)
else:
    parser.print_help()
