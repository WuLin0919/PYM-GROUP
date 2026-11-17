"""Prepare an apply_patch patch from the original WoS author records (read-only).

Requires xlrd and PyYAML. Run with --patch to emit the proposed YAML edit.
"""
import argparse
import collections
import json
from pathlib import Path
import re

import xlrd
import yaml

ROOT = Path(__file__).resolve().parents[1]
MANUAL = {
    '10.1016/j.apm.2026.117418': [
        ('Zhao, Xing', False), ('Peng, Kangming', False),
        ('Liu, Jinxi', True), ('Pei, Yongmao', True)],
    '10.1016/j.tws.2026.115754': [
        ('Deng, Jianqiang', False), ('Ke, Lingrui', False),
        ('Zhang, Songbo', False), ('Chen, Liming', True), ('Pei, Yongmao', True)],
}


def display_name(full, compact=None):
    if ', ' in full:
        family, given = full.split(', ', 1)
    else:
        family = compact.split(',')[0]
        given = full[len(family):].strip()
    if compact:
        family = compact.split(',')[0]
    # Hyphenated Chinese given names are treated as a single given name.
    initials = ' '.join(word[0].upper() + '.' for word in given.replace('-', '').split())
    if not initials:
        raise ValueError(f'Missing given name: {full}')
    return f'{family} {initials}'


def prepare():
    data_path = ROOT / '_data/publications.yml'
    content = data_path.read_text(encoding='utf-8')
    publications = yaml.safe_load(content)
    sheet = xlrd.open_workbook(str(ROOT / 'source_data/publications/web_of_science_publications.xls')).sheet_by_index(0)
    headers = sheet.row_values(0)
    rows = [dict(zip(headers, sheet.row_values(i))) for i in range(1, sheet.nrows)]
    by_doi = {r['DOI'].lower(): r for r in rows if r['DOI']}
    by_title = {r['Article Title'].casefold(): r for r in rows}
    blocks = [b for b in re.split(r'(?m)(?=^- number:)', content) if b.strip()]
    patches, ambiguities, over_ten = [], [], []
    for publication, block in zip(publications, blocks, strict=True):
        doi = publication.get('doi', '').lower()
        authors = []
        if doi in MANUAL:
            authors = [{'name': display_name(n), **({'corresponding': True} if c else {})} for n, c in MANUAL[doi]]
        else:
            row = by_doi.get(doi) if doi else by_title.get(publication['title'].casefold())
            if row is None:
                raise ValueError(f'No source for {publication["title"]}')
            compact = [a.strip() for a in row['Authors'].split(';')]
            full = [a.strip() for a in row['Author Full Names'].split(';')]
            if len(compact) != len(full):
                raise ValueError(f'Author count mismatch for {doi}')
            counts = collections.Counter(compact)
            rp = row['Reprint Addresses']
            for short, complete in zip(compact, full, strict=True):
                author = {'name': display_name(complete, short)}
                corresponding = re.search(r'(?:^|;)\s*' + re.escape(short) + r'\s*(?=[;(])', rp) is not None
                if corresponding and counts[short] > 1:
                    ambiguities.append((doi, short))
                    corresponding = False
                # Preserve the existing verified Pei corresponding-author classification.
                if short == 'Pei, YM':
                    corresponding = publication.get('corresponding', False)
                if corresponding:
                    author['corresponding'] = True
                authors.append(author)
        # Publisher disambiguates two Wang H. authors in this paper.
        # https://www.mdpi.com/1996-1944/19/8/1613
        if doi == '10.3390/ma19081613':
            authors[5]['corresponding'] = True
        if len(authors) > 10:
            over_ten.append(doi)
        if 'authors' in publication:
            raise ValueError(f'Authors already present for {doi}; refuse duplicate insertion')
        first_line = block.splitlines()[0]
        addition = ['  authors:']
        for author in authors:
            addition.append('    - name: ' + json.dumps(author['name'], ensure_ascii=False))
            if author.get('corresponding'):
                addition.append('      corresponding: true')
        patches.append('@@\n ' + first_line + '\n' + '\n'.join('+' + line for line in addition))
    patch = '*** Begin Patch\n*** Update File: ' + str(data_path) + '\n' + '\n'.join(patches) + '\n*** End Patch'
    return patch, {'publications': len(publications), 'wos_sources': len(rows), 'over_ten': over_ten, 'ambiguous_correspondence': ambiguities}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--patch', action='store_true')
    options = parser.parse_args()
    patch, report = prepare()
    print(patch if options.patch else json.dumps(report, ensure_ascii=False, indent=2))
