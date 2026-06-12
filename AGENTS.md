# Foundation Stack — Cursor / agent context

## Project

- **Site:** https://fs.guanglab.org/
- **Repo:** https://github.com/guangl10/guanglab-foundation-stack
- **Role:** Personal public series on adolescent PPCS aerobic exercise prescription (not ISU SR / not `projects.guanglab.org`).

## Boundaries

- Edit FS content only in this repository.
- **Never** link to `projects.guanglab.org` in published `.qmd` files.
- Canonical host: `fs.guanglab.org` (not `stack.guanglab.org` in prose).
- Public cross-links allowed on FS: `guanglab.org` (author home), `guanglab.org/labs/` (general labs hub only).
- **Until PROSPERO registration is public:** do **not** link from FS to `guanglab.org/ppcs-sr`, `guanglab.org/labs/data/ppcs-sr`, pilot measurement summaries, or any SR pilot audit material (`n = 63`, adherence/measurement gaps). Keep `resources/pilot-measurement-summary.qmd` at `draft: true`.
- **Do not** expose internal production cadence (e.g. “52 weeks”) on the public site.
- **Until PROSPERO registration is public:** do not preview specific upcoming FS topics in closings or teasers (no SR pilot themes such as adherence reporting gaps, measurement audits, or unpublished review findings). Use only: *“The next installment works through a different unresolved problem in the same literature.”*

## Article template (every installment)

Problem → comparison table → disagreements → methods → SOP → limitations.

YAML: `installment` (e.g. `pillar2-001`), `pillar` (`reproduce`|`methods`|`synth`|`sop`), `audience`, `date`, `title`, `description`.

Folder naming: `posts/pillar{N}-{seq}-{slug}/` (e.g. `pillar2-001-six-protocols-comparison`).

| Pillar # | Code | Prefix |
|----------|------|--------|
| 1 | `reproduce` | `pillar1-` |
| 2 | `methods` | `pillar2-` |
| 3 | `synth` | `pillar3-` |
| 4 | `sop` | `pillar4-` |

## SEO (automatic)

Posts under `posts/` get Google Scholar meta, JSON-LD (`ScholarlyArticle`), and canonical URLs via `filters/fs-seo.lua` (`fs-seo.canonical-base` in `_quarto.yml`). Defaults for `description` in `posts/_metadata.yml`.

## Drafts

`website.draft-mode: gone` in `_quarto.yml`. Unpublished work: `draft: true` in YAML or do not create the post directory until ready.

## Obsidian (MyVault) — structured archive

Hub: `.../research/foundation-stack/README.md`  
Workflow: `.../research/foundation-stack/WORKFLOW.md`  
Registry: `.../research/foundation-stack/_installments.md` (update on every publish)

| Stage | Path |
|-------|------|
| Ideas | `_idea-pool.md` |
| Evidence | `research-notes/<topic>.md` |
| Brief + draft | `drafts/pillar{N}-{seq}/` |
| Mirror (sync only) | `published/<slug>/article.qmd` |

Promote draft → `posts/pillar{N}-{seq}-{slug}/index.qmd`, deploy, sync, update `_installments.md`.

**Obsidian autosync (laptop):** MyVault `_system/auto-sync.sh` every 10 min → `jack-myvault` Git. Author drafts in Obsidian; agent reads same paths after pull on mini or from GitHub.

After **successful deploy**, sync mirror:

```bash
bash sync-to-obsidian.sh
```

## Deploy

```bash
quarto render   # optional
bash deploy.sh  # requires SSH host `alpha-x`
```

## New installment

Copy `posts/pillar2-001-six-protocols-comparison/` → `posts/pillar{N}-{seq}-{slug}/`, edit, deploy.
