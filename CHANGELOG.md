# Changelog

All notable changes to `flode` are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

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
