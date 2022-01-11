import yaml
from cerberus import Validator

import ecmcYamlSchema


class YamlValidator:
    def __init__(self, document):
        self.Schema = ecmcYamlSchema.Schema()
        self.document = document
        self.parsed = None
        self.validated = {}
        self.d = None
        self.v = Validator(purge_unknown=True)

    def get_axis_type(self):
        schema = self.Schema.get_schema('axis')
        if self.v.validate(self.document, schema):
            return self.v.normalized(self.document)['axis']['type']
        else:
            raise SyntaxError(f'{yaml.dump(self.v.errors)}')

    def validate_axis(self):
        schema = self.Schema.get_schema(self.Schema.axisSchemaDict[self.get_axis_type()])
        if self.v.validate(self.document, schema):
            print(f'=================================\n'
                  f'{yaml.dump(self.v.normalized(self.document))}'
                  f'=================================')
        else:
            print(yaml.dump(self.v.errors))


if __name__ == '__main__':
    file = 'pytest/yaml_files/joint_all.yaml'
    with open(file) as f:
        document = yaml.load(f, Loader=yaml.FullLoader)
    v = YamlValidator(document)

    v.validate_axis()
