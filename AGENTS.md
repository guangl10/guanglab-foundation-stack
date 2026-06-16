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

## RAG / knowledge base context (2026-06-16, updated)

Jack wants this content searchable by his assistants. There are **two separate, unrelated RAG
systems** on his machine — don't conflate them:

1. **`qmd`** (coding-agent memory, used by Claude Code/Cursor for repo context) — **now live and
   working for this repo's `guanglab-fs` collection.** 334 chunks across 128 docs embedded.
   **Policy: no Chinese-origin models on this machine (Jack's explicit, durable rule — applies to
   any tool, not just qmd).** All three of qmd's Qwen-lineage models (embedding, reranker, and the
   query-expansion fine-tune) have been deleted from `~/.cache/qmd/models/`. Current config (set
   in `~/.zshrc`):
   - Embedding: `embeddinggemma-300M` (Google) via `QMD_EMBED_MODEL`
   - Reranker: `jina-reranker-v2-base-multilingual` (Jina AI, Germany) via `QMD_RERANK_MODEL` —
     not yet exercised end-to-end (only invoked when `rerank: true` or via `qmd query`)
   - Query-expansion (used only by the standalone `qmd query` command, never by the MCP/agent
     path): **no replacement configured** — this knob has no env var in `flowstate-qmd/src/llm.ts`
     (hardcoded `DEFAULT_GENERATE_MODEL`). Prefer `qmd vsearch` / `qmd search` over `qmd query` for
     now; if `qmd query` is run, expect it to try downloading a model.
   - On this 24GB Mac mini, embedding/search runs CPU-only (`NODE_LLAMA_CPP_GPU=disable`) to avoid
     Metal OOM — already the safe default; verified working at ~128 docs in ~2 min.
   - If models are ever swapped again: `qmd`'s vector table is **global, single-dimension**
     (`ensureVecTableInternal` in `flowstate-qmd/src/store.ts`) — changing the embedding model
     drops and rebuilds vectors for **all** collections, not just `guanglab-fs`. Re-embed with
     `qmd embed -f` (force flag, bypasses the hash-based "already has embeddings" skip-check).
   - Governance: don't run `qmd collection add` / `qmd embed` / `qmd update` automatically — give
     Jack the exact command and let him run it.
2. **Open WebUI Knowledge** (`chat.guanglab.org`, jack/mae/aaliyah assistants) — embeds via
   Ollama + `nomic-embed-text` (already non-Chinese). Already deployed and confirmed live (no OOM
   risk). This is the one Jack most likely means when he says "knowledge base" for chat-facing
   use. Getting FS articles in there is a manual upload into the `jack-knowledge` collection in
   the Open WebUI UI — nothing in this repo needs to change for that to work. Not yet done.

Separately: **`projects.guanglab.org`** (the PPCS-SR proposal/meetings/plans site) is a different
project entirely, has no local source repo found yet, and is gated behind an SSO proxy that
returns 404 to unauthenticated requests. Not related to Foundation Stack.
