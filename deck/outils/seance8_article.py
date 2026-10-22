#!/usr/bin/env python3
"""Pages 425-428 of Blais and Gélineau (2007) for séance 8 (M8Article).

Renders PDF pages 1-4 of the article at 300 dpi, crops each to its text
body (the vertical « Downloaded from... » margin and the © footer are left
out) into static/img/s8-art-p1.png ... p4.png, and writes every word's box
(in % of its cropped page, read from `pdftotext -bbox`) to
src/lib/data/seance8_article.js, so that a component can highlight any
sentence where it really is on the page (src/lib/deck/article.js).

The PDF is copyrighted and stays out of the repository.

Usage, from deck/:
  python3 -I outils/seance8_article.py "/path/to/Political Studies - 2007 - Blais - ....pdf"
"""
import json, os, re, subprocess, sys, tempfile, html

PDF = sys.argv[1]
ICI = os.path.dirname(os.path.abspath(__file__))
IMG = os.path.join(ICI, '..', 'static', 'img')
JS = os.path.join(ICI, '..', 'src', 'lib', 'data', 'seance8_article.js')
R = 300  # dpi
# Text body crop boxes, in PDF points (page 484.7 x 697.3). Odd pages sit
# left, even pages right; page 1 stops above its footer box.
BOITES = {1: (32, 30, 401, 624.5), 2: (83, 30, 452, 636), 3: (32, 30, 401, 636), 4: (83, 30, 452, 636)}

pages = []
mots = []
with tempfile.TemporaryDirectory() as tmp:
    subprocess.run(['pdftoppm', '-f', '1', '-l', '4', '-r', str(R), '-png', PDF, os.path.join(tmp, 'pg')], check=True)
    for n, (x0, y0, x1, y1) in BOITES.items():
        s = R / 72
        g = f'{round((x1 - x0) * s)}x{round((y1 - y0) * s)}+{round(x0 * s)}+{round(y0 * s)}'
        src = os.path.join(tmp, f'pg-{n:02d}.png')
        out = os.path.join(IMG, f's8-art-p{n}.png')
        subprocess.run(['magick', src, '-crop', g, '+repage', '-strip', '-colors', '64', out], check=True)
        pages.append({'img': f's8-art-p{n}.png', 'l': round((x1 - x0) * s), 'h': round((y1 - y0) * s)})
        bbox = subprocess.run(['pdftotext', '-f', str(n), '-l', str(n), '-bbox', PDF, '-'], check=True, capture_output=True, text=True).stdout
        w, h = x1 - x0, y1 - y0
        for m in re.finditer(r'<word xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">(.*?)</word>', bbox):
            a, b, c, d = map(float, m.groups()[:4])
            if a < x0 or c > x1 or b < y0 or d > y1:
                continue  # the watermark, the footer
            mots.append([n - 1, round((a - x0) / w * 100, 2), round((b - y0) / h * 100, 2),
                         round((c - a) / w * 100, 2), round((d - b) / h * 100, 2), html.unescape(m.group(5))])

with open(JS, 'w') as f:
    f.write('/* Généré par outils/seance8_article.py. Blais et Gélineau (2007), Political\n'
            '   Studies 55(2), p. 425-428 : les pages (images) et la boîte de chaque mot,\n'
            '   en % de sa page découpée. [page, x, y, largeur, hauteur, mot]. Ne pas\n'
            '   modifier à la main. */\n')
    f.write('export const PAGES = ' + json.dumps(pages) + ';\n')
    f.write('export const MOTS = ' + json.dumps(mots, ensure_ascii=False, separators=(',', ':')) + ';\n')
print(len(pages), 'pages,', len(mots), 'mots ->', os.path.relpath(JS))
