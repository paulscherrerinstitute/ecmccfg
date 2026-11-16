#!/usr/bin/env python3
"""Static YAML/template contract for soft-limit restore and synchronization."""
from pathlib import Path
from jinja2 import Environment

root = Path(__file__).resolve().parents[1]
source = (root / 'scripts/jinja2/templates/epicsMotorRecord.jinja2').read_text()
start = source.index('#-  Default to sync softlimits')
end = source.index('epicsEnvUnset(ECMC_AXIS_FLAGS)', start)
template = Environment().from_string(source[start:end])

for restore, sync, mode in (
        (False, False, 0), (False, True, 0),
        (True, False, 2), (True, True, 1)):
    rendered = template.render(
        epics={'motorRecord': {'restoreSoftLimits': restore,
                               'syncSoftLimits': sync}},
        axis={'parameters': ''}, axisFlags=0)
    assert f'syncSoftLims={int(sync)};' in rendered
    assert f'restoreMotorSoftLims={mode};' in rendered

# Advanced legacy parameters occur last and can deliberately override YAML.
rendered = template.render(
    epics={'motorRecord': {'restoreSoftLimits': True, 'syncSoftLimits': False}},
    axis={'parameters': 'restoreMotorSoftLims=1;'}, axisFlags=0)
assert rendered.index('restoreMotorSoftLims=2;') < rendered.index('restoreMotorSoftLims=1;')

schema = (root / 'scripts/jinja2/ecmcYamlSchema.py').read_text()
assert "'restoreSoftLimits': {'type': 'boolean', 'default': False}" in schema
print('Motor soft-limit restore modes: all four YAML combinations and legacy override passed.')
