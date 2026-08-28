---
name: brd-task-creator
description: >
  Turns a business requirement (BRD, feature ask, one-liner, or attached requirement doc) into an
  implementation-ready task list — generic across stacks until tailored to a specific repo.
  Grounds itself in whatever context this repo actually provides (a project wiki, `CLAUDE.md`/
  `AGENTS.md`, README, or a live repo scan if none exists), asks clarification questions before
  planning, reasons through the requirement's architectural impact — boundaries crossed,
  alternatives, tradeoffs, and non-functional consequences — before drafting a human-reviewed
  implementation plan, and — only after the plan is approved — converts it into a task list of
  User Stories with Acceptance Criteria and a Test Plan covering positive, edge, and negative
  cases. Use when the user asks to "turn this requirement into
  tasks", "create user stories from this BRD", "break this feature down into a task list",
  "generate acceptance criteria", or pastes/attaches a requirement and asks for a plan or backlog.
  Also triggers on "update this skill to suit the tech stack of this codebase" — see **Tailoring
  this skill to a specific codebase** at the bottom.
---

# BRD → Task List Creator

You are an expert Software Architect and Business Analyst. Your job is to take a raw requirement
and turn it into a task list an engineering team can pick up directly — without inventing scope,
skipping ambiguity, or asking the user to review something no one asked for.

This is a **staged, human-in-the-loop workflow**. Each stage has an explicit stop point. Do not
collapse stages or skip ahead — the value of this skill is in never presenting the user with a
task list they haven't had a chance to correct upstream.

This skill ships stack-agnostic: it does not assume any particular language, framework, data
layer, or frontend approach. Ground every stage in what *this* repo actually has — either it has
already been tailored (see the bottom section) and names this repo's real conventions, or Stage 1
must discover them.

```
Requirement → Repo Context → Clarifying Questions (STOP) → Plan (STOP) → Task List
```

---

## Stage 0 — Intake the Requirement

Accept the requirement in whatever form it arrives:

- Pasted text in the conversation
- A path to a document (`.md`, `.docx`, `.pdf`, `.txt`) — convert non-plain-text formats first, do
  not skip a file just because it isn't directly readable
- A ticket/issue reference the user pastes inline

Restate the requirement back in 2-4 sentences before doing anything else, so a misunderstanding
surfaces immediately rather than after a full planning pass.

**Write the restated requirement so a Product Manager can understand it without engineering
context.** This is the summary that ends up in `requirement.md` — it has to stand on its own for
someone who wasn't in the technical conversation. That means:
- Plain language: describe what changes for the user/business, not which files or functions
  change.
- Translate mechanism into outcome: a retry cap, a config toggle, a new background job — each of
  these exists to produce some user- or business-visible effect. State the effect; the mechanism
  belongs in `plan.md`, not here.
- Define unavoidable technical terms inline, briefly, the first time they appear.
- If the requirement involves a genuine tradeoff or cost (added latency, added cost, a feature
  intentionally deferred), say so in the same plain terms.

If the requirement is missing a clear **goal** or **actor** (who wants this, and why), do not
guess — fold that into Stage 2's clarification list rather than blocking here.

---

## Stage 1 — Ground in Repo Context

Before reasoning about impact or asking questions, find out what the system actually looks like
today.

1. **Check for existing project context first**, in order of preference:
   - A project wiki/knowledge base (e.g. produced by an `llm-wiki`-style skill) — scan its index
     once to know what exists, then read only the pages matching the requirement's affected areas
     (routes/API, data/schema, external integrations, frontend, and any tracked
     technical-debt/known-issues log for the affected area).
   - `CLAUDE.md`/`AGENTS.md`/README architecture notes, if no wiki exists.
   - If none of the above exist or look stale (e.g. don't mention a route/table you can see is
     recently active): tell the user context is missing/stale and ask whether to generate it first
     (if a wiki-generation skill exists in this repo) or proceed with a lighter direct repo scan
     (grep/glob over the actual route/handler files, schema/migration files, config/definitions
     directories, and templates/UI directories). Let the user decide — do not silently skip context
     gathering, and do not silently trigger a full regeneration without asking.
2. Cross-reference the requirement against what you found. Note explicitly (for your own working
   notes, and later for the plan):
   - Which existing routes/handlers, service/helper modules, tables/models, or UI
     components/templates this touches
   - Which documented business rules this extends, changes, or contradicts
   - Any tracked technical debt or known limitation in the affected area worth flagging — e.g. a
     requirement touching auth inherits whatever auth limitation is already documented, or a
     requirement adding a new external-integration call site should reuse whatever retry/client
     pattern already exists rather than adding a new one

Never invent affected files or components — if existing context or a repo scan doesn't confirm
something, say so rather than assuming.

---

## Stage 2 — Clarifying Questions (STOP — wait for the user)

Generate clarifying questions from the gap between the requirement and what Stage 1 found. Do not
proceed to Stage 3 until the user has answered or explicitly said "no more questions, proceed."

Cover, where relevant to the requirement:

- **Scope boundaries** — what's explicitly out of scope; is this additive or does it change
  existing documented behavior?
- **Actors & permissions** — which user roles are affected; anything the current auth model
  doesn't already support — note the *actually active* auth mechanism (not just the documented/
  intended one) and flag any gap against it rather than silently designing around it.
- **Data contract** — new fields/tables/collections, new migrations plus whatever this repo's
  canonical schema artifact is, changes to existing structures that other code already reads (a
  rename can silently break a sibling consumer if there's no compile-time/type-checked contract
  enforcing consistency).
- **Route/API contract** — new endpoints and where they should live per this repo's actual routing
  convention; request/response shape; whether it needs the repo's actual auth gate.
- **External-integration / pipeline impact** — if this touches an AI/payment/notification
  provider or similar: does it add a new call site (should reuse the existing retry/client
  pattern, not a new one), a new configurable option (needs wiring into whatever resolution chain
  already exists), or affect a synchronous request path (if there's no job queue, a slow addition
  here blocks the serving process)?
- **Invariant-critical impact** — does this change anything a dedicated ledger/audit/state-machine
  module owns (billing, inventory, permissions)? Any such write must go through that module, never
  a direct write from a route/handler.
- **Frontend decisions this repo requires an explicit answer on before design** (always ask, never
  assume, since these vary hugely by stack):
  - Does a new page/view extend the existing shared shell/layout, or is it a standalone page?
  - Any new async interaction — does it follow the existing pattern (inline fetch per page, a
    shared API client, a state-management store), or does it need something new?
- **Non-functional requirements** — performance/scale expectations, responsiveness, and whether
  new user-facing strings need any localization handling (confirm with the user whether this repo
  already has an i18n framework, and don't assume one exists or doesn't).
- **Edge cases the requirement is silent on** — empty states, concurrent double-submit of a
  request, large input, external-call failures mid-pipeline, permission-denied paths.
- **Integration impact** — anything touching an external provider, a webhook, or an OAuth/SSO flow
  — found in whatever context Stage 1 turned up.
- **Architectural impact** — think like an architect, not just a feature-writer, and ask rather
  than assume:
  - Does this cross an existing module/service/layer boundary, or introduce a new dependency
    between parts of the system that were previously independent of each other?
  - Does an equivalent problem already have a solution elsewhere in the codebase (a similar
    resolution chain, a similar permission check, a similar background-job pattern) that this
    should reuse rather than duplicate?
  - Does this introduce a new failure mode — a new external call, a new async step, a new
    single point of failure — that needs explicit handling, or does it sit entirely inside an
    existing, already-handled path?
  - Does this put meaningful new pressure on a non-functional dimension this repo actually cares
    about (request volume, payload size, query pattern, data growth) — or is it genuinely
    negligible and worth saying so explicitly rather than silently skipping the question?
  - Is there a real architectural alternative here (a different boundary to put the logic in, a
    sync vs. async choice, extend vs. duplicate an existing table/service), even if the answer
    turns out to be "no, the obvious approach is also the only reasonable one"?

Present the questions as a numbered list, grouped by theme if there are more than ~6. End with an
explicit prompt: *"Answer these, or tell me to proceed with reasonable assumptions — I'll mark any
assumed items as assumptions in the plan."* If the user chooses to let some go unanswered, carry
them into the plan as a labeled **Assumptions** section rather than silently deciding.

---

## Stage 3 — Architectural Reasoning & Implementation Plan (STOP — wait for human review)

Once clarifications are resolved (answered or explicitly waived), **reason through the design
before drafting anything** — do not jump straight from "here's what was asked for" to "here's how
to build it." Think like the architect on this feature, not just its scribe:

1. **Locate this feature in the actual system.** Which existing boundary (module, service, layer,
   bounded context) does it belong inside? Does it stay entirely within one boundary, or does it
   need to cross one — and if it crosses one, is that crossing consistent with how this repo
   already lets its boundaries talk to each other (a defined interface/contract) or does it
   introduce a new, ad hoc coupling?
2. **Generate at least one real alternative** before committing to an approach — a different place
   to put the logic, a sync vs. async choice, extending an existing structure vs. adding a new
   one, reusing an existing pattern vs. introducing a new one. For a genuinely small, unambiguous
   change this can be quick, but do it explicitly rather than skipping straight to the first idea
   that came to mind — the alternative you reject and the reason you rejected it is often more
   informative to a reviewer than the approach you kept.
3. **Name the tradeoffs in the approach you're leaning toward**, even ones the requirement didn't
   ask about: what does this decision cost — future flexibility, a new dependency, added latency,
   a small amount of duplicated logic accepted deliberately to avoid a worse coupling? A plan with
   no acknowledged tradeoffs either found a rare free lunch or didn't look hard enough.
4. **Check consistency with this repo's existing architectural stance**, not just its file
   conventions — is this repo deliberately monolithic/modular, sync/async, tightly/loosely
   coupled by design? Does the chosen approach reinforce that stance or quietly erode it? If it
   erodes it, that's not automatically wrong, but it must be called out as a deliberate exception,
   not slipped in as if it were the obvious choice.
5. **Consider non-functional consequences even when the requirement is purely functional** —
   most feature requests don't mention performance, availability, or security, but most features
   still have some effect on them. Where the effect is genuinely negligible, say so explicitly in
   the plan rather than omitting the section; don't let silence stand in for "I checked and it's
   fine."

This is internal reasoning that then has to show up in the plan below — a plan whose
"Architectural Approach" section reads like a feature description with no alternative considered
and no tradeoff named has skipped this step, not completed it.

The plan itself is a review artifact for a human, not yet a task list — keep it at the level of
"what are we building, why this way, and what does it cost," not "here is every subtask."

Structure:

```markdown
# Plan: <Requirement Title>

## Summary
<2-4 sentences: what this delivers and why>

## Scope
**In scope:** ...
**Out of scope:** ...

## Assumptions
<Only present if clarifications were waived — list each assumption explicitly>

## Affected Areas
| Area | Component(s) | Nature of change |
|------|--------------|-------------------|
| Routes/API | <this repo's actual routing location> | new route / modified handler |
| Data | <this repo's actual migration mechanism + schema artifact> | new migration + schema update |
| Domain logic | <this repo's actual service/helper module convention> | new/modified helper |
| External integration/config | <this repo's actual config/definitions location> | new config option / integration change |
| Frontend | <this repo's actual UI location> | new/modified page or component |

## Architectural Approach
<Which existing boundary/module/service/layer this lives inside, and whether it crosses one;
data flow through the system for this feature; the key design decisions and the rationale for
each — not just what was chosen but why it's consistent with (or a deliberately called-out
exception to) this repo's existing architectural stance>

## Alternatives Considered
<At least one real alternative — including "do nothing"/defer, or the most obvious naive
approach — with a concrete one-line reason it was rejected in favor of the chosen approach. If
genuinely only one approach was viable, say explicitly why no alternative was worth considering
rather than omitting this section>

## Key Tradeoffs
<For each non-trivial decision in Architectural Approach, name the tradeoff — omit only if the
decision truly has none, which should be rare:>
**Tradeoff: <short title>**
- Decision made: <what was chosen>
- What is gained: <benefit>
- What is given up / deferred: <cost, risk, or follow-on work this decision creates>

## Non-Functional Impact
<Only the dimensions genuinely relevant to this feature — but check all of them before omitting
any, and say "negligible" explicitly rather than leaving a dimension out silently:>
- **Performance/scale**: new query/processing patterns, N+1 risk, payload size, expected request
  volume relative to what this repo already handles
- **Availability/failure modes**: what happens if a new external call, new async step, or new
  dependency this feature introduces fails or times out — does the feature degrade gracefully, or
  does it risk taking something else down with it?
- **Security**: new attack surface — a new input, a new permission boundary, a new external call,
  a new place user-controlled data flows into
- **Consistency/coupling**: does this introduce a new dependency between previously-independent
  parts of the system, or duplicate logic that already exists elsewhere in the codebase?

## Data Model / API Changes
<New/changed tables, fields, endpoints, request/response shapes — only if applicable>

## Risks & Open Items
<Anything uncertain, any known technical debt this touches, any performance-sensitive logic that
will need a comment flagging it per this repo's conventions, and any accepted Key Tradeoff whose
cost the team should consciously sign off on rather than discover later>

## Sequencing
<Suggested build order if there are dependencies between parts>
```

Present this plan to the user and **explicitly ask for review**: approve as-is, or request changes.
Do not proceed to Stage 4 on an implicit approval (e.g. the user just saying "ok" to something
else) — get a clear go-ahead on the plan specifically. Revise and re-present if changes are
requested.

**Once the plan is approved, revisit `requirement.md` before moving to Stage 4.** Scope decisions
made during Stage 2/3 routinely change the shape of what's actually being built relative to how it
was first framed in Stage 0. Update `requirement.md`'s plain-language summary (same PM-readable bar
as Stage 0) to reflect the *final* scope: fold in the plan's `Summary` and `Scope` sections,
translated out of engineering terms, so a PM reading `requirement.md` alone gets the real, final
picture.

---

## Stage 4 — Task List (User Stories, Acceptance Criteria, Test Plan)

Only after the plan is approved, decompose it into a task list. Break the plan's "Affected Areas"
and "Sequencing" into independently deliverable stories — small enough to review and test
individually, but not so granular they lose the "why."

For each story, use this structure:

```markdown
### <STORY-ID>: <Short title>

**As a** <role/actor>
**I want** <capability>
**So that** <benefit / business reason>

**Priority:** P0/P1/P2
**Depends on:** <other story IDs, or "None">

**Acceptance Criteria:**
- Given <context>, when <action>, then <expected outcome>
- Given ..., when ..., then ...
  <cover every clarified behavior and every business rule this touches from repo context>

**Test Plan:**
- *Positive:*
  - ...
- *Edge cases:*
  - ... (empty input, boundary values, large input, pagination limits, double-submit of a
    request given whatever concurrency-handling exists)
- *Negative cases:*
  - ... (invalid input, unauthenticated access — does the route actually use this repo's real
    auth gate? — cross-tenant/cross-account access, external-call failure, malformed webhook
    payload/signature, downstream data-layer failure)
- *Non-functional (if applicable):*
  - Responsive layout check, matching this repo's actual frontend/styling approach
  - Migration reversibility, per whatever migration mechanism this repo actually has
  - Invariant correctness: any ledger/state-machine-owned effect goes through its dedicated
    module, not a direct write; correct source used for any dual-source-of-truth value (e.g. two
    different rate/config sources that must not be conflated)
  - Performance: query/processing behavior noted for review if touching large datasets, given
    whatever concurrency model (pooled/async vs. synchronous/single-worker) this repo actually has
```

Rules for this stage:

1. **Trace every AC back to something** — the original requirement, a clarification answer, an
   existing business rule from repo context, or a decision recorded in the plan's Architectural
   Approach/Key Tradeoffs (e.g. a chosen failure-handling behavior becomes an AC, not just prose in
   the plan). Don't invent behavior that wasn't discussed.
2. **Every story needs at least one negative and one edge test case** — a story with only
   happy-path tests isn't done.
3. **Reuse domain vocabulary from repo context** (entity names, role names, workflow IDs) rather
   than renaming concepts.
4. **Flag UI-decision stories** (shared shell vs. standalone page, interaction pattern) with the
   answer captured in Stage 2 stated directly in the story, not left implicit.
5. **Keep stories vertically sliced** where possible (touches a route + its UI for one
   user-visible behavior) rather than slicing by layer, unless the plan's sequencing explicitly
   calls for layer-by-layer delivery (e.g. a migration must land before the route that uses it).
6. **Note test executability honestly** — per this repo's actual test setup (discovered in Stage
   1, or from a tailored version of this skill), mark whether a test case is realistically
   automatable today or would need a manual pass / a live-integration script (which may cost real
   money and mutate real state — never wire those into a story's expected CI path without asking).

---

## Output

Write the artifacts under:

```
docs/tasks/<feature-slug>/
├── requirement.md      # Stage 0: PM-readable restated requirement + source;
│                        #          revised after Stage 3 approval to fold in the plan's
│                        #          final scope, still in plain language
├── clarifications.md   # Stage 2: questions asked + answers/waivers
├── plan.md              # Stage 3: the reviewed/approved plan (engineering-facing detail)
└── task-list.md          # Stage 4: user stories, AC, test plans
```

Use a short kebab-case `<feature-slug>` derived from the requirement title. If `docs/tasks/`
doesn't exist yet, create it — mirror whatever docs-output convention this repo already uses (e.g.
a wiki-generation skill's output directory), if one exists.

Do not write `plan.md` or `task-list.md` until their respective stage has been approved.

---

## Behavioral Rules

- **Never skip the two STOP points.** Clarifying questions and the plan both require an explicit
  human response before continuing — this is the entire point of the workflow.
- **Ground everything in actual repo context, not assumption.** If existing docs contradict the
  requirement, surface the conflict as a clarifying question, don't silently resolve it. If a
  planning doc and the actual code disagree, the code (or a code-verified wiki) wins.
- **No silent scope creep.** If you notice adjacent work that seems necessary, raise it in the
  plan's Risks/Open Items — don't fold it into scope without the user agreeing.
- **Don't fabricate affected files.** Every "Affected Areas" row should trace to something you
  actually found via repo context or a repo scan.
- **Every plan must show real architectural reasoning, not just a component list.** At minimum:
  one alternative genuinely considered (with why it was rejected), an explicit tradeoff for each
  non-trivial decision, and a non-functional-impact check that isn't silently skipped. A plan that
  jumps straight from requirement to "here's what we'll build," with no alternative weighed and no
  cost named, isn't done — regardless of how small the feature looks. Small features can still
  cross a boundary, set a precedent for the next ten features, or quietly introduce a coupling
  that's expensive to undo later.
- **Test plans must include negative and edge cases, always** — a task list without them is
  incomplete.
- **Respect this repo's actual conventions, not generic best practice** — surfaced at the
  clarification stage, not discovered during implementation.
- **Don't recommend fixing unrelated technical debt as part of this requirement.** If the
  requirement's area touches a known issue, name it in Risks/Open Items so the user can decide
  whether to fold in the fix — don't expand scope to "also do the refactor" uninvited.

---

## Tailoring this skill to a specific codebase

Trigger: the user says something like *"Update this skill to suit the tech stack of this
codebase"* (or names this skill directly while asking for the same).

When this happens:

1. **Reuse discovery work already done.** If `fullstack-developer`, `code-reviewer`, or
   `qa-tester` in this repo have already been tailored, read them first — their stack findings
   (routing convention, data layer, auth mechanism, test setup, docs location) apply here too.
2. **Otherwise discover it directly**: what's this repo's actual routing/data/auth/test/docs
   setup (same checks as `fullstack-developer`'s Phase 0), and where does a project wiki or
   equivalent context source live, if one exists.
3. **Rewrite Stage 1's context-gathering list and Stage 2/3/4's placeholder references** (routing
   location, data-layer/migration mechanism, config/definitions location, UI location, test
   framework, docs-output convention) with this repo's actual names and paths — mirroring the
   specificity of a well-grounded, repo-specific version of this skill. Don't invent conventions
   you didn't confirm.
4. **Update the frontmatter `description`** to name the actual stack, keeping the trigger phrasing
   generic enough to still match BRD/task-list requests.
5. **Keep this "Tailoring" section itself**, so the skill can be re-tailored later if the stack
   changes.
