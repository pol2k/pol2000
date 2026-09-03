#!/usr/bin/env bash
# Copy the built decks into ../slides/, which Cloudflare Pages publishes as-is.
#
# The build uses relative paths (svelte.config.js), so a deck works from any
# folder and even from file:// on a laptop with no network. Every deck shares
# one _app/ bundle; re-running this after a rebuild replaces it atomically.
#
# Usage: ./outils/exporter.sh            (run `npm run build` first)
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$SRC/../slides"

[ -d "$SRC/build/_app" ] || { echo "build absent — lancer npm run build" >&2; exit 1; }

rm -rf "$DEST/_app"
cp -r "$SRC/build/_app" "$DEST/_app"
[ -d "$SRC/build/img" ] && { rm -rf "$DEST/img"; cp -r "$SRC/build/img" "$DEST/img"; }
cp "$SRC/build/index.html" "$DEST/index.html"

for d in "$SRC"/build/*/; do
  n="$(basename "$d")"
  case "$n" in _app|img) continue ;; esac
  rm -rf "$DEST/$n"
  cp -r "$d" "$DEST/$n"
  N=$(grep -o 'aria-label="Aller à la diapo ' "$DEST/$n/index.html" | wc -l)
  echo "exporté: slides/$n/ · $N diapositives"
done
echo "_app: $(du -sh "$DEST/_app" | cut -f1) · $(find "$DEST/_app" -type f | wc -l) fichiers"
