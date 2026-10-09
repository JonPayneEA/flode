# Changelog

All notable changes to `flode` are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- `reach.meteo`, `reach.network`, `reach.postproc`, `reach.rate` and `reach.basin` added to the core sub-packages

- `flode_use_project()` scaffolds a project via `reach.utils::create_project()` with a starter workflow script
- `flode_workflows()` and `flode_workflow()` list and print example workflows (console or Mermaid)
- `flode_install()` installs flode and sub-packages from GitHub via `pak`
- `flode_sitrep()` compares installed versions with GitHub
- `flode_conflicts()` finds function name clashes between sub-packages and with base R
- `flode_options()` gets and sets shared settings
- `flode_detach()` detaches the sub-packages

### Changed
- `flode_update()` installs from GitHub by default; the old Git platform install is used only when `repo` is supplied
- Install hints now suggest `pak::pak()` for reach packages

### Fixed
- `Imports:` now uses plain package names; GitHub sources are in `Remotes:`
- Startup message no longer drops the right-hand column of packages

---

## [0.2.0] - 2026-02-01

### Added
- `flode_versions()` displays installed version table for all sub-packages
- `flode_update()` reinstalls all reaches sub-packages from Git
- `.onAttach()` startup message with two-column version layout via `cli`

### Changed
- `flode_packages()` now returns packages in dependency order

---

## [0.1.0] - 2025-01-01

### Added
- Initial release
- `flode_attach()` attaches core sub-packages on load
- `flode_packages()` returns character vector of sub-package names
