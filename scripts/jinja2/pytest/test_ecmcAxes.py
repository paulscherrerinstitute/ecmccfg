import pytest
import re
from ecmcAxes import EcmcAxis

base_path = 'scripts/jinja2/'
templates_path = f'{base_path}templates/'
yaml_path = f'{base_path}pytest/yaml_files/'
ref_path = f'{base_path}pytest/reference_files/'

@pytest.mark.dependency()
def test_init():
    with pytest.raises(TypeError):
        " no argument "
        axis = EcmcAxis()
        " config only "
        axis = EcmcAxis(f'{yaml_path}joint.yaml1')
    with pytest.raises(FileNotFoundError):
        " config file not found "
        axis = EcmcAxis(f'{yaml_path}FileNotFound.yaml', f'{templates_path}')
        " config file not found "
        axis = EcmcAxis(f'{yaml_path}joint.yaml', f'{templates_path}foobar')

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


def getArgs(line):
    arg = re.search(r"\b\(.*\)", line).group()
    args = arg.translate({ord(c): None for c in '()" '}).split(',')
    for i, v in enumerate(args):
        try:
            args[i] = float(v) if '.' in v else int(v)
        except:
            continue
    return args

@pytest.mark.dependency(depends=["test_create"])
def test_render_vs_bechmark(myAxis):
    myAxis.axisconfig = f'{yaml_path}joint_benchmark.yaml'
    myAxis.create()
    if myAxis.config.hasVariables:
        myAxis.config.setTemplate(myAxis.config.render(myAxis.config.yamlData))
    myAxis.config.render(myAxis.config.yamlData)
    with open(f'{ref_path}joint.benchmark') as fp:
        lines = fp.readlines()
        for line in lines:
            # skip empty links
            if 'Cfg.LinkEcEntryToObject(,' in line:
                continue
            cmdOrg = re.search(r"\bCfg.\w+", line).group()
            cmd = f'{cmdOrg}\('
            args = getArgs(line)
            if 'Cfg.LinkEcEntryToObject' in cmd:
                cmd = args[1]

            items = re.findall(f"^.*{cmd}.*$", myAxis.config.product, re.MULTILINE)
            iArgs = getArgs(items[0])
            assert cmdOrg in myAxis.config.product
            assert iArgs == args