---
name: fullstack-developer
description: >
  End-to-end feature development skill — generic across stacks until tailored to a specific repo.
  Trigger this skill whenever the user asks to "add a feature", "add a route/endpoint/API", "add a
  column/table", "wire this into the UI", "add a config option", "change the generation/processing
  pipeline", "add a page", or describes work that touches both a data/service layer and a UI layer
  in the current repo. Takes the request from data model through service/route logic through
  external-integration/business logic through UI, following *this specific codebase's* actual
  conventions rather than generic framework advice — this skill's job is to discover those
  conventions (or use ones already recorded) before writing a single line of code. Does not apply
  to single-layer bug fixes with no schema/route/UI surface — use targeted investigation for those
  instead. Also triggers on "update this skill to suit the tech stack of this codebase" — see
  **Tailoring this skill to a specific codebase** at the bottom.
---

# Full-Stack Development

A guided workflow for building a feature across whatever this repo's *actual* stack turns out to
be — its real web/service framework, its real data layer, its real approach to external
integrations (AI/payment/notification/etc. providers), and its real frontend approach. This skill
ships stack-agnostic: it does not assume Flask vs. Rails vs. Express vs. Spring, SQL vs. NoSQL,
React vs. server-rendered templates, or any particular provider SDK. When it's run against a real
repo, either it has already been tailored (see the bottom section) and encodes that repo's actual
conventions and known traps, or it must discover them fresh in Phase 0 below — never guess.

**Golden rule: ground every phase in what this repo actually does before writing code.** Check for
an existing project wiki/docs directory, a `CLAUDE.md`/`AGENTS.md`, or prior tailoring of this
skill first; only fall back to a live repo scan if none of those exist. Re-deriving conventions
from scratch when they're already documented risks contradicting an established pattern; guessing
when nothing is documented risks inventing a convention that fights the existing code.

---

## Phase 0 — Discover this repo's actual stack (skip if already tailored)

If this skill has already been tailored to this codebase (its phases below name specific
files/frameworks instead of generic placeholders), skip to Phase 1. Otherwise, before scoping any
feature, establish:

- **Language/runtime + package manager**: look for `package.json`/lockfile, `pyproject.toml`/
  `requirements.txt`, `go.mod`, `Gemfile`, `pom.xml`/`build.gradle`, `composer.json`, `Cargo.toml`,
  `*.csproj`.
- **Web/service framework** and where routes/handlers/controllers actually live (a single
  entrypoint file, a modular router/blueprint/controller directory, a framework-generated
  structure).
- **Data layer**: is there an ORM (look for `models/`, `schema.prisma`, Alembic/Django migrations,
  ActiveRecord, TypeORM/Sequelize/Knex config) or raw SQL/query builder? Where does the canonical
  schema live, and how are schema changes versioned (a migrations folder, a schema file, both)?
- **Auth pattern**: middleware/decorator/guard used on protected routes, and what identity model
  backs it (sessions, JWT, OAuth, an internal SSO).
- **External integrations**: any AI/LLM, payment, messaging, or other third-party SDKs in use —
  how are clients instantiated, how are retries/timeouts handled, is calling them synchronous
  (blocking the request) or backed by a job queue/worker?
- **Frontend approach**: SPA framework (React/Vue/Angular/Svelte) with a bundler, or
  server-rendered templates (Jinja2/ERB/Blade/Thymeleaf/EJS) — and the shared-layout convention
  either way.
- **Test setup**: what actually runs safely without hitting a real external service or production
  data (unit tests with mocks) vs. what's a live-integration/e2e script that costs money or mutates
  real state — don't assume; check `tests/`/`spec/`/`__tests__/` and any CI config
  (`.github/workflows/`, `.gitlab-ci.yml`, etc.) for what's actually wired to run automatically.
- **Existing docs**: a project wiki (e.g. produced by an `llm-wiki`-style skill), `CLAUDE.md`/
  `AGENTS.md`, `docs/`, or a README architecture section — read whatever exists rather than
  re-deriving it.

Record findings only as long as needed to do the current task, or — if the user is invoking the
**Tailoring** procedure at the bottom — write them into this file so future invocations don't
re-discover them from scratch.

---

## Phase 1 — Scope the request

Before touching any file, pin down what layers this feature actually needs:

- **Data**: does this need a new field/table/collection? → the repo's actual schema source of
  truth + migration mechanism (from Phase 0)
- **Route/API**: new or changed endpoint? → wherever routes/controllers/handlers actually live
- **Integration/business logic**: does it touch an external provider (AI, payments, notifications)
  or add a new configurable option to an existing pipeline?
- **UI**: new page/view, new field on an existing one, or wiring an existing endpoint into the
  frontend?

Read only the docs/wiki pages that match the layers above — don't load the whole doc set for a
narrow change.

If the feature is ambiguous in scope (e.g. "add a new option" with no detail on shape/behavior),
ask one focused question before planning — don't guess at schema shape, request/response shape, or
UI copy. A wrong guess here costs a migration + route + UI rewrite, not just a line edit.

---

## Phase 2 — Data layer

1. **Find the actual schema source of truth** (a schema file, an ORM's model definitions, or a
   migrations directory that *is* the source of truth) before adding anything — don't assume a
   pattern that isn't there.
2. **Match this repo's existing naming and typing conventions** (table/collection naming,
   primary-key convention, nullable-vs-required defaults) — check a couple of existing
   models/tables rather than assuming a "standard" convention; this repo may deliberately deviate
   (surrogate keys everywhere except one legacy table, a polymorphic owner column, etc.) and that
   deviation matters more than a textbook default.
3. **Match the existing connection/session-management pattern** — a shared pool, a per-request
   session, a per-call-site connection. Don't introduce a new pattern (e.g. a connection pool where
   none exists) for one feature; that's an architectural change, not a feature change, and needs an
   explicit call-out if it's genuinely warranted.
4. **Check for sibling structures carrying the same kind of column/field** — a family of
   `default_*`/`*_override` pairs, a repeated enum/config-dimension pattern — and confirm whether a
   new dimension of the same kind needs wiring into the same resolution logic, not just a bare
   column. A field that exists in storage but isn't wired into resolution logic is a silent no-op,
   not an error.
5. **Schema changes should be versioned the way this repo already versions them** — a migration
   file plus an update to whatever the canonical schema artifact is, if both exist as separate
   things here. One without the other leaves the canonical shape and the applied-migration history
   out of sync.

---

## Phase 3 — Route / API / service layer

1. **Add routes/handlers where this repo's convention says they go** — a single entrypoint file, a
   module per resource, a framework-generated controller. Don't introduce a new organizational
   pattern (e.g. a new blueprint/module style) unless the task is explicitly a refactor.
2. **Auth**: gate new protected routes with whatever this repo's *actually active* auth mechanism
   is — check which decorator/middleware/guard real protected routes use today, and whether any
   documented-but-unused auth path exists (a listed dependency that's never actually wired up, a
   feature flag that force-disables an auth method). Don't assume the documented/intended auth
   method is the one actually enforced without checking.
3. **Never extend or quietly "fix" an existing unauthenticated debug/test-login backdoor** if one
   is found in the repo. Flag it as a finding instead of treating it as a pattern to copy.
4. **Errors**: follow the existing error-handling convention (a shared error-handler middleware, or
   inline try/except-then-response per route) — don't introduce a second error-handling convention
   for one feature.
5. **Storage**: if the repo has a storage-abstraction layer (a wrapper around local disk / object
   storage), use it rather than calling the underlying file/object API directly, even if the
   abstraction currently only has one active backend wired up.
6. **Money/ledger-affecting or otherwise invariant-critical writes**: if the repo has a dedicated
   service/module that owns an invariant (a ledger, an audit log, a state machine), route new
   writes through it rather than writing the underlying rows/documents directly from a route.
7. **New configurable option on an existing pipeline**: route it through whatever existing
   resolution chain (override → default → fallback) the repo already has for that kind of option,
   rather than a bespoke conditional. Add the option's definition wherever similar options are
   defined (a config file, an enum, a definitions directory) — not as an inline literal in route
   code.
8. **Trace a new field through every response path it appears in** — list endpoints, detail
   endpoints, and any frontend code that consumes that response — whether or not the repo has a
   serializer/schema layer. A field that's stored and returned in one place but missing from a
   sibling response shape is a silent gap.

---

## Phase 4 — External integration / business-logic layer (only if this feature touches one)

1. **Match the existing client-instantiation pattern** for whatever SDK is in use (a shared client
   factory vs. per-call instantiation), and the current SDK style if the provider has had a
   documented API-style migration (older config-style init vs. newer client-object style) — check
   which one the rest of the codebase actually uses, not just what the SDK's current docs show.
2. **Reuse the existing retry/backoff helper** for calls to that integration rather than writing a
   new one — check whether more than one retry implementation already exists (a known duplication
   in some repos) before assuming there's a single shared one; if there's already more than one,
   don't add a third, and prefer wiring the new call into whichever is meant to be canonical.
3. **Respect the existing sync-vs-async execution model.** If there's no job queue/background
   worker, a slow call here blocks the serving request/worker — don't introduce polling or a job
   queue for one feature; match whatever the existing pattern for "this can be slow" already is
   (client-side retry with backoff, a long-request timeout, etc.). If a job queue does exist, use
   it rather than inlining a slow call into a request handler.
4. **Match the existing response-parsing convention at each call site** (strict schema validation
   vs. raw/best-effort parsing) rather than inventing a third pattern for a new call site — pick
   whichever the code you're extending already does.
5. **Check for standalone scripts/pipelines that reuse core modules but aren't part of the deployed
   app** (CLI tools, batch scripts, admin tooling) before assuming "the pipeline" means the one
   deployed path — confirm with the user which pipeline a request actually means if it's ambiguous;
   a fix to one does not automatically apply to the other.

---

## Phase 5 — Frontend layer

1. **If this is an SPA**: match the existing component/page/state-management conventions (routing
   setup, shared layout/shell component, existing state library if one is used) rather than
   introducing a new one for a single feature.
2. **If this is server-rendered**: extend whatever shared layout/shell template this repo already
   uses (its overridable blocks/sections), and match the existing pattern for page-specific
   interactivity (inline scripts per template vs. a shared bundle) rather than introducing a new
   client-side state module for one feature. Confirm which pages are standalone (their own full
   document, e.g. a login/landing page) vs. which extend the shared shell.
3. **Reuse existing design tokens** (CSS variables/theme config) rather than hardcoding new colors
   or spacing values — check whether the repo's actual visible styling matches its documented
   brand/design-system guidelines before assuming either side is authoritative; flag any drift
   rather than silently "fixing" it toward one side.
4. **Check for orphaned/dead frontend components** (files not referenced by any route/template/
   bundle entry) before extending one — confirm with the user whether a dead component should be
   revived or whether to build fresh, rather than silently extending dead code.
5. **Close the loop from backend to UI**: when a feature adds a field to a response or a
   persisted value, find every UI surface that should display it and wire all of them.

---

## Phase 6 — Wire together and verify

**Do not claim "tests pass" without checking which category of test you actually ran.** Identify
(from Phase 0, or by checking now):

- Which test files are genuinely CI-safe — mocked/stubbed dependencies, no live external calls, no
  live DB. Run only those to check your change.
- Which test files/scripts hit a real external API and/or a real database — these cost money
  and/or mutate real state. Never run these casually to "check" a change, and never point them at
  production credentials/data; if a change genuinely needs live verification, say so and ask the
  user first.

For everything else, verify manually:

- Run the app the way this repo's own docs/scripts say to run it (dev server, container compose
  setup, etc.).
- Exercise new/changed routes directly (through the actual UI, or with an authenticated request via
  the repo's actual auth mechanism) — don't invent a test harness the repo doesn't have.
- If the feature touches a synchronous external-integration call, actually trigger it and watch
  logs, since there's likely no separate worker log to tail.
- **Verify persisted state directly** (a DB query, a document read) rather than trusting a JSON/UI
  response alone — a typo in a raw query often fails loudly, but a field silently missing from a
  response payload usually does not.

---

## Phase 7 — Documentation

If this feature changes behavior an existing project wiki/docs already describes, update the
corresponding page(s) in the same change (regenerate via whatever wiki-generation skill/process
this repo uses, if the change is broad) rather than letting docs drift. Prefer updating existing
docs over adding a new standalone planning doc, unless the repo's own conventions call for one. Add
any new configuration/environment variable to wherever the repo already documents those (an
`.env.example`, a config reference doc) at the same time it's introduced in code.

---

## Behavioral Rules

- **Confirm the actual entrypoint/structure before assuming one from stale docs.** A README or
  architecture doc can lag behind the real repo layout — trust what's actually on disk.
- **Confirm which pipeline/module you're actually editing before touching a repo with more than one
  similar-looking one** (a main app vs. standalone scripts, a v1 vs. v2 module) — extending the
  wrong one is a common wasted-effort mistake.
- **Never extend or "fix" a known unauthenticated backdoor/debug route** — flag it rather than
  touching it, unless the explicit task is to remove/gate it.
- **Schema changes must stay consistent with however this repo tracks schema state** — a migration
  file and a canonical schema artifact, if both exist, must move together.
- **Never claim tests pass** without stating which specific test files you ran and confirming they
  are genuinely mocked/CI-safe, or state that you verified manually instead.
- **Don't introduce a second connection-pool, a second retry helper, a second auth path, or a new
  global state module** for one feature when an existing pattern already covers the need.
- **Ask before assuming schema/API/UI shape** when the request doesn't specify it.

---

## Tailoring this skill to a specific codebase

Trigger: the user says something like *"Update this skill to suit the tech stack of this
codebase"* (or names this skill directly while asking for the same).

When this happens:

1. **Reuse discovery work already done.** If another skill/subagent in this repo's
   `.claude/skills/` or `.claude/agents/` (e.g. `brd-task-creator`, `code-reviewer`, `qa-tester`)
   has already been tailored to this codebase, read it first — its stack findings apply here too,
   and re-deriving them from scratch wastes effort and risks inconsistency between skills.
2. **Otherwise run Phase 0 above for real**: inspect manifests/lockfiles, the actual routing/entry
   structure, the actual data layer, the actual auth mechanism, the actual external integrations,
   the actual frontend approach, and the actual test setup (which files are mocked/CI-safe vs.
   live). Also check for a project wiki, `CLAUDE.md`/`AGENTS.md`, or README architecture notes and
   prefer those over re-deriving from raw code where they exist and look current.
3. **Rewrite Phases 1–7 above in place**, replacing each generic bullet with the concrete
   equivalent for this repo — name actual frameworks, actual file/module locations, actual
   decorator/middleware names, actual retry helpers, actual design-token names, actual test file
   names — with `file:line` citations where useful, mirroring the level of specificity a
   well-grounded, repo-specific version of this skill would have. Do not invent conventions you
   didn't actually confirm; where something is genuinely absent (no ORM, no test framework, no job
   queue), say so explicitly rather than filling the gap with a generic default.
4. **Update the frontmatter `description`** to name the actual stack (so future trigger-matching is
   accurate), while keeping the trigger phrasing generic enough to still match "add a feature"
   style requests.
5. **Keep this "Tailoring" section itself** at the bottom, updated only to note it's already been
   run — so the skill can be re-tailored later if the stack changes (a framework migration, a new
   data layer) without losing this capability.
6. **Never fabricate specifics that don't survive inspection.** A tailored skill that confidently
   states a convention the repo doesn't actually follow is worse than a generic one that says
   "check this before assuming."
