# Governance — flode Ecosystem

This document records the governance classification and role assignments for the **flode** meta-package and all **reaches** sub-packages, in accordance with the F&W Data and Digital Asset Governance Framework v1.2.

All tools in the flode ecosystem are **Route B — Shared Module / Package** assets. They are subject to the code governance requirements in Section 8 of the framework and the R Tool Governance Proposal.

---

## Governance Roles

| Role | Holder | Grade | Notes |
|---|---|---|---|
| **Owner** |TBC | Deputy Director | Approval authority for Tier 1 promotion and deprecation |
| **Steward** | TBC | G7 | Day-to-day governance, Tool Register, access approval |
| **Technical Lead / Delegated Steward** | Jonathan Payne | G6 | Operational lead; coordinates development and reviews |
| **Custodian(s)** | TBC | Any | Development, maintenance, and issue reporting |

> Delegation must be recorded with a start date. Delegation does not transfer accountability.

---

## Tool Tier Classifications

| Package | Tier | Rationale | Promotion Status |
|---|---|---|---|
| `flode` | TBC | Meta-package; inherits tier of highest-tier sub-package | Pending Owner sign-off |
| `reach.utils` | TBC | Shared utility layer; used by all sub-packages | Pending |
| `reach.io` | TBC | Data ingestion pipeline; may feed live forecasting | Pending |
| `reach.hydro` | TBC | Flow statistics and flood peak analysis | Pending |
| `reach.ensemble` | TBC | Ensemble post-processing; potential Tier 1 use | Pending |
| `reach.validate` | TBC | Model validation metrics; typically analytical | Pending |
| `reach.viz` | TBC | Visualisation; typically Tier 2 | Pending |

> **Tier 1 promotion requires Owner sign-off.** A tool must not be used in live forecasting until formally promoted to Tier 1.

---

## Tier Requirements Summary

| Tier | Code Review | Custodian Duty | Owner Grade | Steward Grade |
|---|---|---|---|---|
| **Tier 1 — Operational** | Mandatory peer review + senior sign-off before first production deployment; annual audit | Runs scheduled CI, monitors issues, maintains disaster recovery runbook | Deputy Director (different person from Steward) | G7 required |
| **Tier 2 — Analytical** | Peer review before merging to main | Runs tests before major version upgrades; flags broken dependencies | Deputy Director recommended | G7 recommended |
| **Tier 3 — Experimental** | Self-review checklist minimum; peer review encouraged | Flags broken dependencies to Steward | Senior manager acceptable | Lower grade acceptable |

---

## Version Control Standards

All flode packages follow the simplified Git Flow branching model:

| Branch | Purpose |
|---|---|
| `main` | Production-ready only. No direct commits. |
| `develop` | Integration branch. All features merge here first. |
| `feature/<n>` | Individual feature work. Branched from `develop`. |
| `hotfix/<n>` | Urgent fixes to Tier 1 tools. Branched from `main`. |
| `release/<version>` | Release preparation. Branched from `develop`. |

---

## Commit Convention

All commits must follow **Conventional Commits**:

```
<type>(<scope>): <short description>

Body: explain WHY, not just what.
```

Permitted types:

| Type | When to use |
|---|---|
| `feat` | New function or feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Code restructure without behaviour change |
| `test` | Adding or updating tests |
| `chore` | Dependency updates, CI config, admin |

**Example:**
```
feat(reach.io): add netCDF write support for Bronze store

Adds write_netcdf() to support gridded output formats required
by the Hydrometric Data Framework Silver-tier specification.
```

---

## Versioning

All packages follow **Semantic Versioning (MAJOR.MINOR.PATCH)**:

| Change type | Version bump | Example |
|---|---|---|
| Breaking change to existing interface | MAJOR | 1.0.0 → 2.0.0 |
| New functionality (backwards-compatible) | MINOR | 1.0.0 → 1.1.0 |
| Bug fix (backwards-compatible) | PATCH | 1.0.0 → 1.0.1 |

Every release must be:
- Tagged in Git (`git tag v1.1.0`)
- Accompanied by a `CHANGELOG.md` entry

---

## Dependency Reproducibility

All packages must maintain an `renv.lock` file committed to the repository. Code must be runnable from a clean environment without undeclared dependencies.

```r
# Initialise renv for a package
renv::init()

# Snapshot dependencies after adding a new package
renv::snapshot()
```

---

## Code Review Checklist

All pull requests must confirm the following before merge:

- [ ] Functions are correctly implemented and tested
- [ ] Unit tests pass (`devtools::test()`)
- [ ] No undeclared dependencies introduced
- [ ] `renv.lock` updated if dependencies changed
- [ ] Documentation updated (`devtools::document()`)
- [ ] `CHANGELOG.md` entry added
- [ ] Commit messages follow Conventional Commits
- [ ] No hardcoded credentials, file paths, or environment-specific values

---

## Incidents and Escalation

| Severity | Who to notify | Timeframe |
|---|---|---|
| Tier 1 tool failure during live forecast | Steward immediately, then Owner | Immediate |
| Tool failure affecting a formal output | Steward, Owner if external impact | Same day |
| Broken dependency or test failure | Steward | Within 1 working day |
| Post-incident review (Tier 1 / Route D) | Technical Lead + Steward | Within 10 working days |

> No more than two Route D (emergency) deployments per twelve-month period for the same tool area before a review is triggered.

---

## Tool Register

The central Tool Register is maintained at [`inst/tool-register.md`](inst/tool-register.md). It must be updated whenever:
- A custodianship role changes
- A tool changes tier
- A tool is deprecated

---

## Handover Requirements

When a Steward or Custodian changes, a handover note must be produced covering:
1. Tool purpose and known quirks
2. Current technical debt and open issues
3. Status of any open pull requests
4. Scheduled maintenance tasks

Stored in each package's `docs/` directory. For Tier 1 tools, the incoming Steward must run the full test suite and confirm it passes before formally accepting handover.

---

## Review Schedule

This document is reviewed annually by the Steward with Owner sign-off.

| Field | Value |
|---|---|
| Framework version | v1.2 (February 2026) |
| Parent document | Data and Digital Asset Governance Framework v1.2 |
| Next review | February 2027 |
| Approval authority | Neil Ryan and Jo Coles |
