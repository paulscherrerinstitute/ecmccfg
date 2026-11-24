#!/usr/bin/env python3
"""Render both axis YAML lookup pages from the shared reference source.

Run with --check in CI to detect stale generated Markdown. Standard library only.
"""
import argparse
import json
from pathlib import Path

HUGO = Path(__file__).resolve().parents[1]
BEGIN = '<!-- BEGIN GENERATED AXIS YAML REFERENCE -->'
END = '<!-- END GENERATED AXIS YAML REFERENCE -->'


def render(sections):
    ecb = json.loads((HUGO.parent / 'scripts/jinja2/ecbSchema.json').read_text())
    types = {key: item['type'] for block in ecb.values()
             for key, item in block.get('schema', {}).items()}

    def dtype(key):
        if key.startswith('plc.code['):
            return 'string (list item)'
        if key in types:
            raw = types[key]
            label = ' / '.join(raw.replace('intger', 'integer').split())
            return label + (' (schema typo)' if 'intger' in raw else '')
        return 'mapping' if any(k.startswith(key + '.') for k in types) else '—'

    def esc(value):
        return str(value).replace('|', '\\|').replace('\n', ' ')

    def row(key, desc, requirement, default='—'):
        return '| `' + key + '` | ' + dtype(key) + ' | ' + esc(desc) + ' | ' + esc(requirement) + ' | ' + esc(default) + ' |'

    table = []
    headings = []
    seen = set()
    for section in sections:
        table.extend(['## ' + section['name'], '', '| Key | Type (ECB schema) | Description | Requirement | Default |', '| --- | --- | --- | --- | --- |'])
        headings.extend(['## ' + section['name'], ''])
        for group in section['groups']:
            label = ' / '.join('`' + key + '`' for key in group['keys'])
            requirement = group['requirement']
            defaults = ["`" + entry['key'] + "`: " + str(entry['default'])
                        for entry in group['entries'] if 'default' in entry]
            suffix = ' Defaults: ' + '; '.join(defaults) + '.' if defaults else ''
            headings.append('- ' + label + ' (' + requirement + ') — ' + group['description'] + suffix)
            entry_keys = {entry['key'] for entry in group['entries']}
            extra = [key for key in group['keys'] if key not in entry_keys]
            for key in extra:
                table.append(row(key, group['description'], requirement))
            for index, entry in enumerate(group['entries']):
                key = entry['key']
                if key in seen:
                    raise ValueError('Duplicate reference key: ' + key)
                seen.add(key)
                desc = entry['summary'] or group['description']
                if index == 0 and not extra and entry['summary'] and entry['summary'] != group['description']:
                    desc += ' — ' + group['description']
                table.append(row(key, desc, requirement, entry.get('default', '—')))
        table.append('')
        headings.append('')
    return {'axisYamlSettingsTable.md': '\n'.join(table).rstrip(),
            'axisYamlSettingsHeadings.md': '\n'.join(headings).rstrip()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    source = json.loads((HUGO / 'reference/axis-yaml-settings.json').read_text())
    stale = []
    for name, body in render(source['sections']).items():
        path = HUGO / 'content/manual/motion_cfg' / name
        current = path.read_text()
        before, rest = current.split(BEGIN, 1)
        _, after = rest.split(END, 1)
        expected = before + BEGIN + '\n\n' + body + '\n\n' + END + after
        if expected != current:
            stale.append(str(path.relative_to(HUGO)))
            if not args.check:
                path.write_text(expected)
    if args.check and stale:
        parser.exit(1, 'Stale axis reference pages; run python3 hugo/scripts/generate_axis_reference.py:\n' + '\n'.join(stale) + '\n')
    print('Axis YAML reference pages are current.' if args.check else 'Generated both axis YAML reference pages.')


if __name__ == '__main__':
    main()
