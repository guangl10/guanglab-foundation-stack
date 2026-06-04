# Foundation Stack — Cursor / agent context

## Project

- **Site:** https://fs.guanglab.org/
- **Repo:** https://github.com/guangl10/guanglab-foundation-stack
- **Role:** Personal public 52-week series on adolescent PPCS aerobic exercise prescription (not ISU SR / not `projects.guanglab.org`).

## Boundaries

- Edit FS content only in this repository.
- **Never** link to `projects.guanglab.org` in published `.qmd` files.
- Canonical host: `fs.guanglab.org` (not `stack.guanglab.org` in prose).
- Public cross-links allowed: `guanglab.org`, `guanglab.org/ppcs-sr`, `guanglab.org/labs/`.

## Article template (every week)

Problem → comparison table → disagreements → methods → SOP → limitations.

YAML: `week`, `pillar` (`reproduce`|`methods`|`synth`|`sop`), `pmid_count`, `audience`, `date`, `title`, `description`.

## Deploy

```bash
quarto render   # optional
bash deploy.sh  # requires SSH host `alpha-x`
```

## New week

Copy `posts/2026-w01-adherence-reporting-gap/` → `posts/2026-wNN-<slug>/`, edit, deploy, bump progress on `index.qmd`.
