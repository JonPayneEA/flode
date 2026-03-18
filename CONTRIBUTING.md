# Contributing to the flode Ecosystem

Thank you for contributing to the F&W flode packages. This guide covers everything you need to know to develop, review, and submit changes in line with the F&W Data and Digital Asset Governance Framework v1.2.

All contributions to the flode ecosystem are **Route B — Shared Module / Package** contributions. Read this document before raising a pull request.

---

## Before You Start

1. **Raise a Git issue** describing the proposed change and its scope
2. The **Steward / Technical Lead** will confirm the development route and target tier within five working days
3. Agree on the target branch and package before writing any code

---

## Development Setup

### Prerequisites

- R ≥ 4.2.0
- [Rtools](https://cran.r-project.org/bin/windows/Rtools/) (Windows)
- Git

### Clone and initialise

```r
# Clone the repo you are contributing to, e.g.:
# git clone https://github.com/JonPayneEA/reach.utils.git

# Open the .Rproj file in RStudio, then:
install.packages("renv")
renv::restore()          # install pinned dependencies from renv.lock

install.packages("devtools")
devtools::load_all()     # load the package locally
devtools::test()         # confirm all tests pass before you start
```

---

## Branching Strategy

The flode ecosystem follows a simplified Git Flow model. **Never commit directly to `main`.**

```
main          ← production-ready only; protected; no direct commits
  └─ develop  ← integration branch; merge features here
       └─ feature/<issue-number>-<short-description>   ← your work
       └─ hotfix/<issue-number>-<short-description>    ← urgent Tier 1 fixes only
  └─ release/v<MAJOR.MINOR.PATCH>                      ← release prep
```

### Starting a feature

```bash
git checkout develop
git pull origin develop
git checkout -b feature/42-add-netcdf-write
```

### Starting a hotfix (Tier 1 urgent fix only — verbal Steward authorisation required first)

```bash
git checkout main
git pull origin main
git checkout -b hotfix/99-fix-api-timeout
```

---

## Commit Messages

All commits must follow the **Conventional Commits** convention:

```
<type>(<scope>): <short description in imperative mood>

Optional body: explain WHY this change was made, not just what.
Reference the issue number if applicable: closes #42
```

### Permitted types

| Type | Use for |
|---|---|
| `feat` | A new function or capability |
| `fix` | A bug fix |
| `docs` | Documentation changes only |
| `refactor` | Code restructure with no behaviour change |
| `test` | Adding or updating tests |
| `chore` | Dependency updates, CI config, admin tasks |

### Examples

```
feat(reach.io): add write_netcdf() for Silver-tier gridded output

Implements netCDF write support using the ncdf4 package.
Required by the Hydrometric Data Framework Silver-tier spec.
Closes #42.
```

```
fix(reach.hydro): correct unit conversion factor in cms_to_mld()

The conversion factor was 86.4 instead of 86400. This caused
a three-order-of-magnitude error in daily volume calculations.
Closes #57.
```

---

## Coding Standards

### Naming Conventions

| Thing | Convention | Example |
|---|---|---|
| Functions | `snake_case` verbs | `calc_flood_peak()`, `load_gauge_dt()` |
| `data.table` objects | `snake_case` with `_dt` suffix | `flow_dt`, `ensemble_dt` |
| OOP classes | `UpperCamelCase` | `FlodeCatchment`, `FlodeForecast` |
| Variables | descriptive `snake_case` nouns | `catchment_area_km2`, `peak_flow_cms` |
| Constants | `UPPER_SNAKE_CASE` | `DEFAULT_THRESHOLD_M3S` |
| Script files | descriptive, date-prefixed | `2026-02_flow_ensemble_aggregation.R` |

### Package Ecosystem — fastverse preferred

The team's default ecosystem is the **fastverse**, not the tidyverse. The tidyverse **must not** be used in Tier 1 tools or in any flode package function. It may be used freely in Tier 3 exploratory work.

| Task | Preferred package |
|---|---|
| Tabular data manipulation | `data.table` (primary); `collapse` (supplementary) |
| Time series operations | `kit`, `roll` |
| Numerical / statistical computation | `collapse::fnth()`, `collapse::fmean()` etc. |
| File I/O — tabular text | `data.table::fread()` / `fwrite()` — never `read.csv()` or `readr` in production |
| File I/O — Parquet | `arrow::read_parquet()` / `write_parquet()` |
| File I/O — spatial / netCDF | `terra`, `ncdf4` |
| Visualisation | `ggplot2` acceptable for Tier 2–3; `reach.viz` functions preferred |
| Config / paths | `here`, `config` |
| Package development | `devtools`, `roxygen2`, `usethis`, `testthat` |

> **New to data.table?** The key concept is `DT[i, j, by]`: filter rows with `i`, compute columns with `j`, group with `by`. See the [data.table wiki](https://rdatatable.gitlab.io/data.table/) or ask the R Lead for a walkthrough.

### OOP — S7 preferred for Flode classes

| System | Use when |
|---|---|
| **S7** (preferred) | All new exported Flode classes; formal validated class contracts |
| **R6** | Stateful objects with a lifecycle (initialize/finalize); reference semantics explicitly needed |
| **S3** | Lightweight `print`/`summary` dispatch on existing structures |
| **S4** | Interoperability with existing S4 packages (e.g. `terra`) only — not for new development |

### Style

- Maximum line length: 80 characters
- Use `styler::style_pkg()` to auto-format before committing

### Mandatory Header Block

Every script and function file must begin with this header, completed in full:

```r
# ============================================================
# Tool:        [Tool name]
# Description: [One-sentence description of what this does]
# Flode Module:[Target module, e.g. reach.hydro — or 'standalone']
# Author:      [Name, email]
# Created:     [YYYY-MM-DD]
# Modified:    [YYYY-MM-DD] - [initials]: [change summary]
# Tier:        [1 / 2 / 3]
# Inputs:      [Describe inputs and expected formats]
# Outputs:     [Describe outputs and formats]
# Dependencies:[List non-base packages; flag any non-fastverse choices]
# ============================================================
```

### Documentation

Every exported function must have a roxygen2 header with:
- `@title` — one-line description
- `@description` — what the function does
- `@param` — every parameter
- `@return` — what the function returns
- `@examples` — at least one working example
- `@export`

```r
#' Convert cumecs to megalitres per day
#'
#' @description
#' Converts a flow value in cubic metres per second (m³/s) to
#' megalitres per day (Ml/d).
#'
#' @param x Numeric. Flow in cubic metres per second (m³/s).
#'
#' @return Numeric. Flow in megalitres per day (Ml/d).
#'
#' @examples
#' cms_to_mld(1)   # returns 86.4
#'
#' @export
cms_to_mld <- function(x) {
  x * 86.4
}
```

### Testing

Every new or modified function must have corresponding tests using `testthat`:

```r
test_that("cms_to_mld converts correctly", {
  expect_equal(cms_to_mld(1), 86.4)
  expect_equal(cms_to_mld(0), 0)
  expect_error(cms_to_mld("a"))
})
```

Run the full test suite before raising a PR:

```r
devtools::test()
```

### Dependencies

- Add new dependencies to `DESCRIPTION` (`Imports:` for required, `Suggests:` for optional)
- Run `renv::snapshot()` after adding any new package
- Commit the updated `renv.lock`
- Do not import packages solely for one trivial use — prefer base R

---

## Pull Request Process

1. **Push your branch** and open a pull request against `develop`
2. **Complete the PR checklist** (auto-populated from `.github/pull_request_template.md`):
   - [ ] All tests pass (`devtools::test()`)
   - [ ] Documentation updated (`devtools::document()`)
   - [ ] `renv.lock` updated if dependencies changed
   - [ ] `CHANGELOG.md` entry added under `[Unreleased]`
   - [ ] Commits follow Conventional Commits convention
   - [ ] No hardcoded credentials, paths, or environment-specific values
3. **Request a review** from a second team member
4. The reviewer approves and merges — or the Technical Lead for Tier 1 changes

### Tier 1 additional requirements

- A **senior reviewer** must sign off before the first production deployment
- The Technical Lead must be notified of any Tier 1 custodianship change

---

## Versioning and Releases

All packages follow **Semantic Versioning (MAJOR.MINOR.PATCH)**:

| Change | Bump | Example |
|---|---|---|
| Breaking API change | MAJOR | 1.2.3 → 2.0.0 |
| New backwards-compatible feature | MINOR | 1.2.3 → 1.3.0 |
| Bug fix | PATCH | 1.2.3 → 1.2.4 |

### Making a release

```bash
# From develop, create a release branch
git checkout -b release/v1.3.0

# Update DESCRIPTION version field
# Update CHANGELOG.md — move [Unreleased] to [1.3.0] with today's date
# Final tests and documentation check

# Merge to main and tag
git checkout main
git merge release/v1.3.0
git tag v1.3.0
git push origin main --tags

# Merge back to develop
git checkout develop
git merge main
```

---

## CHANGELOG Format

All packages maintain a `CHANGELOG.md` in the root directory following [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
# Changelog

## [Unreleased]

### Added
- `write_netcdf()` for Silver-tier gridded output (#42)

### Fixed
- Corrected unit conversion factor in `cms_to_mld()` (#57)

## [1.2.0] - 2026-02-01

### Added
- `run_incremental()` high-watermark sync function

### Changed
- `download_hydrology()` now defaults to parallel mode
```

---

## Adopting an External Package (Route C)

Before adding any new package dependency for shared or production use, evaluate it against all six criteria:

| Criterion | Check |
|---|---|
| Active maintenance | Last commit < 12 months; issues responded to |
| Compatible licence | MIT, Apache 2.0, or GPL compatible with team use |
| Acceptable performance | No significant slowdown on representative data |
| Manageable dependency footprint | Does not pull in a large transitive dependency tree |
| Genuine necessity | Cannot be replaced with base R or an existing dependency |
| Sufficient adoption | CRAN downloads / GitHub stars indicate community trust |

Raise this assessment as a Git issue tagged `dependency-review` for Steward sign-off before adding to `DESCRIPTION`.

---

## Getting Help

| Question | Go to |
|---|---|
| Unsure which branch to target | Technical Lead / Steward — raise a Git issue |
| New dependency approval | Raise a `dependency-review` issue |
| Tier 1 urgent fix | Verbal Steward authorisation first, then `hotfix/` branch |
| Governance questions | See [GOVERNANCE.md](GOVERNANCE.md) |
| Found a bug | Raise a Git issue; label as `bug` and include reproducible example |
