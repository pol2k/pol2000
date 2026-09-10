#!/usr/bin/env bash
# Build, export, then check overflow at both projector sizes and capture the
# requested slides, all against a throwaway local server on port 8123.
#
#   ./outils/verifier.sh seance-2 [index[:temps] ...]
#
# Captures go to $CAPTURES (default: /tmp/captures-pol2000). A slide given
# as 27:3 is captured after three key presses.
set -euo pipefail
DECK="${1:?deck folder, e.g. seance-2}"; shift || true
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$HERE/.."
OUT="${CAPTURES:-/tmp/captures-pol2000}"; mkdir -p "$OUT"
export CHROMIUM="${CHROMIUM:-/usr/sbin/chromium}"

cd "$HERE"
npm run build 2>&1 | grep -E "✓ built|rror" | tail -1
npm run exporter 2>&1 | grep "$DECK"

python3 -m http.server 8123 --bind 127.0.0.1 --directory "$ROOT" >/dev/null 2>&1 &
SRV=$!
trap 'kill $SRV 2>/dev/null || true' EXIT
sleep 1
URL="http://127.0.0.1:8123/slides/$DECK/"
node outils/deborde.mjs "$URL" 1920 1080 || true
node outils/deborde.mjs "$URL" 1280 720 || true
for s in "$@"; do
  i="${s%%:*}"; k="${s#*:}"; [ "$k" = "$s" ] && k=0
  if [ "$k" = 0 ]; then node outils/capture.mjs "$URL" "$OUT" 1280 720 "$i" >/dev/null
  else node outils/capture-temps.mjs "$URL" "$OUT" "$i" "$k" 1280 720 >/dev/null; fi
done
echo "captures: $OUT"
