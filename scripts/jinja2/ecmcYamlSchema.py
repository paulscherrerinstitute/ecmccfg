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
    axisSchemaDict = {
        0: None,
        1: ['var',
            'axis',
            'epics',
            'encoder',
            'drive',
            'controller',
            'trajectory',
            'input',
            'axisPlc',
            'homing',
            'softlimits',
            'monitoring',
            'meta'],
        2: ['var',
            'axis',
            'epics',
            'encoder',
            'trajectory',
            'input',
            'axisPlc',
            'homing',
            'softlimits',
            'monitoring',
            'meta']
    }

    """
    schema for PLCs
    WARNING: The PLC schema _must_ be the FIRST entry of the list!!!
    """
    plcSchemaDict = {
        0: None,
        1: ['plc'],
        2: ['axisPlc', 'axis', 'encoder', 'trajectory', 'var']
    }

    encSchemaDict = {
        0: ['encoder']
    }

    def get_schema(self, keys):
        _type = type(keys)
        if _type is list:
            return {key: self.grandSchema[key] for key in keys}
        elif _type is str:
            return {keys: self.grandSchema[keys]}
        else:
            raise NotImplementedError(f'unsupported input type >>{_type}<<')

    metaSchema = {
        'type': 'dict',
        'default': {},
        'schema': {
            'author': {'type': 'string'},
            'facility': {'type': 'string', 'default': 'SLS 2.0'},
            'device': {'type': 'string'},
            'date': {'type': 'string'},
            'md5': {'type': 'string'},
        }
    }

    plcVeloFilterSchema = {
        'type': 'dict',
        'required': False,
        'default': {},
        'schema': {
            'trajectory': {
                'type': 'dict',                    
                'schema': {
                    'enable': {'required': False, 'type': 'boolean'},
                    'size': {'required': False, 'type': 'integer'}
                }                
            },
            'encoder': {
                'type': 'dict',                    
                'schema': {
                    'enable': {'required': False, 'type': 'boolean'},
                    'size': {'required': False, 'type': 'integer'}
                }                
            }
        }
    }

    filterSchema = {
        'type': 'dict',
        'required': False,
        'default': {},
        'schema': {
            'velocity': {
                'type': 'dict',
                'schema': {
                    'enable': {'required': False, 'type': 'boolean'},
                    'size': {'required': False, 'type': 'integer'}
                }
            },
            'trajectory': {
                'type': 'dict',
                'schema': {
                    'enable': {'required': False, 'type': 'boolean'},
                    'size': {'required': False, 'type': 'integer'}
                }
            },
            'position': {
                'type': 'dict',
                'schema': {
                    'enable': {'required': False, 'type': 'boolean'},
                    'size': {'required': False, 'type': 'integer'}
                }
            }
        }
    }

    homingSchema = {
        'type': 'dict',
        'required': False,
        'schema': {
            'type': {'type': 'integer', 'allowed': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 21, 22, 25, 26]},
            'position': {'oneof': [
                {'type': 'float'},
                {'type': 'string', 'regex': '^\$(\{|\()\w*(=\d*(\.\d*)?)?(\}|\))$'}
            ]
            },
            'postMoveEnable': {'type': 'boolean', 'dependencies': ['postMovePosition']},
            'postMovePosition': {'oneof': [
                {'type': 'float'},
                {'type': 'string', 'regex': '^\$(\{|\()\w*(=\d*(\.\d*)?)?(\}|\))$'}
            ]
            },
            'latchCount': {'type': 'integer', 'min': 0},
            'velocity': {
                'type': 'dict',
                'schema': {
                    'to': {'type': 'float'},
                    'from': {'type': 'float'},
                }
            },
            'acceleration': {'type': 'float'},
            'deceleration': {'type': 'float'},
            'timeout': {'type': 'integer'},
            'refToEncIDAtStartup': {'type': 'integer', 'default': -1},
            'refAtHome': {'type': 'integer', 'default': 0},
            'tolToPrim': {'type': 'float', 'default': 0},
            'trigg': {'type': 'string'},
            'ready': {'type': 'string'},
        }
    }

    axisSchema = {
        'type': 'dict',
        'required': True,
        'schema': {
            'id': {'oneof': [
                {'type': 'integer'},
                {'type': 'string', 'regex': '^\$(\{|\()\w*(=\d*)?(\}|\))$'}
            ]
            },
            'type': {'type': 'integer', 'default': 'joint',
                     'coerce': lambda v: supportedAxisTypes[str(v).lower().replace(" ", "")]},
            'mode': {'type': 'string', 'default': 'CSV', 'allowed': ['CSV', 'CSP'], 'coerce': lambda v: v.upper()},
            'parameters': {'type': 'string'},
            'autoMode': {'type': 'dict', 'schema': {
                'modeSet': {'type': 'string'},
                'modeAct': {'type': 'string'},
                'modeCmdMotion': {'type': 'integer'},
                'modeCmdHome': {'type': 'integer'},
            }},
            'features': {'type': 'dict', 'schema': {
                'disableOnReset': {'type': 'boolean'},
                'alarmAtHardLimits': {'type': 'boolean'},
                'blockCom': {'type': 'boolean'},
                'allowedFunctions': {'type': 'dict', 'schema': {
                    'positioning': {'type': 'boolean'},
                    'constantVelocity': {'type': 'boolean'},
                    'homing': {'type': 'boolean'}
                }}
            }}            
        }
    }

    varSchema = {
        'type': 'dict',
        'required': False
    }

    epicsSchema = {
        'type': 'dict',
        'required': False,
        'default': {'name': 'axis'},
        'schema': {
            'name': {'default': 'axis'},
            'precision': {'type': 'integer', 'min': 0, 'default': 3},
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

    driveSchema = {
        'type': 'dict',
        'required': True,
        'schema': {
            'numerator': {'type': 'float', 'default': 0},
            'denominator': {'type': 'integer', 'default': 1, 'min': 1},
            'type': {'type': 'integer', 'default': 0, 'allowed': [0, 1]},
            'setpoint': {'required': True, 'type': 'string'},
            'control': {'required': True, 'type': 'string'},
            'status': {'type': 'string'},
            'reduceTorqueEnable': {'type': 'boolean', 'dependencies': ['control', 'reduceTorque']},
            'reduceTorque': {'type': 'integer', 'min': 0, 'dependencies': ['control', 'reduceTorqueEnable']},
            'enable': {'type': 'integer', 'min': 0, 'dependencies': ['control']},
            'enabled': {'type': 'integer', 'min': 0, 'dependencies': ['status']},
            'brake': {
                'type': 'dict',
                'schema': {
                    'enable': {'required': True, 'type': 'boolean'},
                    'output': {'required': True, 'type': 'string'},
                    'openDelay': {'type': 'integer', 'min': 0, 'default': 0},
                    'closeAhead': {'type': 'integer', 'min': 0, 'default': 0}
                }
            },
            'warning': {'type': 'integer', 'min': 0, 'dependencies': ['status']},
            'reset': {'type': 'integer', 'min': 0, 'dependencies': ['control']},
            'error': {'type': 'list', 'maxlength': 3, 'schema': {'anyof_type': ['integer', 'string']}, 'dependencies': ['status']},
        }
    }

    encoderSchema = {
        'type': 'dict',
        'required': True,
        'schema': {
            'source': {'type': 'integer', 'allowed': [0, 1], 'default': 0},
            'numerator': {'type': 'float', 'default': 0.},
            'denominator': {'type': 'integer', 'default': 1, 'min': 1},
            'type': {'type': 'integer', 'allowed': [0, 1], 'default': 0},
            'mask': {'type': 'string'},
            'bits': {'type': 'integer', 'min': 0, 'max': 64, 'default': 16},
            'absBits': {'type': 'integer', 'min': 0, 'max': 64, 'default': 25},
            'absOffset': {'oneof': [
                {'type': 'float'},
                {'type': 'string', 'regex': '^\$(\{|\()\w*(=\d*(\.\d*)?)?(\}|\))$'}
                ], 'default': 0.0
            },
            'unit': {'type': 'string'},
            'desc': {'type': 'string'},
            'position': {'required': True, 'type': 'string'},
            'control': {'type': 'string'},
            'status': {'type': 'string'},
            'warning': {'type': 'integer', 'min': 0, 'dependencies': ['status']},
            'ready': {'type': 'integer', 'min': 0, 'dependencies': ['status']},
            'reset': {'type': 'integer', 'min': 0, 'dependencies': ['control']},
            'error': {'type': 'list', 'maxlength': 3, 'schema': {'anyof_type': ['integer', 'string']}, 'dependencies': ['status']},
            'filter': filterSchema,
            'latch': {
                'type': 'dict',
                'schema': {
                    'position': {'required': True, 'type': 'string'},
                    'control': {'type': 'integer', 'default': 0},
                    'status': {'type': 'integer', 'default': 0},
                }
            },
            'primary': {'type': 'integer', 'default': -1},
            'homing': homingSchema,            
        }
    }

    controllerSchema = {
        'type': 'dict',
        'required': False,
        'default': {'controller': {'Kp': 1}},
        'schema': {
            'Kp': {'type': 'float', 'default': 1., 'min': 0},
            'Ki': {'type': 'float', 'default': 0., 'min': 0},
            'Kd': {'type': 'float', 'default': 0., 'min': 0},
            'Kff': {'type': 'float', 'default': 1., 'min': 0},
            'inner': {
                'type': 'dict',
                'required': False,
                'schema': {
                    'Kp': {'type': 'float', 'default': 1., 'min': 0},
                    'Ki': {'type': 'float', 'default': 0., 'min': 0},
                    'Kd': {'type': 'float', 'default': 0., 'min': 0},
                    'tol': {'type': 'float', 'default': 0., 'min': 0},
                }
            },
            'limits': {
                'type': 'dict',
                'required': False,
                'schema': {
                    'minOutput': {'type': 'float'},
                    'maxOutput': {'type': 'float'},
                    'minIntegral': {'type': 'float'},
                    'maxIntegral': {'type': 'float'},
                }
            },
            'deadband': {
                'type': 'dict',
                'required': False,
                'schema': {
                    'tol': {'type': 'float', 'min': 0},
                    'time': {'type': 'integer', 'min': 0},
                }
            },
        }
    }

    trajectorySchema = {
        'type': 'dict',
        'required': True,
        'schema': {
            'source': {'type': 'integer', 'default': 0, 'allowed': [0, 1]},
            'type': {'type': 'integer', 'default': 0, 'allowed': [0, 1]},
            'axis': {
                'required': True,
                'type': 'dict',
                'schema': {
                    'velocity': {'required': True, 'type': 'float'},
                    'acceleration': {'required': True, 'type': 'float'},
                    'jerk': {'type': 'float'},
                    'deceleration': {'type': 'float'},
                    'emergencyDeceleration': {'type': 'float'}
                }
            },
            'jog': {
                'type': 'dict',
                'schema': {
                    'velocity': {'type': 'float'},
                    'acceleration': {'type': 'float'},
                }
            },
            'modulo': {
                'type': 'dict',
                'schema': {
                    'range': {'type': 'float', 'default': 0.},
                    'type': {'type': 'integer', 'default': 0, 'allowed': [0, 1, 2, 3]}
                }
            },
        }
    }

    inputSchema = {
        'type': 'dict',
        'required': True,
        'schema': {
            'limit': {
                'type': 'dict',
                'required': True,
                'schema': {
                    'forward': {'required': True, 'type': 'string'},
                    'forwardPolarity': {'type': 'integer', 'allowed': [0, 1]},
                    'backward': {'required': True, 'type': 'string'},
                    'backwardPolarity': {'type': 'integer', 'allowed': [0, 1]},
                    'latchInput': {'type': 'boolean'}
                }
            },
            'home': {'required': True, 'type': 'string'},
            'homePolarity': {'type': 'integer', 'allowed': [0, 1]},
            'interlock': {'required': True, 'type': 'string'},
            'interlockPolarity': {'type': 'integer', 'allowed': [0, 1]},
        }
    }

    axisPlcSchema = {
        'type': 'dict',
        'required': False,
        'schema': {
            'enable': {'required': True, 'type': 'boolean'},
            'externalCommands': {'type': 'boolean'},
            'filter': filterSchema,
            'velocity_filter': plcVeloFilterSchema,
            'file': {'type': 'string'},
            'code': {'type': 'list', 'schema': {'type': 'string'}},
        }
    }

    plcSchema = {
        'type': 'dict',
        'required': True,
        'schema': {
            'id': {'required': True, 'type': 'integer'},
            'enable': {'type': 'boolean'},
            'rateMilliseconds': {'type': 'integer'},
            'file': {'type': 'string'},
            'code': {'type': 'list', 'schema': {'type': 'string'}},
        }
    }

    softlimitsSchema = {
        'type': 'dict',
        'required': False,
        'default': {'enable': False},
        'schema': {
            'enable': {'required': False, 'type': 'boolean'},
            'forwardEnable': {'type': 'boolean', 'dependencies': ['forward', 'enable']},
            'forward': {'type': 'float', 'dependencies': ['forwardEnable']},
            'backwardEnable': {'type': 'boolean', 'dependencies': ['backward', 'enable']},
            'backward': {'type': 'float', 'dependencies': ['backwardEnable']},
        }
    }

    monitoringSchema = {
        'type': 'dict',
        'required': False,
        'schema': {
            'lag': {
                'type': 'dict',
                'required': False,
                'default': {'enable': False, 'tolerance': 0.0, 'time': 100},
                'schema': {
                    'enable': {'required': True, 'type': 'boolean', 'dependencies': ['tolerance', 'time']},
                    'tolerance': {'type': 'float', 'min': 0.0},
                    'time': {'type': 'integer', 'min': 0},
                }
            },
            'target': {
                'type': 'dict',
                'required': False,
                'schema': {
                    'enable': {'required': True, 'type': 'boolean', 'dependencies': ['tolerance', 'time']},
                    'tolerance': {'type': 'float', 'min': 0.0},
                    'time': {'type': 'integer', 'min': 0},
                }
            },
            'velocity': {
                'type': 'dict',
                'required': False,
                'schema': {
                    'enable': {'required': True, 'type': 'boolean', 'dependencies': ['max', 'time']},
                    'max': {'type': 'float', 'min': 0.0},
                    'time': {
                        'type': 'dict',
                        'schema': {
                            'trajectory': {'required': True, 'type': 'integer', 'min': 0},
                            'drive': {'type': 'integer', 'min': 0},
                        }
                    },
                }
            },
            'velocityDifference': {
                'type': 'dict',
                'required': False,
                'schema': {
                    'enable': {'required': True, 'type': 'boolean', 'dependencies': ['max', 'time']},
                    'max': {'type': 'float', 'min': 0.0},
                    'time': {
                        'type': 'dict',
                        'schema': {
                            'trajectory': {'required': True, 'type': 'integer', 'min': 0},
                            'drive': {'type': 'integer', 'min': 0},
                        }
                    },
                }
            },
        }
    }

    grandSchema = {
        'var': varSchema,
        'axis': axisSchema,
        'epics': epicsSchema,
        'encoder': encoderSchema,
        'drive': driveSchema,
        'controller': controllerSchema,
        'trajectory': trajectorySchema,
        'input': inputSchema,
        'axisPlc': axisPlcSchema,
        'plc': plcSchema,
        'homing': homingSchema,
        'softlimits': softlimitsSchema,
        'monitoring': monitoringSchema,
        'meta': metaSchema
    }
