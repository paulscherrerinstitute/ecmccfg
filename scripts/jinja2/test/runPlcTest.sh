#! /usr/bin/env bash
. ../venv/bin/activate
# python ../plcYamlJinja2.py -d ./ -o output/plc2.plc -T ../ -t plc.jinja2 -D plc2File.yaml
python ../plcYamlJinja2.py -d ./ -o output/plc2.plc -T ../ -D plc2File.yaml
