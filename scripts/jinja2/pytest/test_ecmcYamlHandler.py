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
    with pytest.raises(ValueError):
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
    with pytest.raises(ValueError):
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
    # h = YamlHandler()
    # data = """
    #     axis:
    #         type: joint
    #     sync:
    #         enable: 1
    # """
    # h.yamlData = data
    # myHandler.yamlData = {'axis': {'type': 'joint'}, 'sync': {'enable': 'true'}}
    myHandler.yamlData = test_input
    assert myHandler.checkForSyncPlc() is expected


@pytest.mark.parametrize("test_input", ['j', 42, float(3.14)])
def test_get_key(myHandler, test_input):
    myHandler.yamlData = {'axis': {'type': test_input}, 'sync': {'enable': 'true'}}
    assert myHandler.getKey(['axis', 'type'], myHandler.yamlData) == test_input
    # with pytest.raises(ValueError):
    #     myHandler.getKey()


@pytest.mark.parametrize("test_input,expected", [(1, True), (0, False), ("true", True), ("false", False)])
def test_str2bool(myHandler, test_input, expected):
    assert myHandler.str2bool(test_input) is expected
    with pytest.raises(ValueError):
        myHandler.str2bool('ja')
        myHandler.str2bool('Nej')
