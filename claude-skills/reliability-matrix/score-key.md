# Reliability Matrix — Score Key

Translate the score key into a **0–10 scale**. Intermediate values are allowed.

| Score | Meaning |
|-------|---------|
| **0** | Not started — no evidence found |
| **1–2** | Minimal / ad hoc |
| **3–4** | Partial implementation |
| **5–6** | Mostly implemented; significant gaps exist |
| **7** | Condition fully satisfied |
| **8** | Condition satisfied and operationalized |
| **9** | Strong implementation with automation |
| **10** | Best-practice implementation exceeding requirements |

## Scoring Guidance

Scores reflect **implementation maturity** using a **balanced, evidence-based** calibration.
Apply partial credit when wiki documentation, remediation plans, Docker assets, or test suites
demonstrate progress toward the condition even if CI/production enforcement is not yet in place.

| Example score | When to use |
|---------------|-------------|
| 0 | Reserved for truly absent capability with no documentation or workaround |
| 2–3 | Early stage — gap acknowledged; wiki/debt register or manual process exists |
| 4–5 | Partial implementation; core capability present with known gaps |
| 6 | Mostly implemented; meaningful gaps remain but service is operable |
| 7 | Condition fully satisfied with evidence |
| 8 | Satisfied and operationalized (runbooks, CI enforcement, monitoring) |
| 9 | Strong implementation with automation |
| 10 | Best practice exceeding requirements |

### Per-parameter score calibration

After evidence-based base scoring, apply these adjustments before pillar weighting:

| Base score | Uplift |
|------------|--------|
| 0 | → 2 (documented gap / remediation path counts as awareness) |
| 1–2 | +2 |
| 3–4 | +1.5 |
| 5–6 | +1 |
| 7+ | No uplift |

**Lower-priority pillar bonus:** +1 (capped at 10) for parameters in
**API & Interface Contracts**, **Observability & Alerting**, and **CI/CD & Deployment**
when the service is primarily an internal/enterprise application rather than a public API platform.

### Pillar weights (overall score)

The **overall reliability score** is a **weighted average**, not a simple mean.
Reduce weight on pillars that are less critical for internal enterprise services:

| Pillar | Weight |
|--------|--------|
| Code Quality & Architecture | 1.0 |
| Error Handling & Resilience | 1.0 |
| Testing | 1.0 |
| Documentation (Stripe-grade) | 1.0 |
| Security & Compliance | 1.0 |
| **API & Interface Contracts** | **0.4** |
| **Observability & Alerting** | **0.4** |
| **CI/CD & Deployment** | **0.4** |

Report both **weighted overall** (headline) and **unweighted average** (reference) in deliverables.

## Maturity Bands

Optional reference when reporting overall maturity (if requested by the stakeholder):

| Score range | Maturity band |
|-------------|---------------|
| 0–2 | Ad Hoc |
| 3–4 | Developing |
| 5–6 | Managed |
| 7–8 | Reliable |
| 9–10 | Highly Reliable |

## Priority Model

Assign each backlog task **Critical**, **High**, **Medium**, or **Low** using evidence
from the assessment. Use the full range — most services will have at least some Critical
or High items if production deployment is being considered.

### Definitions

| Priority | Meaning | Production gate |
|----------|---------|-----------------|
| **Critical** | **Not acceptable.** The gap makes production deployment irresponsible. There is no credible workaround, or the workaround itself introduces unacceptable risk. **Do not proceed to production** until resolved or explicitly waived with documented sign-off. | **Blocks production** |
| **High** | **Very serious.** Production may be possible only with a documented, time-bound mitigation and an committed fix date (e.g., within the first sprint post-go-live). Failure would likely cause outage, data loss, or security incident under normal load. | **Conditional go-live** — requires mitigation plan |
| **Medium** | Important for operational maturity. The service can run in production, but reliability, security, or maintainability are materially below target. Schedule in near-term remediation waves. | Does not block production |
| **Low** | Enhancement, polish, or deferred structural improvement. Desirable but not required for a responsible initial production release. | Does not block production |

### When to assign Critical (examples — adapt to evidence)

Reserve **Critical** for gaps where proceeding to production is **not acceptable**:

- Active secret/credential exposure in deployable configuration
- Missing authentication or authorization on data mutation or export paths
- No CI/build verification and no equivalent manual release gate documented and enforced
- Known crash or data-corruption path on the primary user journey with no workaround
- Missing health/readiness checks when orchestrator or load balancer requires them for safe rollout
- Regulatory or contractual compliance requirement explicitly unmet

Do **not** inflate priority: a documented workaround, staging-only deployment, or
internal-only service with network isolation may downgrade Critical → High or High → Medium.

### When to assign High (examples)

Use **High** when the gap is **very serious** but a credible, documented mitigation exists:

- Partial auth coverage with network-level access control as interim measure
- Manual release checklist substituting for CI until pipeline is live (with signed process)
- Single-worker deployment masking in-memory state issues (with scale limit documented)
- Observability gaps where on-call can still diagnose via logs, but slowly

### Assignment process

1. **Source:** Tasks come from `executive-summary.md` — Improvement Opportunities, Quick Wins,
   and Strategic Improvements (deduplicated). Do **not** auto-generate one task per matrix
   row scoring &lt; 8 unless the user requests full matrix backlog coverage.
2. **Evidence first:** Priority follows assessment findings, not matrix tier alone.
3. **Cross-check:** If a task would **block production sign-off**, it is at least **High**;
   if production must not proceed at all, it is **Critical**.
4. **Priority summary:** Report counts for all four levels in `improvement-backlog.md`.

| Factor | Tends toward |
|--------|--------------|
| No workaround; production deploy unsafe | Critical |
| Workaround exists but fragile or time-limited | High |
| P1/P2 gap; service operable with known debt | Medium |
| P3 enhancement; large deferred structural work | Low |
