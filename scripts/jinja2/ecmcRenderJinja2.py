from jinja2 import Template


def renderTemplate(template, data, outfile):
    # load the jinja2 template
    template = Template(open(template).read())

    # if 'var' is specified, pre-render the template
    if 'var' in data:
        template = Template(template.render(data))

    # render the template and write to 'outfile'
    with open(outfile, "w") as f:
        for line in template.render(data):
            f.write(line)
        f.close()
