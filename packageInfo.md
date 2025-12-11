# 🌊 The `flode` Ecosystem: A Comprehensive Flood Forecast Modelling Toolkit

`flode` (Old English for "flood") is an opinionated†, interconnected ecosystem of R packages designed to make the entire hydrological modelling and analysis workflow predictable, efficient, and reproducible.

Built upon a consistent data structure and an academically-themed naming convention, flode provides the essential tools to move seamlessly from raw data fetching to final hydraulic validation.

## Why flode?

**Cohesive Structure:** All packages share consistent object types, ensuring results from one package are immediately usable as input for the next.

**Focus on Reproducibility:** Provides explicit functions for every step of the workflow, minimizing manual intervention and black-box processes.

**Academic Rigour:** Designed around established hydrological principles and statistical methods, encapsulated in powerful, yet accessible functions.

## 🌊 `Flode` Package Suite: Conceptual Naming (Root-Based)

These names are derived from Greek and Latin roots to provide unique, academically themed identifiers for the downstream hydrological R packages.

| Function | Package Name | Root/Origin | Hydrological Meaning |
| :--- | :--- | :--- | :--- |
| **Data wrangling and downloading off APIs** | **`epotamic`** | Greek: *potamos* (river) + *e-* (from) - **"from the river"** | Drawing data from the river source. |
| **Carrying out geospatial analytics** | **`choros`** | Greek: *Choros* ($\chi o\rho o\acute{s}$) - **"place, space, region"** | Analysing the spatial context and geography of the water system. |
| **Review models with statistical tests** | **`telos`** | Greek: *Telos* ($\tau\acute{\epsilon}\lambda o\varsigma$) - **"end, goal, completion"** | Focuses on the final result and achievement of the model's validity. |
| **Generate design hydrology** | **`diluvium`** | Latin: *Diluvium* - **"flood, deluge, inundation"** | Generates models for extreme, design-level flood events. |
| **Carry out rating optimisation & hydraulics** | **`hydrometra`** | Greek: *Hydor* (water) + *Metron* (measure) - **"water measurement"** | The process of measuring and optimising water flow and level. |

---

### Package Summary

1. **`epotamic`**: The "entry point" for your data pipeline.
2. **`choros`**: Handles all coordinate systems, GIS operations, and catchment delineations.
3. **`telos`**: Provides the "final word" on model performance through rigorous testing.
4. **`diluvium`**: Dedicated to return periods, hydrograph generation, and flood risk.
5. **`hydrometra`**: Focuses on the physical mechanics of water—rating curves and hydraulic equations.


## 🌊 `Flode` Package Suite Documentation

This document outlines the core fields for the `DESCRIPTION` files of the five packages comprising the `flode` hydrological R package suite.

---

### 📦 Package: `epotamic` (Data Wrangling/API)

| Field | Content |
| :--- | :--- |
| **Package** | `epotamic` |
| **Title** | Hydrological Data Retrieval and Initial Wrangling |
| **Description** | Provides a comprehensive suite of tools for connecting to, downloading, and aggregating raw hydrological and meteorological data from various national and international APIs. It standardises heterogeneous data formats into a tidy, consistent structure for use across the `flode` package suite. |
| **Root/Origin** | Greek: *potamos* (river) + *e-* (from) - **"from the river"** |

---

### 🗺️ Package: `choros` (Geospatial Analytics)

| Field | Content |
| :--- | :--- |
| **Package** | `choros` |
| **Title** | Geospatial Analysis and Hydrological Delineation Tools |
| **Description** | Facilitates core geospatial operations for water resources management. This includes defining and manipulating drainage basins, performing topographic analysis (e.g., slope, aspect, stream power), and managing coordinate reference systems for all spatial inputs in a workflow.  |
| **Root/Origin** | Greek: *Choros* ($\chi o\rho o\acute{s}$) - **"place, space, region"** |

---

### 📊 Package: `telos` (Statistical Model Review)

| Field | Content |
| :--- | :--- |
| **Package** | `telos` |
| **Title** | Statistical Validation and Performance Review for Hydrological Models |
| **Description** | Offers a focused collection of statistical tests and metrics for evaluating the performance, uncertainty, and predictive power of hydrological models. Includes tools for residual analysis, bias detection, cross-validation, and calculating goodness-of-fit metrics (e.g., Nash-Sutcliffe Efficiency, $R^2$) to ensure model validity. |
| **Root/Origin** | Greek: *Telos* ($\tau\acute{\epsilon}\lambda o\varsigma$) - **"end, goal, completion"** |

---

### 🌧️ Package: `diluvium` (Design Hydrology Generation)

| Field | Content |
| :--- | :--- |
| **Package** | `diluvium` |
| **Title** | Generation of Design Flood Events and Recurrence Estimates |
| **Description** | Specialised tools for calculating and generating design hydrology for engineering applications. Features include Intensity-Duration-Frequency (IDF) curve fitting, flood frequency analysis (e.g., using GEV or Log Pearson Type III distributions), estimating flood quantiles, and generating design hydrographs based on specified return periods.  |
| **Root/Origin** | Latin: *Diluvium* - **"flood, deluge, inundation"** |

---

### 📏 Package: `hydrometra` (Rating Optimisation/Hydraulics)

| Field | Content |
| :--- | :--- |
| **Package** | `hydrometra` |
| **Title** | Open-Channel Hydraulics and Streamflow Rating Curve Optimisation |
| **Description** | Provides functions for basic open-channel hydraulics calculations (e.g., using Manning's equation) and the optimisation of streamflow rating curves. This includes stage-discharge data processing, error estimation, and methods for extrapolating and validating rating tables for critical high-flow and low-flow conditions.  |
| **Root/Origin** | Greek: *Hydor* (water) + *Metron* (measure) - **"water measurement"** |

† In the context of R programming and package design, "opinionated" means that the developers have made conscious, specific choices about how data should be structured, how functions should be named, and how analyses should be performed.

It implies a strong bias toward a particular workflow and data style, rather than trying to support every possible method or data format.
