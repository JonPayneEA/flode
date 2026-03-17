# flode (meta-package)

The `flode` meta-package loads the full Forecasting and Warning R toolkit
in one call — the same pattern as `library(tidyverse)`.

```r
library(flode)
#> -- flode 0.1.0 -- Forecasting Operations and Development Environment --
#> v Attaching core packages:
#>   reach.utils 0.1.0    reach.validate 0.1.0
#>   reach.io 0.1.0       reach.viz 0.1.0
#>   reach.hydro 0.1.0
#>   reach.ensemble 0.1.0
```

All sub-package functions are immediately available with no further imports.

---

## Installation

```r
# Install the meta-package and all sub-packages from the team Git platform
remotes::install_git("https://git.internal/forecasting/flode")

# Restore the pinned dependency environment (do this first on a new machine)
renv::restore()
```

---

## What gets loaded

| Sub-package | Contents |
|---|---|
| `reach.utils` | Datetime helpers, config loading, logging |
| `reach.io` | Gauge CSV, Parquet, netCDF read/write |
| `reach.hydro` | Flow statistics, unit conversion, flood peaks |
| `reach.ensemble` | Quantile extraction, member weighting, exceedance probability |
| `reach.validate` | NSE, KGE, PBIAS, RMSE validation metrics |
| `reach.viz` | `theme_flode()`, flow series and ensemble fan plots |

---

## Helper functions

```r
# Check all installed versions
flode_versions()

# Reload a subset of packages
flode_attach(c("reach.hydro", "reach.validate"))

# Update everything from the team repo
flode_update()
```

---

## Adding a new sub-package

To add a new module to what `library(flode)` loads, add it to `.flode_packages`
in `R/flode.R` and add it to `Imports:` in `DESCRIPTION`. Open a PR against
the flode meta-package repo and tag the Flode Steward for review.
