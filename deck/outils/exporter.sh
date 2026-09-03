#!/usr/bin/env bash
# Copy the built site and decks to the repository root, which Cloudflare
# Pages publishes as-is (no build step).
#
#   build/index.html           → index.html            the landing page
#   build/syllabus/index.html  → syllabus/index.html   next to the .md and the PDF
#   build/slides/**            → slides/**             one folder per deck, plus slides/index.html
#   build/_app/                → _app/                 the shared bundle, replaced atomically
#   build/img/                 → img/                  images used by site and decks
#
# The build uses relative paths (svelte.config.js), so a deck still works
# from any folder and from file:// on a laptop with no network.
#
# Usage: ./outils/exporter.sh            (run `npm run build` first)
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$SRC/.."

[ -d "$SRC/build/_app" ] || { echo "build absent — lancer npm run build" >&2; exit 1; }

rm -rf "$DEST/_app"; cp -r "$SRC/build/_app" "$DEST/_app"
rm -rf "$DEST/img";  cp -r "$SRC/build/img" "$DEST/img"
cp "$SRC/build/index.html" "$DEST/index.html"
mkdir -p "$DEST/syllabus"; cp "$SRC/build/syllabus/index.html" "$DEST/syllabus/index.html"

mkdir -p "$DEST/slides"
cp "$SRC/build/slides/index.html" "$DEST/slides/index.html"
for d in "$SRC"/build/slides/*/; do
  n="$(basename "$d")"
  rm -rf "$DEST/slides/$n"
  cp -r "$d" "$DEST/slides/$n"
  N=$(grep -o 'aria-label="Aller à la diapo ' "$DEST/slides/$n/index.html" | wc -l)
  echo "exporté: slides/$n/ · $N diapositives"
done
echo "exporté: index.html · syllabus/index.html · slides/index.html"
echo "_app: $(du -sh "$DEST/_app" | cut -f1) · $(find "$DEST/_app" -type f | wc -l) fichiers"
