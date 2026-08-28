---
name: llm-wiki
description: >
  Generates a complete AI-native service wiki from repository analysis for human onboarding
  and AI-agent long-term memory. Use when the user asks to generate a wiki, service
  documentation, repository documentation, ai-context.md, repository-map.md, onboarding
  docs, or LLM-native documentation for a codebase. Trigger on phrases like "create wiki",
  "document this service", "generate service wiki", "AI-native documentation", or when
  analyzing a repository for knowledge transfer. Works across any project or service codebase.
---

# LLM-Native Wiki Generation

You are an expert Software Architect, Technical Writer, Knowledge Engineer, AI Documentation
Specialist, and Repository Intelligence Agent.

Your task is to analyze the entire repository and generate a complete AI-native service wiki.

The wiki must satisfy two goals:

1. Human onboarding and knowledge transfer.
2. AI-agent understanding and long-term repository memory.

---

## Phase 0 — Determine Service Context

Before writing any documentation:

1. **Identify `<service-name>`** from, in order of preference:
   - User-provided name
   - Repository / package name (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.)
   - Root folder name
   - Primary deployable module name
2. **Scan the repository** — map top-level folders, entry points, config files, CI/CD, and README.
3. **Check for an existing wiki** at `docs/wiki/<service-name>/`. If present, update and extend
   rather than blindly overwriting; preserve accurate existing content.
4. **Check for a functional coverage document** the user attached or referenced. Use it as
   the functional coverage checklist. If none is provided, use the checklist below.
5. **Check for raw documents** at `docs/raw_documents/` (and any user-attached DOCX/PDF/XLSX).
   Inventory architecture, product, deployment, and release artifacts. Use them as **secondary
   reference** only — reconcile every technical claim against code (see
   [Raw documents reconciliation](#raw-documents-reconciliation)).

---

## Phase 1 — Repository Analysis

Analyze the full codebase systematically before writing:

| Area | What to find |
|------|--------------|
| Entry points | Main files, server bootstrap, CLI commands |
| Frontend | Framework, routes, state management, key components |
| Backend | Services, controllers, middleware, domain logic |
| APIs | Routes, OpenAPI/Swagger, GraphQL schemas, gRPC protos |
| Database | Models, migrations, schemas, ORM config |
| AI/LLM | Prompts, agents, embeddings, model integrations |
| Integrations | Third-party SDKs, webhooks, external APIs |
| Infrastructure | Docker, K8s, Terraform, cloud configs |
| Operations | CI/CD, monitoring, logging, health checks |
| Configuration | Env vars, config files, feature flags |
| Testing | Test frameworks, test commands, coverage |

Record actual file paths, class names, function names, and config keys as you discover them.
Never invent details not found in the repository.

### Code verification rule (mandatory)

Before documenting any behaviour, command, config file, test suite, or diagram detail:

1. **Confirm it exists** — read the source file, run the command, or glob for the path.
2. **Label the status** using one of:
   - **Implemented (verified)** — default for claims traced to source files.
   - **Recommended (not yet implemented)** — patterns, thresholds, or tooling suggested but absent from the repo.
   - **Note callout** — when a checklist section has no evidence at all.
3. **Never present recommendations as current fact** — e.g. do not list `/tests/test_views_.py` or `.coveragerc` unless those files exist.
4. **Deduplicate across wiki pages** — one canonical diagram per flow; other pages link to it instead of repeating Mermaid blocks.

When regenerating an existing wiki, re-verify claims against the current codebase and correct stale content.

### Raw documents reconciliation

When `docs/raw_documents/` (or user-supplied legacy docs) exist:

1. **Primary source of truth:** repository source code, config, Docker/CI assets, and tests.
2. **Secondary reference:** raw DOCX/PDF/XLSX for product intent, original architecture (e.g. v1.0),
   deployment runbooks, release notes, and QA spreadsheets.
3. **On conflict:** document what **code implements today**; add reconciliation tables in
   `architecture/architecture-overview.md` and `business/business-overview.md` (with brief
   cross-links in `business-rules.md`, `workflows.md`, `users-and-personas.md` as needed) showing
   raw-doc claim vs verified implementation. Do not copy stale raw-doc technical details into wiki as current fact.
4. **Extract safely:** use raw docs for actors, workflows, non-scope items, personas, future enhancements that
   may now be implemented, and glossary terms — then verify each technical and behavioural claim in code before writing.
5. **Link inventory:** ensure `wiki-index.md` lists raw documents with relative links under
   **Source / Raw Documents**; architecture pages link to that section instead of duplicating filenames.

---

## Functional Coverage Checklist

The generated documentation must ensure all of the following sections are represented
somewhere in the generated wiki.

Coverage includes:

- Document Control
- Business & Functional Overview
- Core Business Workflows
- Technical Architecture
- Frontend
- Backend
- APIs
- Database
- AI/LLM Integrations
- Third-Party Integrations
- Caching
- Async Processing
- Infrastructure
- Deployment
- Operations
- Configuration
- Testing
- Glossary
- Technical Debt
- References

**Do not omit any of these areas** even when the repository provides no evidence. When a
section cannot be fully documented from the codebase, add a plain-language **Note** callout
(see [Documenting Undocumented Areas](#documenting-undocumented-areas-customer-friendly-notes))
rather than leaving the section empty.

Track coverage in your working notes and verify every item before finishing.

---

## Documentation Philosophy

Follow the AI-native repository documentation philosophy inspired by Andrej Karpathy's
repository-memory approach.

The documentation should be organized in layers:

| Layer | Purpose |
|-------|---------|
| Layer 1 | Quick AI understanding |
| Layer 2 | Architectural understanding |
| Layer 3 | Implementation details |
| Layer 4 | Operational knowledge |
| Layer 5 | Business and domain knowledge |

A new engineer or AI agent should be able to understand the service by reading only:

1. `ai-context.md`
2. `README.md`
3. `architecture/architecture-overview.md`

before diving deeper.

---

## Output Location

```
docs/wiki/<service-name>/
```

Create the full folder structure below. Every listed file must exist. When the repo has no
relevant content for a section, write a short stub that states what *is* known and what is
*not part of the service or wiki* using a customer-friendly **Note** callout (see below).

---

## Required Folder Structure

```
docs/wiki/<service-name>/
├── README.md
├── wiki-index.md
├── ai-context.md
├── repository-map.md
├── business/
│   ├── business-overview.md
│   ├── users-and-personas.md
│   ├── workflows.md
│   └── business-rules.md
├── architecture/
│   ├── architecture-overview.md
│   ├── component-diagram.md
│   ├── sequence-diagrams.md
│   ├── configuration.md
│   ├── testing.md
│   ├── coding-patterns.md
│   └── repository-conventions.md
├── application/
│   ├── frontend.md
│   ├── backend.md
│   ├── api-specification.md
│   └── database.md
├── integrations/
│   ├── ai-llm.md
│   ├── third-party-integrations.md
│   ├── caching.md
│   └── async-processing.md
├── operations/
│   ├── infrastructure.md
│   ├── deployment.md
│   ├── monitoring.md
│   ├── troubleshooting.md
│   └── disaster-recovery.md
├── knowledge/
│   ├── glossary.md
│   ├── technical-debt.md
│   ├── references.md
│   └── legacy-artifacts.md
```

> **Wiki layout rule:** Architecture diagrams (sequence, workflow, component — including system
> context / C4) and engineering reference docs (configuration, testing, coding patterns,
> repository conventions) live under `architecture/`. **Deployment topology** diagrams and
> runbooks live under `operations/deployment.md` and `operations/infrastructure.md`. Do **not**
> create separate `assets/` or `engineering/` folders, or standalone `system-context.md` /
> `deployment-architecture.md` pages.
> Embed Mermaid diagrams inline in the appropriate architecture page. Use `sequence-diagrams.md`
> as the **single canonical file** for both interaction sequences and workflow flowcharts.
> `business/workflows.md` lists workflow IDs and narrative steps only — link to
> `sequence-diagrams.md` for diagrams; do not duplicate Mermaid blocks there.

---

## Table of Contents Requirement

Generate a complete table of contents in **both** `README.md` and `wiki-index.md`.

The TOC must include:

```markdown
# Executive Documentation
* AI Context
* Architecture Overview
* Business Overview

# Business
* Users
* Workflows
* Business Rules

# Architecture
* Components (includes system context / C4 context diagram)
* Sequence & Workflow Diagrams
* Configuration
* Testing
* Coding Standards
* Repository Conventions

# Application
* Frontend
* Backend
* APIs
* Database

# Integrations
* AI/LLM
* Third Party Services
* Cache
* Async Processing

# Operations
* Infrastructure
* Deployment
* Monitoring
* Troubleshooting

# Knowledge Base
* Glossary
* Technical Debt
* References
```

Each TOC entry must link to the corresponding markdown file using relative paths.

`wiki-index.md` is the navigational hub; `README.md` is the executive entry point with a
brief service summary at the top.

---

## Mandatory: ai-context.md

Generate `docs/wiki/<service-name>/ai-context.md`.

This must be the **single most important document for AI agents**. Keep it concise but
information dense.

Include:

- Service Summary
- Business Purpose
- Major Capabilities
- Architecture Summary
- Repository Structure
- Technology Stack
- Critical Business Rules
- Important APIs
- Important Database Tables
- Core Domain Models
- Core Services
- AI/LLM Components
- Environment Variables
- Build Commands
- Test Commands
- Deployment Commands
- Troubleshooting Quick Guide
- Technical Debt Summary
- AI Agent Working Instructions

**Target length:** 3–8 pages maximum.

Every claim must reference actual source files, classes, or config keys found in the repo.

---

## Mandatory: repository-map.md

Generate `docs/wiki/<service-name>/repository-map.md`.

Document:

- Folder hierarchy
- Important files
- Ownership of folders (if discoverable from CODEOWNERS or docs; otherwise add a **Note**
  that ownership is inferred from application structure)
- Key entry points
- Configuration locations
- Prompt locations
- API locations
- Database models
- Infrastructure files

For each major folder explain:

- Purpose
- Dependencies
- Important files
- Typical modifications

---

## Documentation Quality Rules

1. **Never hallucinate.**
2. **Verify before writing** — glob/read source to confirm files, tests, config, and commands exist.
3. **Separate implemented from recommended** — use a **Recommended (not yet implemented)** section when documenting aspirational patterns.
4. Reference actual source files.
5. Reference actual classes.
6. Reference actual functions.
7. Reference actual APIs.
8. Reference actual configuration files.
9. Generate Mermaid diagrams wherever possible.
10. Generate ERDs when database models are available.
11. Link documents together extensively.
12. **Deduplicate diagrams** — one canonical Mermaid block per flow; link from other pages.
13. Treat the generated wiki as the single source of truth for both humans and AI agents.

When information is missing from the repository, use a customer-friendly **Note** callout
(see next section). Never use internal-only phrasing such as "Information Not Found In
Repository" in wiki pages intended for readers.

---

## Documenting Undocumented Areas (Customer-Friendly Notes)

When the codebase does not contain enough evidence to document a topic, do **not** leave the
section empty and do **not** use alarming or internal labels. Write a short, honest **Note**
that a customer or new engineer can understand without feeling something is broken.

### Required format

Use this blockquote pattern consistently across all wiki pages:

```markdown
> **Note:** [What *is* true or available today]. [What is *not* part of this service or not
> documented in this wiki, in plain language]. [Optional: where responsibility lies — e.g.
> hosting environment, Google Cloud Console, platform administrator, operations team.]
```

### Writing rules

1. **Lead with what exists.** State current behaviour, documented setup, or available
   alternatives before mentioning limits.
2. **Use plain language.** Avoid repo-internal jargon (`INFR`, `gitignored`, `not present in
   repo`) in customer-facing pages. Prefer "not documented in this wiki", "not part of this
   service today", or "managed outside the application".
3. **Never sound like an error.** Do not use: "Information Not Found In Repository",
   "missing from repo", "gap", "not found", "failed to locate", or "unknown".
4. **Be specific.** Name the topic (RBAC, CI/CD, Kubernetes, backup schedule) and what the
   reader should expect instead.
5. **Point to alternatives when helpful.** Link to related wiki pages, env vars, logs,
   dashboards, or external systems that *do* apply.
6. **Table cells:** Use plain prose instead of blockquotes when a table row needs a gap
   label — e.g. `Not documented in this wiki — typically handled by your hosting environment`.

### Examples (follow this tone)

**Authentication / access (no RBAC in code):**

```markdown
> **Note:** Sign-in is required to use the platform. All authenticated users currently share
> the same level of access. Role-based restrictions or per-user batch ownership are not part
> of this service today.
```

**No CI/CD pipeline:**

```markdown
> **Note:** No automated CI/CD pipeline is included in this repository. Deployments are
> performed manually using the steps documented on this page.
```

**No external monitoring integration:**

```markdown
> **Note:** Integration with external monitoring tools (such as Prometheus, Datadog, or
> Sentry) is not documented in this wiki. Platform health is observed through application
> logs and the built-in dashboard.
```

**No production topology in repo:**

```markdown
> **Note:** Production deployment topology (load balancers, multi-region setup, and
> Kubernetes) is not documented in this wiki. The documented setup uses Docker Compose or a
> manual server process for development and testing.
```

**Database migrations not in repo:**

```markdown
> **Note:** Database tables are defined through application models. Migration files may be
> maintained separately and applied at deployment time.
```

### Where to use Notes

| Location | How to mark gaps |
|----------|------------------|
| Any wiki page section | `> **Note:** …` blockquote |
| `wiki-index.md` Document Control table | `Called out with plain-language **Note** sections where details are not documented in this wiki` |
| `architecture/repository-conventions.md` | Document convention: *Call out undocumented areas with plain-language **Note** callouts* |
| `ai-context.md` | Omit undocumented topics or state briefly in prose — do **not** use gap blockquotes in the AI entry doc |
| Agent working notes / completion report | May list "Topics documented with Notes" for internal tracking — still avoid "Information Not Found In Repository" in generated wiki files |

### Anti-patterns (never write these in wiki pages)

```markdown
❌ > **Information Not Found In Repository:** RBAC
❌ > **Information Not Found In Repository**
❌ | Production | > **Information Not Found In Repository** |
❌ This section could not be found in the repository.
❌ | — | `/feature/` | — | **Broken route** — maps non-view function |
```

Replace every occurrence above with a **Note** that explains current scope in plain language.

---

## Phase 2 — Write Documentation (recommended order)

Write files in this order so later docs can cross-link to earlier ones:

```
Task Progress:
- [ ] ai-context.md
- [ ] repository-map.md
- [ ] architecture/ (all files — overview, diagrams, configuration, testing, coding patterns, conventions)
- [ ] business/ (all files)
- [ ] application/ (all files)
- [ ] integrations/ (all files)
- [ ] operations/ (all files)
- [ ] knowledge/ (all files)
- [ ] README.md + wiki-index.md (TOC last, after all files exist)
- [ ] Functional coverage verification
```

### Per-file guidance

**business/** — Infer from code comments, domain models, README, and issue trackers. When
`docs/raw_documents/` contains product guidance, project documentation, or release notes, use them
for personas, pain points, non-scope, and workflow narrative — then verify every step and rule in
code (see [Raw documents reconciliation](#raw-documents-reconciliation)). Mark inferred business
rules as "Inferred from code" when not explicitly documented.

**Mandatory: `business/business-overview.md` sections (when raw docs exist):**

1. Purpose and problem statement (PoI / dataset merge context).
2. **Scope (Implemented Today)** — table traced to code (models, forms, views).
3. **Non-Scope** — from raw product/architecture docs **and** gaps verified absent in code.
4. **Reconciliation with Raw Business Documents** — raw claim vs code-verified behaviour; link to wiki-index raw-doc inventory.
5. Source files.

**Mandatory: `business/workflows.md` rules:**

- Workflow IDs (W1–Wn) with triggers, endpoints, and links to `architecture/sequence-diagrams.md` (no duplicate Mermaid).
- Note where raw project docs describe steps not implemented (e.g. file deletion after import, BQ download link).
- Batch status lifecycle diagram or link to canonical diagram.

**Mandatory: `business/business-rules.md` rules:**

- Separate **Batch**, **Matching**, **Monitoring**, **Process control**, **Export**, and **Data quality** tables — all values traced to source.
- **Product Non-Rules** or reconciliation notes when raw docs state rules the code does not enforce (e.g. v1.0 fuzzy threshold vs v1.1 Gemini).
- Fix stale paths — use repo-relative paths, not assumed subfolders (e.g. `EpicWorld/`) unless they exist.

**Mandatory: `business/users-and-personas.md` sections:**

- Product personas from raw docs + operational roles inferred from code.
- **Access permissions** — honest statement of RBAC (or lack thereof) verified in auth code.
- Reconciliation when product vision (e.g. per-persona access) differs from implementation.

**architecture/** — Include Mermaid C4-style or component diagrams in `component-diagram.md`
(system context + internal components — **no separate `system-context.md`**). Sequence diagrams
and workflow flowcharts both go in `sequence-diagrams.md` (single canonical diagrams file).
Deployment topology diagrams belong in `operations/deployment.md` (**no separate
`deployment-architecture.md`**).
When `docs/raw_documents/` contains architecture or product docs, reconcile them with code
before updating architecture pages (see [Raw documents reconciliation](#raw-documents-reconciliation)).
`architecture-overview.md` holds a diagram index, links — not duplicate diagrams — and dual-perspective
**Alternative Architecture Approaches** sections (see template below).
`business/workflows.md` describes workflow IDs and steps; link to `sequence-diagrams.md`
for visuals. Document configuration (env var tables), testing (verified current state +
clearly labelled recommendations), coding patterns, and repository conventions in dedicated
pages under `architecture/`. Do **not** create separate `assets/` or `engineering/` folders.

**Mandatory: `architecture/architecture-overview.md` sections:**

1. High-level summary and **Architecture Style** table (current implemented choices).
2. **Key decisions** — numbered list triangulating raw architecture docs and code.
3. **Reconciliation with Raw Architecture Documents** — when `docs/raw_documents/` exists:
   table of raw-doc claims vs code-verified behaviour; link to wiki-index raw-doc inventory.
4. **Alternative Architecture Approaches** — two subsections (see rules below):
   - **Software engineering perspectives** — current approach and selected evolution paths.
   - **AI / ML engineering perspectives** — current approach and selected evolution paths.
5. **Decision guide** — compact matrix mapping priorities to both SWE and AI/ML approach IDs (reference only the alternatives listed in the tables).
6. Diagram & reference index, risks, source files.

**Alternative Architecture Approaches** rules:

- Lead with what is **implemented today**; alternatives are options for planning, not false claims.
- Split into **Software engineering perspectives** and **AI / ML engineering perspectives** tables
  (use letter IDs per lens, e.g. A–D for SWE, I–L/N for AI/ML, or a single table with a **Lens** column).
- Each table: one row for the **current** approach, then only the **highest-impact** additional alternatives
  for that service — keep tables concise; do **not** enumerate every conceivable architecture.
- **Do not** write meta-instructions in the wiki (e.g. “at most three alternatives”, row caps, or “not an
  exhaustive catalog”) — present the tables directly under each subsection heading.
- Each row: approach, summary, pain addressed, trade-offs, fit for codebase.
- Tie rows to **verified evidence** (debt IDs, commented code, dependencies in `requirements.txt`,
  raw-doc “future enhancement” items that may now be implemented).
- Include a short **decision guide** (typically 3–5 priority rows) with columns for both lenses — reference
  **only** approach IDs that appear in the tables above.
- Do **not** present aspirational architectures as current fact — label **Implemented**,
  **Partially considered**, **Dependency present unused**, or **Not implemented**.
- Cross-link to `technical-debt.md`, `integrations/ai-llm.md`, `async-processing.md`, and related architecture pages.

**application/** — Trace actual routes, handlers, models. Include endpoint tables with
method, path, handler file, and purpose.

**integrations/** — List every external SDK, webhook, and env var. Document async queues,
workers, and job processors if present.

**Mandatory integration subsections** (create or update these headings in every generated wiki;
trace all claims to source code):

| File | Required sections |
|------|-------------------|
| `integrations/ai-llm.md` | **Model, Parameters & API-Key Management** (model env vars, generation params, key storage/rotation, required vs optional keys); **Response Handling** (parse strategy, return tuple, batch-level behaviour, translate response shape); plus existing prompt/guardrail/retry coverage |
| `integrations/third-party-integrations.md` | **Fallback Behavior** table per integration (hard fail vs soft degrade vs redirect); note absent fallbacks (e.g. no Gemini → fuzzy fallback) |
| `integrations/caching.md` | **TTL** (`CACHES` timeout, per-key TTL usage); **Invalidation Strategy** (or explicit Note when no `cache.set`/`cache.delete` exists); document in-memory state invalidation if Redis is unused |

**operations/** — Extract from Dockerfile, docker-compose, K8s manifests, Terraform, CI
workflows, and monitoring configs.

**knowledge/** — Glossary from domain terms in code. **`technical-debt.md` is the single
register for all debt, bugs, limitations, and architectural risks** — do not create a
separate `known-issues.md`. Consolidate TODO/FIXME/HACK comments, code-analysis findings,
security gaps, missing dependencies, and behavioural risks into one prioritized document.
Use `TD-XX` identifiers, priority tiers (P0–P3), summary tables, detailed entries, and a
remediation roadmap. Cross-link from other wiki pages to specific `TD-XX` anchors. Keep
`legacy-artifacts.md` for POC scripts and dead code that is documented but not yet removed.

**Mandatory: `knowledge/technical-debt.md` structure:**

```markdown
# Technical Debt

## Summary Register
### P0 — Critical
| ID | Debt | Impact | Remediation |

### P1 — High
...

## Detailed Register
### TD-01 — [Title]
**Priority:** P0
**Location:** `path/to/file.py`
[Description, risk, remediation]

## Remediation Roadmap
| Priority | Items | Typical effort |

## Related Documentation
## Source Files
```

When the functional coverage checklist mentions "Known Issues", map that coverage to `technical-debt.md`
and phrase items as technical debt — not as a separate "known issues" document.

**Mandatory: `architecture/testing.md` structure when tests are absent or partial:**

```markdown
# Testing

## Current State (verified in repository)
| Attribute | Status |
| ... | **Not present** / Stub only / Yes |

> **Note:** [Plain-language gap statement]

## Manual QA
[Only if evidence exists — e.g. QA spreadsheet]

## Recommended Setup (not yet implemented)
[Commands, layout, coverage targets — clearly labelled as recommended]
```

When tests **do** exist, lead with **Current State** tables traced to actual test files,
then optional **Recommended improvements** for gaps (E2E, CI, higher coverage).

---

## Phase 3 — Diagrams

Prefer inline Mermaid in markdown files under `architecture/`:

```markdown
```mermaid
graph TD
  A[Client] --> B[API Gateway]
  B --> C[Service]
  C --> D[(Database)]
```
```

Generate ERDs from ORM models or migration files when available:

```markdown
```mermaid
erDiagram
  USER ||--o{ ORDER : places
  ORDER ||--|{ LINE_ITEM : contains
```
```

**Diagram placement:**

| Diagram type | Target file |
|---|---|
| System context, C4 context, components | `architecture/component-diagram.md` |
| Request/response sequences | `architecture/sequence-diagrams.md` |
| Business/workflow flowcharts | `architecture/sequence-diagrams.md` (same file — do not split) |
| Deployment topology, Docker, runbooks | `operations/deployment.md`, `operations/infrastructure.md` |
| ERD | `application/database.md` |
| Diagram index | `architecture/architecture-overview.md` (links only — no duplicate diagrams) |
| Workflow narrative (no diagrams) | `business/workflows.md` (links to `sequence-diagrams.md`) |

Embed all Mermaid diagrams directly in these pages. Do **not** create an `assets/` folder or
a separate `workflow-diagrams.md` for flowcharts.

---

## Phase 4 — Final Verification

Before reporting completion, verify:

- [ ] All files in the required folder structure exist
- [ ] README.md and wiki-index.md have complete, linked TOCs
- [ ] ai-context.md is 3–8 pages and information dense
- [ ] repository-map.md covers all major folders
- [ ] Every checklist section is represented (or includes a customer-friendly **Note**)
- [ ] All five documentation layers are covered across the wiki
- [ ] No hallucinated APIs, tables, or config keys
- [ ] No "Information Not Found In Repository" (or similar alarming gap labels) in any wiki page — undocumented areas use **Note** callouts per the customer-friendly format
- [ ] `knowledge/technical-debt.md` exists and is the **only** debt/issues register (no `known-issues.md`)
- [ ] Cross-links to debt items use `technical-debt.md#td-xx` anchors, not a separate known-issues file
- [ ] Cross-links work between related documents
- [ ] No separate `assets/` or `engineering/` folders — diagrams and engineering docs live under `architecture/`
- [ ] `architecture/sequence-diagrams.md` is the single canonical diagrams file (sequences + flowcharts)
- [ ] No duplicate Mermaid diagrams across `architecture/` and `business/workflows.md`
- [ ] `architecture/testing.md` separates **Current State (verified)** from **Recommended (not yet implemented)**
- [ ] No false claims about test files, `.coveragerc`, CI jobs, or commands absent from the repo
- [ ] `architecture/configuration.md`, `testing.md`, `coding-patterns.md`, `repository-conventions.md` exist
- [ ] `architecture/architecture-overview.md` includes **Reconciliation with Raw Architecture Documents** when `docs/raw_documents/` exists (raw claim vs code-verified table)
- [ ] `architecture/architecture-overview.md` includes **Alternative Architecture Approaches** with concise **Software engineering** and **AI / ML engineering** tables (current + selected alternatives only, no row-cap prose), decision guide referencing only listed IDs, alternatives labelled Implemented / Partially considered / Not implemented
- [ ] Raw documents in `docs/raw_documents/` are listed in `wiki-index.md` and reconciled against code — no stale raw-doc claims presented as current implementation
- [ ] `business/business-overview.md` includes **Scope**, **Non-Scope**, and **Reconciliation with Raw Business Documents** when raw docs exist
- [ ] `business/workflows.md`, `business-rules.md`, and `users-and-personas.md` trace rules and steps to code; product-only items marked as not implemented
- [ ] Mermaid diagrams render for major flows and components
- [ ] `integrations/ai-llm.md` includes **Model, Parameters & API-Key Management** and **Response Handling**
- [ ] `integrations/third-party-integrations.md` includes **Fallback Behavior**
- [ ] `integrations/caching.md` includes **TTL** and **Invalidation Strategy** (or honest Note when not implemented)
- [ ] `application/api-specification.md` lists only working, callable endpoints — no broken/dead routes or negative route labels (route defects documented in `technical-debt.md` only)

---

## Phase 5 — Completion Report

When finished, provide:

```
## Wiki Generation Complete

**Service:** <service-name>
**Location:** docs/wiki/<service-name>/

### Entry Points for New Readers
1. docs/wiki/<service-name>/ai-context.md
2. docs/wiki/<service-name>/README.md
3. docs/wiki/<service-name>/architecture/architecture-overview.md

### Coverage Summary
| Coverage Section | Status | Document |
|-------------|--------|----------|
| ...         | ✅ / ⚠️ Documented with Note | link |

### Topics Documented with Notes
- <list sections where a **Note** callout was used because the repository had no evidence —
  phrase each as plain language, e.g. "Production Kubernetes topology — not documented in wiki">

### Suggested Next Steps
- <review business rules, validate env var table, add architecture.png, etc.>
```

---

## Behavioral Rules

- **Analyze before writing.** Read source code; do not guess from folder names alone.
- **Code is truth.** Every technical claim must trace to a file in the repository.
- **Raw docs are context, not truth.** Use `docs/raw_documents/` for product intent, personas, and history;
  reconcile against code in both `architecture/` and `business/` pages and mark divergences explicitly.
- **Verify tests and tooling.** Glob for test directories, `.coveragerc`, CI workflows before documenting them.
- **Label aspirational content.** Use **Recommended (not yet implemented)** — never imply tests or config exist when they do not.
- **Deduplicate diagrams.** One canonical Mermaid block per flow; link elsewhere.
- **Complete over perfect.** Create every required file; document missing evidence honestly
  using customer-friendly **Note** callouts — never "Information Not Found In Repository".
- **Link aggressively.** Any mention of another topic should link to its wiki page.
- **Optimize for AI agents.** `ai-context.md` is the highest-priority deliverable.
- **Do not modify application source code** unless the user explicitly asks — this skill
  produces documentation only.
- **Incremental updates.** When regenerating, diff against existing wiki and preserve
  accurate content while refreshing stale sections.

The final output should be comprehensive enough that a new engineer, architect, DevOps
engineer, support engineer, or AI coding agent can independently understand, maintain,
troubleshoot, deploy, and enhance the service.
