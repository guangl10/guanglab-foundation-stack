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

## Clinical tools (`tools/`)

- **URL:** `https://fs.guanglab.org/tools/{slug}/` (e.g. `hr-calculator`)
- **Role:** Standalone calculators/checklists; **never embed** widgets inside `posts/*.qmd`
- **Linking:** Installments may link out in one sentence; tools link back to motivating installment
- **SEO:** `fs-seo.lua` applies to `posts/` only—not tools
- **Shared data:** `tools/_shared/` (e.g. `hrmax-bands.json` synced with pillar2-002 Figure 2)
- **Registry:** Obsidian `_tools.md` (optional); hub at `tools/index.qmd`

### Do not merge with `projects.guanglab.org` / SR repo tools

On server (`alpha-x`), `isu/ppcs-sr-aerobic/_site/tools/` holds **SR extraction pipeline** utilities: Orchestrator (extraction schema), Literature Auditor (Gap 1/2 PDF extraction), Data Corrector (research CSV). These expose adherence/recovery coding schema and OpenRouter extraction workflow—**PROSPERO-confidential**. Public `https://projects.guanglab.org/tools/` currently returns **404** (good). Keep SR tools in the SR repo; keep FS clinical tools in this repo only. Never rsync or link SR tools onto `fs.guanglab.org`.

### PROSPERO gate (author decision: hide until registration is public)

**Keep public (FS only):** `fs.guanglab.org` installments + `fs.guanglab.org/tools/*` clinical helpers (e.g. `hr-calculator`). These are PMID/education-facing, not SR pipeline.

**Keep non-public until PROSPERO is live:**

- `projects.guanglab.org/tools/` — leave **404** or auth-only; do not nginx-route SR Orchestrator / Literature Auditor / Data Corrector.
- SR hub screening stats on `projects.guanglab.org` (e.g. records screened / stage counts) — treat as SR-facing; reduce or gate if still visible pre-PROSPERO.
- FS `resources/pilot-measurement-summary.qmd` — `draft: true`; no Hub links.

**After PROSPERO registration is public:** revisit exposing SR tools and hub on `projects.guanglab.org` (separate repo/nginx); still do not merge SR tools into FS. FS may then link to `guanglab.org/ppcs-sr` per updated public policy.

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

## RAG / knowledge base context (2026-06-16)

Jack wants this content searchable by his assistants. There are **two separate, unrelated RAG
systems** on his machine — don't conflate them:

1. **`qmd`** (coding-agent memory, used by Claude Code/Cursor for repo context) — embeds via
   node-llama-cpp + embeddinggemma. OOMs on Metal on his 24GB Mac mini. A CPU fallback exists
   (`NODE_LLAMA_CPP_GPU=disable`, plus an automatic retry-on-OOM already coded in
   `flowstate-qmd/src/llm.ts`) but latency hasn't been measured. Not yet wired to this repo.
2. **Open WebUI Knowledge** (`chat.guanglab.org`, jack/mae/aaliyah assistants) — embeds via
   Ollama + `nomic-embed-text`. Already deployed and confirmed live (no OOM risk). This is the
   one Jack most likely means when he says "knowledge base" for chat-facing use. Getting FS
   articles in there is a manual upload into the `jack-knowledge` collection in the Open WebUI
   UI — nothing in this repo needs to change for that to work.

Separately: **`projects.guanglab.org`** (the PPCS-SR proposal/meetings/plans site) is a different
project entirely, has no local source repo found yet, and is gated behind an SSO proxy that
returns 404 to unauthenticated requests. Not related to Foundation Stack.
