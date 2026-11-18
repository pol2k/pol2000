#!/usr/bin/env python3
"""Pages of two documents for séance 11 (M8Article, reused with props):

  richard  Richard and Régimbal (2026), « L'insécurité alimentaire chez les
           cégépiens », Canadian Journal of Higher Education 56(1), p. 71-83
           (PDF pages 1-13): static/img/s11-art-p1.png ... p13.png and
           src/lib/data/seance11_article.js
  usda     USDA ERS (2024), U.S. Household Food Security Survey Module:
           Six-Item Short Form, PDF pages 2-4 (the questions and the scoring
           rule): static/img/s11-usda-p1.png ... p3.png and
           src/lib/data/seance11_usda.js

Same output as outils/seance8_article.py: each page cropped to a box, and
every word's box (in % of its cropped page, read from `pdftotext -bbox`) so
that src/lib/deck/article.js can highlight any sentence where it is printed.

The PDFs stay out of the repository.

Usage, from deck/:
  python3 -I outils/seance11_article.py richard "/path/to/CJHE-RCÉS+56-1+05+190771+Richard+71-92.pdf"
  python3 -I outils/seance11_article.py usda /path/to/short2024.pdf
  (short2024.pdf: https://www.ers.usda.gov/sites/default/files/_laserfiche/DataFiles/50764/short2024.pdf)
"""
import json, os, re, subprocess, sys, tempfile, html

DOCS = {
    # first, last PDF page; crop box in PDF points (letter, 612 x 792)
    'richard': dict(pages=(1, 13), box=(56, 16, 556, 780), r=200, prefix='s11-art-p', js='seance11_article.js',
                    titre='Richard et Régimbal (2026), Canadian Journal of Higher Education 56(1), p. 71-83'),
    'usda': dict(pages=(2, 4), box=(60, 50, 552, 742), r=200, prefix='s11-usda-p', js='seance11_usda.js',
                 titre='USDA ERS (2024), Six-Item Short Form, p. 2-4'),
}

quel, PDF = sys.argv[1], sys.argv[2]
D = DOCS[quel]
ICI = os.path.dirname(os.path.abspath(__file__))
IMG = os.path.join(ICI, '..', 'static', 'img')
JS = os.path.join(ICI, '..', 'src', 'lib', 'data', D['js'])
R = D['r']
x0, y0, x1, y1 = D['box']
a, b = D['pages']

pages, mots = [], []
with tempfile.TemporaryDirectory() as tmp:
    subprocess.run(['pdftoppm', '-f', str(a), '-l', str(b), '-r', str(R), '-png', PDF, os.path.join(tmp, 'pg')], check=True)
    fichiers = sorted(f for f in os.listdir(tmp) if f.startswith('pg'))
    for k, n in enumerate(range(a, b + 1)):
        s = R / 72
        g = f'{round((x1 - x0) * s)}x{round((y1 - y0) * s)}+{round(x0 * s)}+{round(y0 * s)}'
        out = os.path.join(IMG, f"{D['prefix']}{k + 1}.png")
        subprocess.run(['magick', os.path.join(tmp, fichiers[k]), '-crop', g, '+repage', '-strip', '-colors', '32', out], check=True)
        pages.append({'img': f"{D['prefix']}{k + 1}.png", 'l': round((x1 - x0) * s), 'h': round((y1 - y0) * s)})
        bbox = subprocess.run(['pdftotext', '-f', str(n), '-l', str(n), '-bbox', PDF, '-'], check=True, capture_output=True, text=True).stdout
        w, h = x1 - x0, y1 - y0
        for m in re.finditer(r'<word xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">(.*?)</word>', bbox):
            p, q, c, d = map(float, m.groups()[:4])
            if p < x0 or c > x1 or q < y0 or d > y1:
                continue
            mots.append([k, round((p - x0) / w * 100, 2), round((q - y0) / h * 100, 2),
                         round((c - p) / w * 100, 2), round((d - q) / h * 100, 2), html.unescape(m.group(5))])

with open(JS, 'w') as f:
    f.write(f"/* Généré par outils/seance11_article.py ({quel}). {D['titre']} :\n"
            '   les pages (images) et la boîte de chaque mot, en % de sa page découpée.\n'
            '   [page, x, y, largeur, hauteur, mot]. Ne pas modifier à la main. */\n')
    f.write('export const PAGES = ' + json.dumps(pages) + ';\n')
    f.write('export const MOTS = ' + json.dumps(mots, ensure_ascii=False, separators=(',', ':')) + ';\n')
print(len(pages), 'pages,', len(mots), 'mots ->', os.path.relpath(JS))
