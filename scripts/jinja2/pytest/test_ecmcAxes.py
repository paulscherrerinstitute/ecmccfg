import pytest
import re
from ecmcAxes import EcmcAxis

base_path = 'scripts/jinja2/'
templates_path = f'{base_path}templates/'
yaml_path = f'{base_path}pytest/yaml_files/'
ref_path = f'{base_path}pytest/reference_files/'


@pytest.fixture
def myAxis():
    return EcmcAxis(f'{yaml_path}joint.yaml', f'{templates_path}')


@pytest.mark.dependency()
def test_create(myAxis):
    myAxis.create()
    assert myAxis.config.axisType is 1
    myAxis.axisconfig = f'{yaml_path}endEffector.yaml'
    myAxis.create()
    assert myAxis.config.axisType is 2
    with pytest.raises(NotImplementedError):
        myAxis.axisconfig = f'{yaml_path}axisTypeNotImplementedError.yaml'
        myAxis.create()

    with pytest.raises(FileNotFoundError):
        newAxis = EcmcAxis(f'{yaml_path}joint.yaml', '../notADir/')
        newAxis = EcmcAxis(f'{yaml_path}notAFile.yaml', f'{templates_path}')


@pytest.mark.dependency(depends=["test_create"])
def test_set_axis_template(myAxis):
    myAxis.create()
    assert myAxis.config.axisType is 1
    with pytest.raises(KeyError):
        myAxis.config.setAxisTemplate(-1)  # load 'debug.jinja2'
    myAxis.config.setAxisTemplate(0)  # load 'debug.jinja2'
    assert myAxis.config.hasVariables
    ''' render w/o var '''
    myAxis.config.render(myAxis.yamlData)
    assert myAxis.config.product.strip() == "# var(foo) -> {{ var.bar }} {% for line in var.baz %} {{ line }}, {% endfor %}"
    ''' pre-render as new template '''
    myAxis.config.setTemplate(myAxis.config.render(myAxis.yamlData))
    ''' render 2nd time with pre-rendered template '''
    myAxis.config.render(myAxis.yamlData)
    assert myAxis.config.product.strip() == "# var(foo) -> 3.14  1,  2,  3,  None,"


@pytest.mark.dependency(depends=["test_create"])
def test_render_vs_bechmark(myAxis):
    myAxis.axisconfig = f'{yaml_path}joint_benchmark.yaml'
    myAxis.create()
    myAxis.config.render(myAxis.yamlData)
    with open(f'{ref_path}joint.benchmark') as fp:
        lines = fp.readlines()
        for line in lines:
            if 'Cfg.LinkEcEntryToObject(,' in line:
                continue
            cmd = re.search(r"\bCfg.\w+", line).group()
            assert cmd in myAxis.config.product
