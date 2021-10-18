import pytest
from ecmcYamlHandler import YamlHandler


@pytest.fixture
def myHandler():
    return YamlHandler()


@pytest.mark.dependency()
@pytest.mark.parametrize("test_input,expected", [
    (0, '0'),
    ('0', '0'),
    ('debug', 'debug'),
    (1, '1'),
    ('1', '1'),
    ('j', 'j'),
    ('joint', 'joint'),
    ('  J o I n  T  ', 'joint'),
    ('physical', 'physical'),
    ('motor', 'motor'),
    ('real', 'real'),
    (2, '2'),
    ('2', '2'),
    ('e', 'e'),
    ('ee', 'ee'),
    ('end_effector', 'end_effector'),
    ('endeffector', 'endeffector'),
    ('virtual', 'virtual')
])
def test_is_supported_axis_type(myHandler, test_input, expected):
    assert myHandler.isSupportedAxisType(test_input) == expected
    with pytest.raises(NotImplementedError):
        myHandler.isSupportedAxisType()
    with pytest.raises(NotImplementedError):
        " empty call"
        myHandler.isSupportedAxisType()
        " not implemented _string_"
        myHandler.isSupportedAxisType('NotImplementedError')
        " not implemented _int_"
        myHandler.isSupportedAxisType(1024)
        " not implemented _double_"
        myHandler.isSupportedAxisType(3.14)


@pytest.mark.dependency()
def test_check_for_key(myHandler):
    with pytest.raises(TypeError):
        myHandler.checkForKey('dummy')
    assert myHandler.checkForKey('dummy', data_={'dummy': 0}) is True
    assert myHandler.checkForKey('notDummy', data_={'dummy': 0}, optional=True) is False
    with pytest.raises(KeyError):
        myHandler.checkForKey('notDummy', data_={'dummy': 0})
    myHandler.yamlData = {'axis': {'type': 'joint'}, 'sync': {'enable': 'true'}}
    assert myHandler.getKey(['axis', 'type'], myHandler.yamlData) == 'joint'
    assert myHandler.checkForKey(['axis', 'type']) is True


@pytest.mark.dependency(depends=["test_check_for_key"])
def test_load_yaml_data(myHandler):
    with pytest.raises(FileNotFoundError) as e_info:
        myHandler.loadYamlData('fileNotFound.error')
    assert myHandler.yamlData is None
    myHandler.loadYamlData('../test/yamlHandlerTest.yaml')
    assert myHandler.yamlData is not None
    assert myHandler.checkForKey('yaml') is True


@pytest.mark.dependency(depends=["test_check_for_key", "test_is_supported_axis_type"])
@pytest.mark.parametrize("test_input,expected", [(' d E b U g ', 0), ('joint', 1), ('e', 2)])
def test_set_ecmc_axis_type(myHandler, test_input, expected):
    with pytest.raises(TypeError):
        myHandler.setEcmcAxisType()
    myHandler.setEcmcAxisType(test_input)
    assert myHandler.axisType == expected
    # for key, value in myHandler.supportedAxisTypes.items():
    #     myHandler.setEcmcAxisType(key)
    #     assert myHandler.axisType == value


@pytest.mark.parametrize("test_input,expected", [
    ({'axis': {'type': 'joint'}, 'sync': {'enable': 'true'}}, True),
    ({'axis': {'type': 'joint'}, 'sync': {'enable': 'false'}}, False),
    ({'axis': {'type': 'joint'}}, False),
])
def test_check_for_sync_plc(myHandler, test_input, expected):
    myHandler.yamlData = test_input
    assert myHandler.checkForSyncPlc() is expected


@pytest.mark.parametrize("test_input", ['j', 42, float(3.14)])
def test_get_key(myHandler, test_input):
    myHandler.yamlData = {'axis': {'type': test_input}, 'sync': {'enable': 'true'}}
    assert myHandler.getKey(['axis', 'type'], myHandler.yamlData) == test_input


@pytest.mark.parametrize("test_input,expected", [(1, True), (0, False), ("true", True), ("false", False)])
def test_str2bool(myHandler, test_input, expected):
    assert myHandler.str2bool(test_input) is expected
    with pytest.raises(ValueError):
        myHandler.str2bool('ja')
    with pytest.raises(ValueError):
        myHandler.str2bool('Nej')


def test_check_for_plc_file(myHandler):
    '''
        plc:
          id: 2
          enable: yes
          rateMilliseconds: 1000
          file: test/plc2.plc
    '''
    # This will fail for now, has to be fixed
    # myHandler.checkForPlcFile()
    assert myHandler.hasPlcFile is False
    myHandler.yamlData = {'plc': {'file': 'plc/empty.plc'}}
    myHandler.checkForPlcFile()
    assert myHandler.hasPlcFile is True


@pytest.mark.parametrize("test_input,expected", [(' d E b U g ', 0), ('joint', 1), ('e', 2)])
@pytest.mark.dependency(depends=["test_is_supported_axis_type"])
def test_get_axis_type(myHandler, test_input, expected):
    ''' direct call '''
    assert myHandler.getAxisType(test_input) is expected
    ''' call via yamlData '''
    myHandler.yamlData = {'axis': {'type': test_input}}
    assert myHandler.getAxisType() is expected

def test_load_yaml_data(myHandler):
    with pytest.raises(TypeError):
        myHandler.loadYamlData()
    with pytest.raises(FileNotFoundError):
        myHandler.loadYamlData('yaml_files/fileNotFound.yaml')
    myHandler.loadYamlData('yaml_files/joint.yaml')
    assert myHandler.yamlData['axis']['type'] == 'joint'
