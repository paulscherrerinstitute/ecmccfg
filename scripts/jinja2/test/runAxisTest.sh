#! /usr/bin/env bash
. ../venv/bin/activate
python ../axisYamlJinja2.py -d ./ -o output/axis1.axis -T ../ -t axis.jinja2 -D testAxis.yaml