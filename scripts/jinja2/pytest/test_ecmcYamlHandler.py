import pytest
from ecmcYamlHandler import YamlHandler


@pytest.fixture
def myHandler():
    return YamlHandler()


@pytest.mark.dependency()
def test_is_supported_axis_type(myHandler):
    with pytest.raises(NotImplementedError):
        " not implemented _string_"
        myHandler.isSupportedAxisType('NotImplementedError')
        " not implemented _int_"
        myHandler.isSupportedAxisType(1024)
        " not implemented _double_"
        myHandler.isSupportedAxisType(3.14)
    ''' test for integer cast 0..2'''
    for key in range(3):
        assert myHandler.isSupportedAxisType(key) is True


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
def test_set_ecmc_axis_type(myHandler):
    with pytest.raises(TypeError):
        myHandler.setEcmcAxisType()
    for key, value in myHandler.supportedAxisTypes.items():
        myHandler.setEcmcAxisType(key)
        assert myHandler.axisType == value


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

@pytest.mark.parametrize("test_input,expected", [
    ('0', True),
    ('debug', True),
    ('1', True),
    ('j', True),
    ('joint', True),
    ('  J o I n  T  ', True),
    ('physical', True),
    ('motor', True),
    ('real', True),
    ('2', True),
    ('e', True),
    ('ee', True),
    ('end_effector', True),
    ('endeffector', True),
    ('virtual', True)
])
def test_is_supported_axis_type(myHandler, test_input, expected):
    assert myHandler.isSupportedAxisType(test_input) is expected
    with pytest.raises(NotImplementedError):
        myHandler.isSupportedAxisType()
