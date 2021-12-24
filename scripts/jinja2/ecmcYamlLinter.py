import subprocess

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

    def __init__(self, file=None):
        self.status = 0
        self.msg = None
        self.file = file

    '''
    call `yamllint` in subprocess and return exit code and stdout
    exit codes:
    0: OK
    1: ERROR
    2: WARNING
    '''
    def run(self, file=None, relaxed=False):
        file = self.file if file is None else file
        if file is None:
            raise AttributeError(f'no input file provided')
        procStr = f'yamllint -f colored --strict {file}'
        if relaxed:
            procStr = f'{procStr} -d "{relaxedRule}"'
        proc = subprocess.run(
            procStr,
            shell=True,
            stdout=subprocess.PIPE,
            encoding='utf8'
        )
        self.status = proc.returncode
        self.msg = proc.stdout


if __name__ == '__main__':
    # instance w/o file
    l = YamlLinter()
    # call linter on file
    l.run('pytest/yaml_files/joint_all.yaml')

    print(f'MSG: {l.msg}')

    # instance w/ file
    l2 = YamlLinter('pytest/yaml_files/joint_perfectLint.yaml')
    # call linter on self.file
    l2.run()

    # instance w/o file
    # l3 = YamlLinter()
    # call linter on None --> ERROR
    # l3.lint()
