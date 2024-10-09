# ecmccfg HUGO documentation generator

## working on the HUGO sources locally
Github-pages (gh-pages branch) is used to host the web-site.
The static html is created by [HUGO](https://gohugo.io/) via a CI/CD pipeline (github actions).

For details take a look in the `.github/workflows` directory.

### obtaining the code
1. clone the repo `git clone <repo>`
1. change into the directory `cd <clone dir>`

***
### Prerequisites
#### HUGO
get HUGO if you don't have it already. Follow the instructions [here](https://gohugo.io/getting-started/quick-start/).

#### mdutils
```shell
pip install mdutils
```

##### build markdown documentation from doxygen sources
The markdown files are created from the doxygen information embedded in the `cmd` and `iocsh`.
The directories `'hardware', 'db', 'doc', 'examples', 'protocols', 'src'` are excluded from the parsing.
```shell
python ./hugo/doxygen2md/dox2md.py
```
This should create the `content/sources` directory in `hugo`.

***
### HUGO
1. fire up HUGO `hugo server -s ./hugo/ -D`
1. navigate in a browser to [localhost:1313](http://localhost:1313/), note the `1313` is the default port, which might differ on your system.
Observe the CLI output for details.
1. gawk at the beauty of the produced web-site :)

### editing the code
* content is found in the `content` directory
* mostly everything is done in markdown
* the HUGO theme ["learn"](http://github.com/matcornic/hugo-theme-learn) is used. Follow the instructions [here](https://learn.netlify.app/en/) for examples and an overview of it's capabilities.
* changes are reflected immediately in the browser after saving your changes.

### publish
Once you're happy with the changes, push them to the `master` branch.
This will trigger the CI/CD pipeline and the result will be visible [here](https://elnetmotion.gitpages.psi.ch/elnet-web/).
