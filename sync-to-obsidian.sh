#!/usr/bin/env bash
# Mirror published FS posts into Obsidian (read-only archive). Run after deploy.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
PUBLISHED="${FS_OBSIDIAN_PUBLISHED:-$HOME/Documents/Obsidian/MyVault/research/foundation-stack/published}"

mkdir -p "${PUBLISHED}"

index="${PUBLISHED}/_publish-index.md"
{
  echo "# Foundation Stack — published mirror"
  echo ""
  echo "_Auto-generated. Do not edit articles here for deploy. Source: \`guanglab-foundation-stack/posts/\`_"
  echo ""
  echo "| Slug | Title | Date | URL |"
  echo "|------|-------|------|-----|"
} > "${index}"

shopt -s nullglob
for post in "${ROOT}"/posts/*/index.qmd; do
  slug="$(basename "$(dirname "${post}")")"
  dest="${PUBLISHED}/${slug}"
  mkdir -p "${dest}"
  cp "${post}" "${dest}/article.qmd"

  title="$(grep -E '^title:' "${post}" | head -1 | sed 's/^title: *"\(.*\)"$/\1/' | sed 's/^title: *//')"
  date="$(grep -E '^date:' "${post}" | head -1 | sed 's/^date: *"\(.*\)"$/\1/' | sed 's/^date: *//')"
  url="https://fs.guanglab.org/posts/${slug}/"
  echo "| ${slug} | ${title} | ${date} | [live](${url}) |" >> "${index}"
done

for dir in "${PUBLISHED}"/*/; do
  [[ -d "${dir}" ]] || continue
  slug="$(basename "${dir}")"
  if [[ ! -f "${ROOT}/posts/${slug}/index.qmd" ]]; then
    rm -rf "${dir}"
    echo "  removed orphan mirror: ${slug}"
  fi
done

echo "✓ Obsidian mirror → ${PUBLISHED}"
