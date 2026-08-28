---
name: explain-project
description: Use when someone asks to understand a software project — "explain the project", "how does X work", "what is <term>", "walk me through the architecture / db design / domain / data model", "onboard me", "give me an overview", or invokes /explain-project. For engineers, QA, and client-side technical readers. Wiki-aware, falls back to README/commit-history/markdown.
---

# Explain Project

## Overview

Explains any part of a software project — glossary, domain, architecture, DB/data model, dev setup, decisions — to a mixed technical audience (engineers, QA, client-side tech). Read-only on existing files. Answers are **routed** to authoritative sources first, then verified against live code, with citations so the reader can dig deeper.

**Core principle:** route to the best existing source before re-deriving anything from raw code. A curated wiki, when present, is faster and more authoritative than re-reading the codebase every time — but always flag whether an answer came from docs (may lag) or live code.

## When to Use

- "Explain the project / this module / the db design / the domain"
- "What is `<term>`?" (glossary lookups)
- "How does `<subsystem>` work?" (architecture, caching, auth, query engine…)
- "Onboard me" / "give me a tour" / "overview"
- Bare `/explain-project` with no question → show the menu

**Not for:** writing or changing code, updating the wiki, or generating implementation plans. This skill only reads and explains.

## Workflow

### 1. Build the routing map (once per session, then reuse)

Discover topic → source mappings in this order. Stop at the first tier that yields a usable map; record which tier you used so you can flag confidence.

1. **`CLAUDE.md` Quick Reference table** — topic → wiki-path pairs. Cheapest, most authoritative.
2. **`wiki/index.md`** (or any `docs/index.md`) catalog.
3. **Fallback** (no wiki): `README*` → `**/*.md` glob → `git log --oneline -n 50` + targeted code grep.

### 2. If no specific question → print the menu

Build it from what discovery actually found — do not show topics that have no source. Default set:

```
1) Overview            7) Frontend
2) Domain / glossary   8) Data model / DB
3) Backend architecture 9) Insights / pipelines
4) Query engine        10) Dev setup
5) Caching             11) Decisions (ADRs)
6) Auth / RBAC         12) Free-form question
```

Mark any item whose only source is code as `(from code)`. Then wait for the pick.

### 3. Answer

- **Route** the question to its mapped source. Read that source (targeted — relevant sections, not the whole file).
- **Verify** load-bearing claims (table names, grains, flags, defaults) against live code/DDL/seed when the answer is technical. Docs drift; code is ground truth.
- **Cite always** — wiki page path and/or `file:line`. The reader must be able to verify and go deeper. Do not drop citations from the final output.
- **Depth adaptive** — lead with a TL;DR + key points for the mixed audience, then offer "want the deep dive?". Deep dive = read the full source, cite precisely.
- **Diagram** — render a mermaid diagram inline when explaining a flow, sequence, schema/ER relationship, or component layout. A star schema, a request lifecycle, or an auth handshake is clearer drawn than prosed.
- **Staleness honesty** — every answer states its source basis: "per wiki (may lag code)" or "from live code". If wiki and code disagree, say so and trust the code.

### 4. Escalate only when needed (tier C)

If a question spans many files or the routing map has no source for it, dispatch an `Explore` (or general-purpose) subagent to gather a digest, then fold it into your cited answer. **Announce** when you escalate so the reader knows the answer was assembled live.

### 5. Saving (only on explicit request)

If — and only if — the user asks to save the explanation, **ask them for the destination path** (offer a suggestion, wait for confirmation), then write a new file there. Never write unless asked.

## Read-Only Guarantee

This skill **never modifies any pre-existing file** — not `wiki/`, not code, not docs. No wiki ingest, no edits. The only write it ever performs is creating a *new* explainer file at a path the user explicitly chose in step 5. This prevents wiki drift and accidental edits.

## Quick Reference

| Situation | Do this |
|---|---|
| Bare invocation, no question | Build map → print menu → wait |
| "What is `<term>`?" | Route to glossary; one-line answer + cite |
| Technical "how does X work?" | Route → read → **verify against code** → cite + mermaid |
| Wiki page missing for topic | Fallback chain; mark answer `(from code)` |
| Question spans many files | Escalate to subagent; announce it |
| User says "save this" | Ask for path, then write new file only |
| Wiki contradicts code | Report both; trust code; note the divergence |

## Common Mistakes

- **Dropping citations from the final answer** because the audience is "non-navigational." Always include them — QA and client-tech readers need to verify.
- **Re-deriving from raw code when a wiki page exists.** Route first. Reading a 1000-line file to answer a glossary question wastes context.
- **Trusting the wiki blindly.** Docs lag code. Verify table names, grains, and defaults against DDL/seed before stating them as fact.
- **Skipping the staleness note.** The reader can't judge an answer without knowing if it's from docs or code.
- **No diagram for structural questions.** Schema relationships and flows are clearer drawn.
- **Writing files without being asked**, or writing to a hardcoded directory. Saving is opt-in and the path is the user's choice.
