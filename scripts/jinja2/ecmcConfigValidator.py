import yaml
import json
import sys
import cerberus

import ecmcYamlSchema

class color:
    """
    class for colorful printing
    example: print(f'{color.RED}foo{color.END}')
    """
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    DARKCYAN = '\033[36m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'


class DictContainer:
    """
    data container for 'dict'
    """

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

    def write(self, outfile=None, output_format='yaml'):
        """
        write contents of 'DictContainer' to file
        TODO: should be a DictContainer method and be inherited
        """
        if output_format.lower() == 'yaml':
            text = self.to_yaml()
        elif output_format.lower() == 'json':
            text = self.to_json()
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


class ConfigValidator:
    """
    config validator
    args:
        document, type == 'dict'
    """

    def __init__(self, document):
        self.Schema = ecmcYamlSchema.Schema()
        self.document = document
        self.validated = DictContainer()
        self.v = cerberus.Validator(purge_unknown=False, allow_unknown=True)

    @staticmethod
    def __yaml_dump_error(err, strict=False):
        """
        dump Cerberus errors as yaml, with colors
        raise SyntaxError if 'strict'
        """
        e = DictContainer(data=err)
        msg = f'{color.RED}{color.BOLD}\nError:\n' \
              f'{color.YELLOW}{e.to_yaml()}{color.END}'
        if strict:
            raise SyntaxError(msg)
        else:
            print(msg)

    def validate(self, document=None, schema=None, strict=False) -> dict:
        """
        validate a document against a schema using Cerberus
        default to 'self.document'
        schema can be preset with `class_instance.v.schema =`
        uses __yaml_dump_error in case of validation fails
        """
        if document is None:
            document = self.document
        if schema is not None:
            self.v.schema = schema
        if self.v.validate(document):
            return self.v.normalized(document)
        else:
            self.__yaml_dump_error(self.v.errors, strict=strict)

    def get_axis_type(self) -> int:
        """
        return the integer axis type
        always "strict" __yaml_dump_error
        re-raises as NotImplementedError with hint to suppoerted axis types
        """
        schema = self.Schema.get_schema('axis')
        try:
            return self.validate(schema=schema, strict=True)['axis']['type']
        except SyntaxError as err:
            raise NotImplementedError(f'{err}\n'
                                      f'supported axis types are:\n'
                                      f'{color.GREEN}{ecmcYamlSchema.supportedAxisTypes.keys()}{color.END}')

    def validate_axis(self, strict=False) -> dict:
        """
        validate the complete document against the internal axis type.
        """
        schema = self.Schema.get_schema(self.Schema.axisSchemaDict[self.get_axis_type()])
        return self.validate(schema=schema, strict=strict)


def main():
    file = 'pytest/yaml_files/joint_all.yaml'
    # file = 'pytest/yaml_files/axisTypeNotImplementedError.yaml'
    with open(file) as f:
        doc = yaml.load(f, Loader=yaml.FullLoader)
    v = ConfigValidator(doc)

    print(v.get_axis_type())

    v.validated.data = v.validate_axis(strict=False)
    # v.validated.data = v.validate_axis(strict=True)

    v.validated.write()


if __name__ == '__main__':
    main()
