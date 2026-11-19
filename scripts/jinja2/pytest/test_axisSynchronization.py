import pathlib
import sys


base_path = pathlib.Path(__file__).parents[1]
sys.path.append(str(base_path))

from ecmcJinja2 import JinjaTemplate


def render(plc):
    template = JinjaTemplate(base_path / 'templates', 'axisSynchronization.jinja2')
    return template.render({
        'plc': plc,
        'encoder': {},
        'trajectory': {},
    })


def test_no_filter_configuration_uses_silent_defaults():
    output = render({'enable': False})

    assert 'Cfg.SetAxisPLCEncVelFilterSize(${ECMC_AXIS_NO}, 1)' in output
    assert 'Cfg.SetAxisPLCEncVelFilterEnable(${ECMC_AXIS_NO}, 0)' in output
    assert 'Cfg.SetAxisPLCTrajVelFilterSize(${ECMC_AXIS_NO}, 1)' in output
    assert 'Cfg.SetAxisPLCTrajVelFilterEnable(${ECMC_AXIS_NO}, 0)' in output
    assert 'ecmcLogBufferWrite("WARNING"' not in output


def test_new_filter_configuration_does_not_warn():
    output = render({
        'enable': True,
        'velocity_filter': {
            'encoder': {'size': 7, 'enable': True},
            'trajectory': {'size': 9, 'enable': True},
        },
    })

    assert 'Cfg.SetAxisPLCEncVelFilterSize(${ECMC_AXIS_NO},7)' in output
    assert 'Cfg.SetAxisPLCEncVelFilterEnable(${ECMC_AXIS_NO},1)' in output
    assert 'Cfg.SetAxisPLCTrajVelFilterSize(${ECMC_AXIS_NO},9)' in output
    assert 'Cfg.SetAxisPLCTrajVelFilterEnable(${ECMC_AXIS_NO},1)' in output
    assert 'ecmcLogBufferWrite("WARNING"' not in output


def test_legacy_filter_configuration_is_preserved_and_warns():
    output = render({
        'enable': True,
        'filter': {
            'velocity': {'size': 3, 'enable': True},
            'position': {'size': 5, 'enable': True},
        },
    })

    assert 'Cfg.SetAxisPLCEncVelFilterSize(${ECMC_AXIS_NO},3)' in output
    assert 'Cfg.SetAxisPLCEncVelFilterEnable(${ECMC_AXIS_NO},1)' in output
    assert 'Cfg.SetAxisPLCTrajVelFilterSize(${ECMC_AXIS_NO},5)' in output
    assert 'Cfg.SetAxisPLCTrajVelFilterEnable(${ECMC_AXIS_NO},1)' in output
    assert output.count('ecmcLogBufferWrite("WARNING"') == 2


def test_legacy_trajectory_alias_is_preserved_and_warns():
    output = render({
        'enable': True,
        'filter': {'trajectory': {'size': 6, 'enable': True}},
    })

    assert 'Cfg.SetAxisPLCTrajVelFilterSize(${ECMC_AXIS_NO},6)' in output
    assert 'Cfg.SetAxisPLCTrajVelFilterEnable(${ECMC_AXIS_NO},1)' in output
    assert output.count('ecmcLogBufferWrite("WARNING"') == 1
