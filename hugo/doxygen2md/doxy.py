import re
import os
from pathlib import Path
import datetime

from mdutils.mdutils import MdUtils

class doxyFile:
  def __init__(self, fn, output='./'):
    self.fileName = fn
    mdFile = str(Path(output,Path(self.fileName).stem))
    self.mdFile = MdUtils(file_name=mdFile)
    # self.mdFile = MdUtils(file_name=Path(self.fileName).stem)
    self.doxygen = []
    self.file = False
    self.chapter = False
    self.headerWritten = False
    self.paramsWritten = False
    self.title = None
    self.brief = None
    self.details = None
    self.author = None
    self.params = {}
    self.code = []
    self.pre = ''
    self.post = ''

  @staticmethod
  def isDocLine(string):
    m = re.match("#-d", string)  # match if line starts with '#-d'
    if m is None:
      return False
    return True

  @staticmethod
  def splitDocLine(string):
    com = None
    payload = None

    line = string.lstrip('#-d').strip()  # strip away doc indicator and newline

    m = re.match(r"\\", line)  # match leading '\', which indicates a command
    if m is not None: # command found, split command and payload
      cLine = line[m.end():].lstrip().split(" ", 1)
      com = cLine[0]
      if len(cLine) > 1: # catch command w/o payload
        payload = cLine[1]  # spit out the command, which is the first element of the array
    else: # no command, just payload
      payload = line.lstrip()
    return com, payload

  def readFile(self):
    isCode = False
    with open(self.fileName) as f:
      for line in f:
        if self.isDocLine(line): # process doc only
          command, payload = self.splitDocLine(line)
          if command is not None:
            if command.lower() == 'code':
              isCode = True
            if command.lower() == 'endcode':
              isCode = False
          if command is not None or isCode:
            self.doxygen.append([command, payload, isCode])

  def doxyExtract(self):
    for line in self.doxygen:
      if self.hasKey(line):
        self.extractor(key=line[0], payload=line[1])
      if self.isCode(line) and line[0] is None:
        self.addCode(code=line[1])

  @staticmethod
  def hasKey(line):
    if line[0] is not None:
      return True
    return False

  @staticmethod
  def isCode(line):
    return line[2]

  def extractor(self, key, payload):
    if key == 'brief':
      self.brief = payload
    if key == 'details':
      self.details = payload
    if key == 'author':
      self.author = payload
    if key == 'file':
      self.mdHeader()
    if key == 'param':
      if not self.headerWritten:
        raise RuntimeError('parameter defined before `file`')
      self.addParam(payload)
    if key == 'note':
      if not self.headerWritten:
        raise RuntimeError('note defined before `file`')
      if not self.paramsWritten:
        self.mdParams()
      self.addBody(payload)
    if key == 'code':
      self.code = []
    if key == 'endcode':
      self.writeCode()

  def addParam(self, param):
    self.paramsWritten = False
    # parameters are in the form: PARAMETER <DESCRIPTION>
    p = param.split(" ", 1) # spilt parameter from description
    if len(p) > 1:
      self.params[p[0]]=p[1]
    else:
      self.params[p[0]]=''

  def addBody(self, text):
    self.mdFile.new_line(text)

  def addCode(self, code):
    self.code.append(code)

  def writeCode(self):
    self.mdFile.insert_code('\n'.join(self.code),language="bash")

  def mdParams(self):
    if len(self.params) == 0:
      return
    # self.mdFile.new_header(level=3, title='paramters')
    self.mdFile.new_line("### paramters")
    for p,d in self.params.items():
      self.mdFile.new_line("**{}** {}".format(p,d))
    self.mdFile.new_line("***")
    self.paramsWritten = True
    self.params = {}

  def mdHeader(self):
    self.mdFile.new_line("+++")
    if self.title is None:
      self.mdFile.new_line("title = \"{}\"".format(str(Path(self.fileName).name)))
    else:
      self.mdFile.new_line("title = \"{}\"".format(self.title))
    self.mdFile.new_line("date = " + datetime.datetime.now().astimezone().replace(microsecond=0).isoformat())
    self.mdFile.new_line("weight = 5")
    if self.chapter:
      self.mdFile.new_line("chapter = true")
    else:
      self.mdFile.new_line("chapter = false")
    self.mdFile.new_line("+++")
    if self.details is not None:
      self.mdFile.new_line("### description")
      self.mdFile.new_line("**{}**".format(self.brief))
    if self.details is not None:
      self.mdFile.new_line("#### details")
      self.mdFile.new_line("{}".format(self.details))
    if self.author is not None:
      self.mdFile.new_line("### author")
      self.mdFile.new_line("{}".format(self.author))
    self.mdFile.new_line("***")
    self.headerWritten = True

# Press the green button in the gutter to run the script.
if __name__ == '__main__':

  source = 'source'
  target = 'content/source'
  extensions = ('.cmd', '.iocsh')
  exclude = {'hardware', 'db', 'doc', 'examples', 'protocols', 'src'}

  def mkDir(root, dir='', lstrip=0):
    p = Path(root, dir)
    np = Path(*p.parts[lstrip:])
    dir = Path(target, np)
    dir.mkdir(parents=True, exist_ok=True)
    df = doxyFile(Path(root, '_index.md'), output=dir)
    df.title = str(dir.parts[-1])
    df.chapter = True
    df.mdHeader()
    df.mdFile.new_line('{{% children %}}')
    df.mdFile.create_md_file()
    return dir

  for root, dirs, files in os.walk(source, topdown=True):
    [dirs.remove(d) for d in list(dirs) if d in exclude]
    [files.remove(f) for f in list(files) if not f.endswith(extensions)]
    [dirs.remove(d) for d in list(dirs) if not files]

    for file in files:
      outDir = mkDir(root, lstrip=1)
      df = doxyFile(Path(root,file), output=outDir)
      # df = doxyFile('./files/applyConfig.cmd')
      df.readFile()
      df.doxyExtract()
      df.mdFile.create_md_file()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
