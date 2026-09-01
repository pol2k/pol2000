#!/usr/bin/env bash
# Rebuild the POL-2000 plan de cours PDF.
# Requires: xelatex, and the fonts "Roboto Condensed" and "Open Sans".
# Run twice so \pageref{LastPage} resolves.
set -euo pipefail
cd "$(dirname "$0")"
xelatex -interaction=nonstopmode plan-de-cours-A26.tex >/dev/null
xelatex -interaction=nonstopmode plan-de-cours-A26.tex >/dev/null
cp plan-de-cours-A26.pdf ../POL-2000_A26.pdf
echo "Built ../POL-2000_A26.pdf ($(pdfinfo plan-de-cours-A26.pdf | awk '/^Pages/{print $2}') pages)"
