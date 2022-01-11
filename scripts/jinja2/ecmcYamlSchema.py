supportedAxisTypes = {
    '0': 0,
    'debug': 0,
    '1': 1,
    'j': 1,
    'joint': 1,
    'physical': 1,
    'motor': 1,
    'real': 1,
    '2': 2,
    'e': 2,
    'ee': 2,
    'end_effector': 2,
    'endeffector': 2,
    'virtual': 2,
}


class Schema:
    def __init__(self):
        self.axisSchemaDict = {
            0: None,
            1: ['var',
                'axis',
                'epics',
                'encoder',
                'drive',
                'controller'],
            2: ['var',
                'axis',
                'epics',
                'encoder']
        }

    @staticmethod
    def get_schema(keys):
        _type = type(keys)
        if _type is list:
            return {key: grandSchema[key] for key in keys}
        elif _type is str:
            return {keys: grandSchema[keys]}
        else:
            raise NotImplementedError(f'unsupported input type >>{_type}<<')


axisSchema = {
    'type': 'dict',
    'required': True,
    'schema': {
        'id': {'required': True, 'type': 'integer', 'min': 1},
        'type': {'type': 'integer', 'default': 'joint', 'coerce': lambda v: supportedAxisTypes[str(v).lower()]},
        'mode': {'type': 'string', 'default': 'CSV', 'coerce': lambda v: v.upper()},
        'parameters': {'type': 'string'}
    }
}

epicsSchema = {
    'type': 'dict',
    'required': False,
    'schema': {
        'name': {'default': 'axis'},
        'precision': {'type': 'integer', 'default': 3},
        'unit': {'type': 'string', 'default': 'mm'},
        'motorRecord': {
            'type': 'dict',
            'default': {'enable': True},
            'schema': {
                'enable': {'type': 'boolean', 'default': True},
                'fieldInit': {'type': 'string'},
                'description': {'type': 'string'}
            }
        }
    }
}

encoderSchema = {
    'type': 'dict',
    'required': True,
    'schema': {
        'numerator': {'type': 'float', 'default': 0},
        'denominator': {'type': 'integer', 'default': 1, 'min': 1},
        'type': {'type': 'integer', 'default': 0, 'allowed': [0, 1]},
        'bits': {'type': 'integer', 'min': 0},
        'absBits': {'type': 'integer', 'min': 0},
        'absOffset': {'type': 'float', 'default': 0},
        'position': {'type': 'string'},
        'control': {'type': 'string'},
        'status': {'type': 'string'},
        'reset': {'type': 'integer', 'min': 0},
        'warning': {'type': 'integer', 'min': 0},
        'error': {'type': 'list', 'maxlength': 3},
        'velocityFilterSize': {'type': 'integer', 'default': 100, 'min': 0},
        'positionFilterSize': {'type': 'integer', 'default': 1, 'min': 0},
        'positionFilterEnable': {'type': 'boolean', 'default': False},
        'latch': {
            'type': 'dict',
            'schema': {
                'position': {'type': 'float', 'default': 0},
                'control': {'type': 'string'},
                'status': {'type': 'string'},
            }
        }
    }
}

driveSchema = {
    'type': 'dict',
    'required': True,
    'schema': {
        'numerator': {'type': 'float', 'default': 0},
        'denominator': {'type': 'integer', 'default': 1, 'min': 1},
        'type': {'type': 'integer', 'default': 0, 'allowed': [0, 1]},
        'reduceTorque': {'type': 'integer', 'min': 0},
        'setpoint': {'type': 'string'},
        'control': {'type': 'string'},
        'status': {'type': 'string'},
        'brake': {
            'type': 'dict',
            'schema': {
                'openDelay': {'type': 'integer', 'default': 0, 'min': 0},
                'closeAhead': {'type': 'integer', 'default': 0, 'min': 0}
            }
        },
        'reset': {'type': 'integer', 'min': 0},
        'warning': {'type': 'integer', 'min': 0},
        'error': {'type': 'list', 'maxlength': 3}
    }
}

controllerSchema = {
    'type': 'dict',
    'required': False,
    'default': {'controller': {'Kp': 1}},
    'schema': {
        'Kp': {'type': 'float', 'default': 1, 'min': 0},
        'Ki': {'type': 'float', 'default': 0, 'min': 0},
        'Kd': {'type': 'float', 'default': 0, 'min': 0},
        'Kff': {'type': 'float', 'default': 1, 'min': 0},
    }
}

varSchema = {
    'type': 'dict',
    'required': False
}

grandSchema = {
    'var': varSchema,
    'axis': axisSchema,
    'epics': epicsSchema,
    'encoder': encoderSchema,
    'drive': driveSchema,
    'controller': controllerSchema,
}
