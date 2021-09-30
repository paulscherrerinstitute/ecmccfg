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
    assert myHandler.checkForKey('dummy', data_="{dummy: 0}") is True
    assert myHandler.checkForKey('notDummy', data_="{dummy: 0}", optional=True) is False
    with pytest.raises(KeyError):
        myHandler.checkForKey('notDummy', data_="{dummy: 0}")

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
    with pytest.raises(ValueError) as e_info:
        myHandler.setEcmcAxisType()
    for key, value in myHandler.supportedAxisTypes.items():
        myHandler.setEcmcAxisType(key)
        assert myHandler.axisType == value
