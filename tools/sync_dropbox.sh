#!/usr/bin/env bash
# Pull Mark's Dropbox source folder; stage only files never seen before (by SHA-256) into dropbox/inbox/<stamp>/
set -euo pipefail
URL="${1:-https://www.dropbox.com/scl/fo/50uhxxtspf5g3dmwn5f3t/ADITZdnj0PikGG1loetzqJ8?rlkey=2ir1u2cpubn2dvspbl7yfiydw&dl=1}"
R=/workspace/mwd-broken/dropbox; L=$R/seen.sha256; mkdir -p $R; touch $L
T=$(mktemp -d); trap 'rm -rf $T' EXIT
curl -sSL --fail -o $T/f.zip "$URL"; unzip -qq -o $T/f.zip -d $T/x || true
S=$(date +%Y%m%d-%H%M%S); IN=$R/inbox/$S; n=0; tot=0
while IFS= read -r -d '' f; do tot=$((tot+1)); h=$(sha256sum "$f"|cut -d' ' -f1)
  if ! grep -q "^$h " $L; then mkdir -p "$IN/$(dirname "${f#$T/x/}")"; cp "$f" "$IN/${f#$T/x/}"; echo "$h ${f#$T/x/}" >> $L; n=$((n+1)); fi
done < <(find $T/x -type f -print0)
echo "folder files: $tot  new: $n  ${n:+-> $IN}"; [ $n -gt 0 ] && find "$IN" -type f | sort || rmdir "$IN" 2>/dev/null || true
