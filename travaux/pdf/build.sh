#!/usr/bin/env bash
# Builds ../POL-2000_A26_travail_mi-session.pdf (xelatex twice for the page count).
set -euo pipefail
cd "$(dirname "$0")"
xelatex -interaction=nonstopmode travail-mi-session-A26.tex >/dev/null
xelatex -interaction=nonstopmode travail-mi-session-A26.tex >/dev/null
cp travail-mi-session-A26.pdf ../POL-2000_A26_travail_mi-session.pdf
echo "Built ../POL-2000_A26_travail_mi-session.pdf ($(pdfinfo travail-mi-session-A26.pdf | awk '/^Pages/{print $2}') pages)"
