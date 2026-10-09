# =============================================================================
# Tool: flode reproducibility
# Description: Record and restore the exact versions of the flode packages
# Flode Module: core
# Author: Forecasting and Warning Team
# Tier: 1
# Dependencies: yaml, cli
# =============================================================================

#' Record the exact versions of the flode packages
#'
#' Writes the version and GitHub commit of flode and every installed
#' sub-package to a YAML file, so a forecast run can be reproduced later with
#' [flode_restore()]. Commits are only known for packages installed from
#' GitHub (by `pak` or `remotes`).
#'
#' @param path File to write. Default `"flode-snapshot.yml"`. Use `NULL` to
#'   return the snapshot without writing a file.
#' @param packages Character vector of sub-packages. Defaults to
#'   [flode_packages()].
#'
#' @return Invisibly returns a data frame with columns `package`, `version`,
#'   `owner`, `repo` and `sha`.
#' @seealso [flode_restore()]
#' @export
flode_snapshot <- function(path = "flode-snapshot.yml", packages = flode_packages()) {
  pkgs <- c("flode", packages)
  pkgs <- pkgs[vapply(pkgs, .is_installed, logical(1L))]

  field <- function(p, f) {
    value <- utils::packageDescription(p, fields = f)
    if (is.na(value) || is.null(value)) NA_character_ else as.character(value)
  }
  out <- data.frame(
    package = pkgs,
    version = vapply(pkgs, field, character(1L), f = "Version"),
    owner   = vapply(pkgs, field, character(1L), f = "RemoteUsername"),
    repo    = vapply(pkgs, field, character(1L), f = "RemoteRepo"),
    sha     = vapply(pkgs, field, character(1L), f = "RemoteSha"),
    stringsAsFactors = FALSE,
    row.names = NULL
  )

  no_sha <- out$package[is.na(out$sha)]
  if (length(no_sha) > 0L) {
    cli::cli_warn(c(
      "No GitHub commit recorded for some packages; they will restore to the latest version:",
      "!" = paste(no_sha, collapse = ", "),
      "i" = "Reinstall them with {.run flode::flode_install()} to record commits."
    ))
  }

  if (!is.null(path)) {
    records <- lapply(seq_len(nrow(out)), function(i) {
      as.list(out[i, c("package", "version", "owner", "repo", "sha")])
    })
    yaml::write_yaml(list(flode_snapshot = records), path)
    cli::cli_alert_success("Snapshot written to {.path {path}}")
  }
  invisible(out)
}

#' Restore flode packages from a snapshot
#'
#' Reinstalls the packages recorded by [flode_snapshot()] at their recorded
#' GitHub commits.
#'
#' @param path Snapshot file. Default `"flode-snapshot.yml"`.
#' @param upgrade Logical. Upgrade other dependencies. Default `FALSE`.
#'
#' @return Invisibly returns the GitHub references that were installed.
#' @seealso [flode_snapshot()]
#' @export
flode_restore <- function(path = "flode-snapshot.yml", upgrade = FALSE) {
  if (!file.exists(path)) {
    cli::cli_abort("Snapshot file not found: {.path {path}}")
  }
  records <- yaml::read_yaml(path)$flode_snapshot
  if (!is.list(records) || length(records) == 0L) {
    cli::cli_abort("{.path {path}} does not contain a flode snapshot.")
  }
  refs <- vapply(records, function(r) {
    owner <- if (is.null(r$owner) || is.na(r$owner)) .flode_owner else r$owner
    repo  <- if (is.null(r$repo)  || is.na(r$repo))  r$package else r$repo
    ref   <- paste0(owner, "/", repo)
    if (!is.null(r$sha) && !is.na(r$sha)) ref <- paste0(ref, "@", r$sha)
    ref
  }, character(1L))

  cli::cli_h2("Restoring flode packages")
  if (.is_installed("pak")) {
    pak::pak(refs, upgrade = upgrade)
  } else {
    flode_check_pkg("remotes", "flode_restore()")
    remotes::install_github(refs, upgrade = if (upgrade) "always" else "never")
  }
  cli::cli_alert_success("Done. Restart R to use the restored versions.")
  invisible(refs)
}
