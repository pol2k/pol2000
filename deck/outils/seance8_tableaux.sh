#!/usr/bin/env bash
# Crop the first page and the real Tables 1 and 2 of Blais and Gélineau (2007) out of the
# article PDF, for séance 8 (M8Gelineau, M8Tableau2). The PDF itself is
# copyrighted and stays out of the repository; only the two crops are
# committed, cited on the slides.
#
#   static/img/s8-bg-une.png        the first page (p. 425), down to its last text line
#   static/img/s8-bg-tableau1.png   Table 1, p. 431 (PDF page 7), whole
#   static/img/s8-bg-tableau2.png   Table 2, p. 432 (PDF page 8), whole, at
#                                   full resolution: M8Tableau2 shows it at
#                                   slide width and scrolls through it
#
# The boxes are in PDF points (page 484.7 × 697.3), read from
# `pdftotext -bbox`; they leave out the « Downloaded from … » margin and
# the © footer. The highlight frames in the components are percentages of
# these same boxes: change one, change the other.
#
# Usage: ./outils/seance8_tableaux.sh "/path/to/Political Studies - 2007 - Blais - ….pdf"
set -euo pipefail

PDF="${1:?chemin du PDF (article Blais et Gélineau)}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$SRC/static/img"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
R=400   # dpi; 1 pt = R/72 px

pdftoppm -f 1 -l 1 -r "$R" -png "$PDF" "$TMP/pg"
pdftoppm -f 7 -l 8 -r "$R" -png "$PDF" "$TMP/pg"

# crop PAGE X0 Y0 X1 Y1 OUT [resize]
crop() {
  local g
  g=$(python3 -c "s=$R/72; print(f'{round(($4-$2)*s)}x{round(($5-$3)*s)}+{round($2*s)}+{round($3*s)}')")
  magick "$TMP/pg-0$1.png" -crop "$g" +repage ${7:+-resize $7} -strip "$6"
}

crop 1  34  22 458 624.5 "$OUT/s8-bg-une.png" 1296x
crop 7  38  54 394 210 "$OUT/s8-bg-tableau1.png"
crop 8  86  54 448 628 "$OUT/s8-bg-tableau2.png"
identify "$OUT"/s8-bg-*.png
