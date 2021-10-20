#! /usr/bin/env bash
. ../venv/bin/activate
# python ../axisYamlJinja2.py -d ./ -o output/j.axis -T ../templates -D testJoint.yaml
python ../axisYamlJinja2.py -d ./ -o output/j.axis -T ../templates -D AM8111_CSV_vars.yaml
