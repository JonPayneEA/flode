# Governance for the R `flode` project

**NOTE**

*This document is currently in it's draft stage and does not represent the full governance of the flode project*

# Purpose and scope

## This document

The purpose of this document is to define how people related to the project work together, so that the project can expand to handle a larger and more diverse group of contributors.

## The `flode` environment

The `flode` package is a meta-framework designed to simplify the installation, loading, and management of multiple related packages, as outlined in the [`# Current Scope`](#current-scope). It provides an extensible structure that enables users to build a tailored "verse" of packages to meet their specific needs. A forthcoming vignette will offer a concise overview of its functionality and usage.

All tool development undertaken in R by the **Forecasting & Warning Department of the Environment Agency** must comply with the standards described in this document. Tools that meet these standards and performance requirements will be integrated into the `flode` meta-library.

The purpose of this project and accompanying documentation is to provide clear guidance on maintaining the `flode` ecosystem of packages. This effort is driven by the following core principles:

### 1. Package Structure and Design

-   Modular Architecture: Separate functionalities into logical components (e.g., data ingestion, preprocessing, modelling, visualisation).
-   Follow R Packaging Standards: Use devtools and usethis for set-up, and adhere to CRAN guidelines for documentation and testing.
-   Namespace Management: Export only essential functions; keep helper functions internal.
-   Computation: Time & memory efficiency.
-   Function language: Concise syntax (minimal redundancy in code).
-   Package dependencies: Stable code base preferred, code should require minimal maintenance, minimise where possible.
-   Comprehensive and accessible documentation and run-time signals (errors, warnings) for all functions.

### 2. Data Integration

-   Support Multiple Data Sources: Enable ingestion of hydrometric data from APIs (e.g., Hydrology Data Explorer), CSVs, and databases.
-   Metadata Handling: Include tools for managing station metadata, units, and time zones.
-   Data Validation: Implement checks for missing values, outliers, and unit consistency.
-   Data Dependencies: No external Imports/LinkingTo/Depends dependencies (external meaning not maintained by the EA).

### 3. Forecast Model Support

-   Model-Agnostic Framework: Allow integration of different flood forecasting models (e.g., statistical, machine learning, hydrological).
-   Parameter Calibration Tools: Provide utilities for sensitivity analysis and optimisation.
-   (TBC)Scenario Testing: Enable running models under different rainfall or discharge scenarios.

### 4. Visualisation and Reporting

-   Generate Business themed outputs: Use ggplot2 to underpin data visualisation, applying the EA business themes.
-   (TBC) Interactive Plots: Use ggplot2 and plotly for hydrographs, uncertainty bands, and forecast comparisons.
-   (TBC) Dashboards: Consider Shiny integration for real-time monitoring and review.
-   Automated Reports: Generate summaries in HTML or PDF using rmarkdown.

### 5. Performance and Scalability

-   Efficient Data Handling: Use data.table or arrow (upcoming) for large datasets.
-   (TBC) Parallel Processing: Support multi-core computations for model runs.
-   (TBC) Caching: Implement caching for repeated data queries.

### 6. Quality Assurance

-   Unit Testing: Use testthat for function-level tests.
-   Continuous Integration: Integrate with GitHub Actions for automated checks.
-   Version Control: Tag releases and maintain change logs.

### 7. Documentation and Usability

-   Comprehensive Vignettes: Include tutorials for data integration, model set-up, and review workflows.
-   Function-Level Help: Provide clear examples and parameter descriptions.
-   Error Handling: Offer informative messages and guidance for troubleshooting.

### 8. Compliance and Standards

-   Adopt Open Standards: Support formats like [WaterML](https://www.ogc.org/standards/waterml/) and ISO metadata.
-   Reproducibility: Ensure workflows can be replicated with minimal effort.
-   Transparency: Log all transformations and model runs for auditability.

To prioritise developer time, we define what is in and out of current scope. Feature requests in issues and pull requests that are out of current scope should be closed immediately, because they are not the current priority. If someone wants to contribute code that is currently out of scope, they first have to make a pull request that changes the scope as defined below.

## Current Scope {#current-scope}

The current scope of package functionality within `flode` includes:

-   `riskyData`: Imports data required for projects and provides optimised data transformation techniques to enable modelling and analysis.
-   `objectivER`: Supplies objective functions enabling the review of model performance.
-   `mappER`: Geospatial analytics for flood forecast modelling.
-   `hydraulER`: basic hydraulics tools such as rating optimisation
-   `hydrolER`: replicates some of the FEH methods that are useful to flood forecasting in R.
-   `fastER`: Experimental package to develop optimised functions and tools.
-   `cleanER`: Data cleaning tools.

Functionality that is out of current scope:

-   Linking directly to proprietary software APIs.
-   Anything that impacts on EULAs from existing operational products
-   Development of new model methods.
-   Alternative operational forecasting systems

# Roles

These are TBC and will follow the Forecast Modelling Governance Groups work

## Product Owner (PO)

**Purpose**

Owns vision, roadmap, and prioritisation. Ensures the package solves the right problems for hydrology/forecasting users and reviewers.

**Key Responsibilities**

-   Define outcomes, MVP scope, and release objectives; maintain a transparent backlog.
-   Prioritise data-source integrations (e.g., WISKI/WaterML connectors), modelling features, and review workflows.
-   Stakeholder engagement: demos, feedback loops, and adoption plans across forecasting and warning.
-   Translate domain needs into actionable acceptance criteria with the Domain Expert.
-   Manage risk/benefit trade-offs and negotiate scope Vs. dates.

**Decision Rights**

-   Final say on priority, scope, and release content.
-   Accepts features as "meets user need" at release.

**Deliverables**

-   Roadmap, sprint/release goals, backlog (with clear acceptance criteria).
-   Stakeholder comms and release notes (audience-focused).

**Anti‑Patterns to Avoid**

-   Feature creep without measurable outcomes.
-   Accepting features without domain validation or test data.

## Technical Architect

**Purpose**

Owns technical strategy, modular design, performance, and reliability.

**Key Responsibilities**

-   Define architecture boundaries (e.g., ingest → transform → model → evaluate → visualisation modules).
-   Approve dependencies and patterns (data.table, R6, targets, httr, arrow, roxygen2, testthat, renv).
-   Design for reproducibility (set seeds, deterministic pipelines), auditability (logging, provenance), and observability (metrics).
-   Set standards: code style, error handling, performance budgets, data contracts (units, time zones, station metadata).
-   Oversee CI/CD, packaging, and versioning strategies (semver, breaking change policy).

**Decision Rights**

-   Architecture changes, external dependencies, CI configuration.
-   Performance/security standards and minimum quality bars.

**Deliverables**

-   Architecture Decision Records (ADRs), dependency policy, performance guidance.
-   Reference implementations for tricky bits (e.g., time zone handling, unit conversions).

**Anti‑Patterns to Avoid**

-   Over‑engineering early; hidden coupling between modules; silent coercions in data transforms.

## Package Maintainer

**Purpose**

Day-to-day stewardship of the codebase, ensuring quality, consistency, and reliable releases.

**Key Responsibilities**

-   Triage issues, review PRs, maintain DESCRIPTION, NAMESPACE, and versioning.
-   Enforce style (lintr, styler), docs (roxygen2), tests (testthat), coverage targets.
-   Keep CI green (R CMD check --as-cran), manage pkgdown site and artefacts.
-   Curate CHANGELOG, deprecation paths, and migration notes.
-   Ensure reproducible environments (renv lockfile maintenance).

**Decision Rights**

-   Merge/gatekeeper authority aligned to standards.
-   Scheduling of technical debt and refactoring within release windows.

**Deliverables**

-   Release artefacts, pkgdown site, coverage and check reports.
-   Maintainer's guide, contribution guidelines, code owners mapping.

**Anti‑Patterns to Avoid**

-   Merging without tests/docs; unreviewed breaking changes; drifting dependencies.

## Hydrology and Forecasting Domain Expert

**Purpose**

Guarantees scientific validity and operational usefulness.

**Key Responsibilities**

-   Define evaluation metrics and thresholds (e.g., NSE, KGE, bias, hit/miss over thresholds).
-   Specify realistic workflows: calibration, scenario testing, forecast review practices.
-   Curate gold‑standard datasets and edge cases (spikes, outages, daylight‑saving transitions).
-   Validate outputs against operational expectations and regulatory/reporting needs.
-   Co‑design plotting defaults (hydrographs, uncertainty bands) with Docs/UX.

**Decision Rights**

-   Accept/reject domain correctness and adequacy of metrics.
-   Approve default parametersations and model interface design.

**Deliverables**

-   Acceptance notes per feature, metric definitions, benchmark baselines.
-   Synthetic/sanitised datasets and test scenarios.

**Anti‑Patterns to Avoid**

-   Implicit domain assumptions; metrics that don't reflect operational risk.

## Documentation & Training Lead

**Purpose**

Makes the package usable, teachable, and discoverable.

**Key Responsibilities**

-   Build vignettes and tutorials for end‑to‑end tasks (ingest → model → evaluate → review).
-   Maintain pkgdown site, onboarding guides, troubleshooting, and FAQs.
-   Provide runnable examples with synthetic datasets mirroring real quirks.
-   Create role‑based training (forecasters, reviewers, developers).
-   Keep docs synchronised with releases and deprecations.

**Decision Rights**

-   Documentation completeness for release; structure and style of learning materials.

**Deliverables**

-   Vignettes, function docs, quick‑starts, training decks/videos, example notebooks.
-   "How to review a forecast" and "Data integration checklist" guides.

**Anti‑Patterns to Avoid**

-   Tutorial drift from actual APIs; examples that don't run; missing migration notes.

## RACI Matrix (Focused Roles)

| Activity                             | Product Owner | Technical Architect | Package Maintainer | Domain Expert | Docs & Training Lead |
|------------|------------|------------|------------|------------|------------|
| Roadmap & priorities                 | **A/R**       | C                   | C                  | C             | C                    |
| Architecture decisions               | I             | **A/R**             | C                  | C             | I                    |
| Dependency policy                    | I             | **A/R**             | C                  | C             | I                    |
| Feature implementation (merge)       | I             | C                   | **A/R**            | C             | I                    |
| Domain validation (metrics, outputs) | C             | C                   | C                  | **A/R**       | I                    |
| Test strategy & coverage targets     | I             | A                   | **R**              | C             | I                    |
| Release readiness (go/no‑go)         | **A**         | C                   | R                  | C             | C                    |
| Documentation & training             | C             | C                   | C                  | C             | **A/R**              |
| Change logs & migration notes        | I             | C                   | **A/R**            | C             | **R**                |

**Legend:**\
- **A** = Accountable\
- **R** = Responsible\
- **C** = Consulted

# Decision-making processes

## Definition of Consensus

Most decisions in the project happen by Consensus of the Forecast Modelling Governance Group. In Consensus, non-response by inactive members indicates tacit agreement.

## Changing this GOVERNANCE.md document

There is no special process for changing this document. Proposed changes can be submitted to the Forecast Modelling Governance Group.

Please also make a note in the change log under [`# Governance history`](#governance-history)

# Finances and Funding

`flode` is an [Environment Agency](https://www.gov.uk/government/organisations/environment-agency) project that is managed by the Forecast Modelling Governance Group.

The flode fleet of packages has emerged as a strategic outcome of the Model Improvements Programme, where code initially developed as supporting tools and side benefits has now been consolidated into a dedicated, maintainable solution. This approach ensures that the functionality created during model enhancement efforts is captured, standardised, and made reusable for future forecasting and hydrometric data workflows.

# Code of conduct

**Note** *The linked code of conduct will be adapted to fit the EA business*

The full Code of Conduct can be found [here](https://numfocus.org/code-of-conduct), including details for reporting violations.

## Reporting Responsibility

Errors and reports of improper use should be escalated to the Forecast Modelling Governance Group.

# Version numbering

`flode` packages Version line in DESCRIPTION typically has the following meanings

-   x.y.z where x=major, y=minor, z=patch/hotfix/devel.
-   x should be incremented only for major backwards-incompatible changes.
-   z is for minor patches.

# Governance history {#governance-history}

Nov 2025: Establishment of basic governance structure.

# Wider Governance

1.  **Data Governance & Role**

    EA policies, standards, stewardship/RACI, approval gates.

2.  **Data Architecture & Catalogue**

    EA target architecture, Hydrometric Data Register/Data Catalogue, lineage & business definitions.

3.  **Data Acquisition & Integration**

    Hydrometric (gauges), meteorological (rainfall, radar), NRFA/FEH inputs, ETL/ELT, APIs.

4.  **Storage & Versioning**

    Time Series Repository (TSR) / data lake / warehouse, dataset snapshots, retention, runbooks.

5.  **Data Quality & Validation**

    QA rules (ranges, gaps, duplicates, station health), profiling, exception reports.

6.  **Security & Access Control**

    RBAC (Role-Based Access Control) Vs. ABAC (Attribute-Based Access Control), encryption, secrets management (e.g., key vaults), least‑privilege.

7.  **Reference & Master Data**

    Authoritative lists (stations, catchments, model reaches, flood zones, thresholds).

8.  **Pre‑processing & Boundary Conditions**

    Time alignment, unit conversions, rainfall/tide inflows, boundary & initial states.

9.  **Model Set-up & Configuration (Hydraulic & Conceptual)**

    Schematics, parameters, control files; versioned configuration in source control.

10. **Calibration & Verification**

    Calibrate with historical events; verify on independent periods; document acceptance criteria.

11. **Operational Forecasting & Scenario Management**

    NFFS / FWD Ops runs, scenario configs (ensembles, tides), dissemination outputs.

12. **Monitoring, Audit & Continuous Improvement**

    Performance & incident monitoring, audit trail, lessons learned → policy & standard updates.

``` mermaid
flowchart TD
  A["<b>Data Governance & Roles</b> EA policies, RACI, standards"] --> B["<b>Data Architecture & Catalogue</b> <br>Hydrometric Data Register, Lineage"]
  B --> C["<b>Data Acquisition & Integration</b> <br> Gauges, Met Office, NRFA/FEH, ETL/APIs"]
  C --> D["<b>Storage & Versioning</b> <br> Time Series Repository, Snapshots, Retention)"]
  D --> E["<b>Data Quality & Validation</b> <br> Ranges, Gaps, Station Health, QA reports"]
  E --> F["<b>Security & Access Control</b> <br> RBAC/ABAC, Encryption, Secrets"]
  F --> G["<b>Reference & Master Data</b> <br> Stations, Catchments, Reaches, Thresholds"]
  G --> H["<b>Pre-processing & Boundary Conditions</b> <br> Alignment, Units, Inflows, Initial States)"]
  H --> I["<b>Model Setup & Configuration</b> <br> Hydraulic & Conceptual"]
  I --> J["<b>Calibration & Verification</b> <br> Historicals, Independent periods"]
  J --> K["<b>Operational Forecasting & Scenario Mgmt</b> <br> NFFS / FWD Ops"]
  K --> L["<b>Monitoring, Audit & Continuous Improvement</b>"]
  L --> A
  %% Feedback loops
  E -.-> C
  D -.-> B
  H -.-> E
  J -.-> I
  L -.-> A
```
