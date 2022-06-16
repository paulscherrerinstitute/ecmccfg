#! /usr/bin/env bash
. ../venv/bin/activate
python ../axisYamlJinja2.py -d ./ -o output/ee1.axis -T ../templates -D testEndEffector.yaml
