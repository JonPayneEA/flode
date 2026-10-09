# flode 

<img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/JonPayneEA/flode/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JonPayneEA/flode/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

`flode` is a meta-package for flood forecasting and hydrometric data analysis. Installing and loading `flode` gives you access to the complete suite of **reaches** sub-packages in a single call.

```r
library(flode)
```

---

## The reaches ecosystem

| Sub-package | Contents |
|---|---|
| [`reach.utils`](https://github.com/JonPayneEA/reach.utils) | Datetime helpers, config loading, logging |
| [`reach.io`](https://github.com/JonPayneEA/reach.io) | APIs, Gauge CSV, Parquet, netCDF read/write |
| [`reach.hydro`](https://github.com/JonPayneEA/reach.hydro) | Flow statistics, unit conversion, flood peaks |
| [`reach.meteo`](https://github.com/JonPayneEA/reach.meteo) | Meteorological data tools |
| [`reach.network`](https://github.com/JonPayneEA/reach.network) | River network tools |
| [`reach.postproc`](https://github.com/JonPayneEA/reach.postproc) | Post-processing of forecast outputs |
| [`reach.rate`](https://github.com/JonPayneEA/reach.rate) | Rating curve tools |
| [`reach.basin`](https://github.com/JonPayneEA/reach.basin) | Basin tools |
| [`reach.viz`](https://github.com/JonPayneEA/reach.viz) | `theme_flode()`, flow series and ensemble fan plots |

*Planned: `reach.ensemble` (quantile extraction, member weighting, exceedance probability) and `reach.validate` (NSE, KGE, PBIAS, RMSE) will be added once released.*

---

## Installation

Install `flode` and all sub-packages from GitHub:

```r
# install.packages("remotes")
remotes::install_github("JonPayneEA/flode")
```

Sub-packages can also be installed individually:

```r
remotes::install_github("JonPayneEA/reach.utils")
remotes::install_github("JonPayneEA/reach.io")
remotes::install_github("JonPayneEA/reach.hydro")
remotes::install_github("JonPayneEA/reach.meteo")
remotes::install_github("JonPayneEA/reach.network")
remotes::install_github("JonPayneEA/reach.postproc")
remotes::install_github("JonPayneEA/reach.rate")
remotes::install_github("JonPayneEA/reach.basin")
remotes::install_github("JonPayneEA/reach.viz")
```

---

## Usage

```r
library(flode)
#> ── Attaching reaches packages ──────────────────────── flode 0.2.0 ──
#> ✔ reach.utils    0.1.0     ✔ reach.rate      0.1.0
#> ✔ reach.io       0.1.0     ✔ reach.basin     0.1.0
#> ✔ reach.hydro    0.1.0     ✔ reach.viz       0.1.0
#> ✔ reach.meteo    0.1.0
#> ✔ reach.network  0.1.0
#> ✔ reach.postproc 0.1.0
```

### Check installed versions

```r
flode_versions()
```

### Update all sub-packages

```r
flode_update()
```

---

## Design principles

- **Consistent interfaces** — all reach packages follow the same bronze-schema data model
- **Pipeline-ready** — designed for operational EA Hydrometric Data Framework workflows
- **Parallel-first** — heavy I/O operations are parallelised where possible via `future` / `future.apply`
- **Tidy-compatible** — outputs are data.table friendly

---

## Contributing

This package is maintained by the Environment Agency Forecasting and Warning Team.
📧 forecasting@environment-agency.gov.uk

---

## License

MIT

---


