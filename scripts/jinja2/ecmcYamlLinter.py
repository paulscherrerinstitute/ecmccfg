import yaml
from yamllint.config import YamlLintConfig
from yamllint import linter, cli

relaxedRule = {
    "rules": {
        "braces": {
            "max-spaces-inside": 1,
            "level": "warning"
        },
        "commas": {
            "level": "warning"
        },
        "colons": {
            "level": "warning"
        },
        "brackets": {
            "max-spaces-inside": 1,
            "level": "warning"
        },
        "line-length": {
            "max": 100,
            "allow-non-breakable-inline-mappings": True,
            "level": "warning"
        },
        "truthy": "disable",
        "comments": "disable",
        "hyphens": {
            "level": "warning"
        },
        "document-start": "disable",
        "indentation": {
            "level": "warning",
            "indent-sequences": "consistent"
        },
        "comments-indentation": "disable",
        "empty-lines": {
            "level": "warning"
        }
    },
    "extends": "default"
}


class YamlLinter:
    @staticmethod
    def run(file=None, relaxed=False):
        conf = YamlLintConfig('extends: default')
        if relaxed:
            conf = YamlLintConfig(yaml.dump(relaxedRule))
        f = open(file)
        gen = linter.run(f, conf)
        status = cli.show_problems(gen, file, 'colored', False)
        if status > 1:
            raise SyntaxError(f'yamllint failed!\n')


if __name__ == '__main__':
    # instance w/o file
    l = YamlLinter()

    l.run('pytest/yaml_files/linter_test_passRelaxed.yaml', relaxed=False)

    # l.run('pytest/yaml_files/joint_all.yaml')
