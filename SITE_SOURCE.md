# Foundation Stack — site source map

**Canonical edit target:** this repository only. Obsidian `published/` is a read-only mirror after deploy.

| What | Where |
|------|--------|
| Local repo (Mac) | `~/Documents/guanglab-foundation-stack` |
| GitHub | https://github.com/guangl10/guanglab-foundation-stack |
| Live site | https://fs.guanglab.org/ |
| Oracle static HTML | `alpha-x:/home/ubuntu/projects/guanglab/foundation-stack/_site/` |
| Nginx `root` | same `_site/` path |
| Deploy | rsync changed `posts/**/index.qmd` to alpha-x → `ssh alpha-x` → `quarto render` **on alpha-x itself** (no local Quarto install; `deploy.sh`'s "render locally then rsync `_site/`" is stale, do not follow it) → `bash fix-sitemap.sh` on alpha-x (normalizes `sitemap.xml` to match canonical URLs — Quarto's own sitemap generator uses `.../index.html`, every page's canonical tag uses `.../`; skipping this step reintroduces the Search Console "duplicate, no canonical" warning) |

## Posts layout (publish repo)

```
posts/pillar{N}-{seq}-{slug}/index.qmd   # e.g. pillar2-001-six-protocols-comparison
```

## Obsidian mirror (read-only)

| What | Where |
|------|--------|
| Obsidian hub | `~/Documents/Obsidian/MyVault/research/foundation-stack/README.md` |
| Workflow + registry | `.../WORKFLOW.md` · `.../_installments.md` · `.../_writing-plan.md` · `.../_DOCUMENT-MAP.md` · `.../_tools.md` |
| Drafts / research | `.../drafts/` · `.../research-notes/` |
| Mirrored articles | `.../published/<slug>/article.qmd` |
| Auto index | `.../published/_publish-index.md` (sync script) |

After each successful deploy:

```bash
bash sync-to-obsidian.sh
# or: FS_SYNC_OBSIDIAN=1 bash deploy.sh   # if wired in deploy
```

**Do not** edit `article.qmd` in Obsidian and treat it as the publish source.

**English-only publish:** Obsidian drafts may include inline Chinese glosses in parentheses; Git `posts/**/index.qmd` must not contain CJK. Promote with `sync-draft-to-git.sh` (strips glosses). `deploy.sh` runs `scripts/verify-publish-english.sh` before render.

## Do not use

- `bjsm_PPCS_SR/guanglab/foundation-stack/` (removed; SR repo only)
- `guanglab-quarto/foundation-stack/` (never existed; `guanglab.org/foundation-stack/*` → 301 → fs)

See also: root `AGENTS.md`, Obsidian `research/foundation-stack/README.md`.
