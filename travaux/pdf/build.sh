#!/usr/bin/env bash
# Builds ../POL-2000_A26_travail_<name>.pdf for each travail (xelatex twice for the page count).
set -euo pipefail
cd "$(dirname "$0")"
for nom in mi-session final; do
  src="travail-$nom-A26"
  xelatex -interaction=nonstopmode "$src.tex" >/dev/null
  xelatex -interaction=nonstopmode "$src.tex" >/dev/null
  cp "$src.pdf" "../POL-2000_A26_travail_$nom.pdf"
  echo "Built ../POL-2000_A26_travail_$nom.pdf ($(pdfinfo "$src.pdf" | awk '/^Pages/{print $2}') pages)"
done
