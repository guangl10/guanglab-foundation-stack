#!/usr/bin/env bash
# Quarto's built-in sitemap.xml lists literal output paths (…/index.html).
# Every page's own <link rel="canonical"> (set by filters/fs-seo.lua) uses the
# trailing-slash form instead (…/). That mismatch is what Google Search
# Console flags as "duplicate page, no user-selected canonical" — the sitemap
# and the canonical tag disagree about which URL is the real one.
#
# Run this after every `quarto render`, before the site is considered live.
# Idempotent — safe to run more than once.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SITEMAP="${ROOT}/_site/sitemap.xml"

if [[ ! -f "${SITEMAP}" ]]; then
  echo "No sitemap.xml at ${SITEMAP} — nothing to fix." >&2
  exit 1
fi

python3 - "${SITEMAP}" <<'PY'
import re
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    text = f.read()

# index.html -> trailing slash; bare .html (e.g. about.html) is left alone,
# it has no directory-style equivalent and its own canonical tag matches it.
before = text
text = re.sub(r"(<loc>[^<]*/)index\.html(</loc>)", r"\1\2", text)

with open(path, "w", encoding="utf-8") as f:
    f.write(text)

changed = text.count("<loc>") - text.count("index.html</loc>")
print(f"✓ sitemap.xml normalized ({before.count('index.html</loc>')} index.html entries rewritten)")
PY
