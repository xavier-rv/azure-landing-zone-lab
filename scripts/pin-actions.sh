#!/usr/bin/env bash
# Sustituye "uses: owner/repo@latest" por "uses: owner/repo@<sha> # <tag>".
# Requiere gh autenticado.
set -euo pipefail

for f in $(grep -rlE 'uses: [^ ]+@latest' .github/workflows || true); do
  grep -oE 'uses: [^ @]+@latest' "$f" | sort -u | while read -r _ ref; do
    repo=${ref%@latest}
    tag=$(gh api "repos/$repo/releases/latest" --jq .tag_name)
    sha=$(gh api "repos/$repo/commits/$tag" --jq .sha)
    sed -i "s|uses: $repo@latest|uses: $repo@$sha # $tag|g" "$f"
    echo "$repo -> $tag ($sha)"
  done
done
