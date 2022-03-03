import os
from pathlib import Path
from doxy import doxyFile


def mkDir(root, directory='', lstrip=0):
    p = Path(root, directory)
    np = Path(*p.parts[lstrip:])
    directory = Path(target, np)
    directory.mkdir(parents=True, exist_ok=True)
    # create an index.md for each directory
    doxygenFile = doxyFile(Path(root, '_index.md'), output=directory)
    doxygenFile.title = str(directory.parts[-1])
    doxygenFile.chapter = True
    doxygenFile.mdHeader()
    doxygenFile.mdFile.new_line('{{% children %}}')
    doxygenFile.mdFile.create_md_file()
    return directory


if __name__ == '__main__':
    source = './'
    target = 'hugo/content/source'
    extensions = ('.cmd', '.iocsh')
    exclude = {'hardware', 'db', 'doc', 'examples', 'protocols', 'src'}

    for root, dirs, files in os.walk(source, topdown=True):
        [dirs.remove(d) for d in list(dirs) if d in exclude]
        [files.remove(f) for f in list(files) if not f.endswith(extensions)]
        [dirs.remove(d) for d in list(dirs) if not files]

        for file in files:
            outDir = mkDir(root, lstrip=0)
            df = doxyFile(Path(root, file), output=outDir)
            # df = doxyFile('./files/applyConfig.cmd')
            df.readFile()
            df.doxyExtract()
            df.mdFile.create_md_file()
