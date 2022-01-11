import yaml
import json
import sys
from cerberus import Validator

import ecmcYamlSchema


class Validated:
    '''
    data container
    '''

    def __init__(self, data=None):
        if data is None:
            self.data = {}
        elif type(data) is dict:
            self.data = data
        else:
            raise NotImplementedError(f'data must be of type _dict_')

    def __str__(self):
        return self.to_yaml()

    def to_yaml(self):
        return yaml.dump(self.data)

    def to_json(self):
        return json.dumps(self.data)


class ConfigValidator:
    '''
    config validator
    args:
        document, type 'dict'
    '''

    def __init__(self, document):
        self.Schema = ecmcYamlSchema.Schema()
        self.document = document
        self.validated = Validated()
        self.v = Validator(purge_unknown=False, allow_unknown=True)

    def get_axis_type(self):
        schema = self.Schema.get_schema('axis')
        if self.v.validate(self.document, schema):
            return self.v.normalized(self.document)['axis']['type']
        else:
            raise NotImplementedError(f'{yaml.dump(self.v.errors)}')

    def validate_axis(self, strict=False):
        schema = self.Schema.get_schema(self.Schema.axisSchemaDict[self.get_axis_type()])
        if self.v.validate(self.document, schema):
            return self.v.normalized(self.document)
        else:
            e = yaml.dump(self.v.errors)
            if strict:
                raise SyntaxError(e)
            else:
                print(e)

    def write(self, outfile=None, output_format='yaml'):
        if output_format.lower() == 'yaml':
            text = self.validated.to_yaml()
        elif output_format.lower() == 'json':
            text = self.validated.to_json()
        else:
            raise NotImplementedError(f'unsupported output format, options are [yaml|json]')

        if outfile is None:
            out = sys.stdout
        else:
            out = open(outfile, 'w')
        try:
            out.write(text)
        finally:
            if outfile is not None:
                out.close()


if __name__ == '__main__':
    file = 'pytest/yaml_files/joint_all.yaml'
    with open(file) as f:
        doc = yaml.load(f, Loader=yaml.FullLoader)
    v = ConfigValidator(doc)

    v.validated.data = v.validate_axis(strict=False)

    print(v.validated)
    print(type(v.validated))
