# =============================================================================
# Tool: flode maintenance tools
# Description: Install, check, detach and configure the flode sub-packages
# Flode Module: core
# Author: Forecasting and Warning Team
# Tier: 1
# Dependencies: cli
# =============================================================================

#' Install flode and its sub-packages from GitHub
#'
#' Uses `pak` when available (it reads each package's `Remotes:`), otherwise
#' falls back to `remotes::install_github()`.
#'
#' @param packages Character vector of sub-packages. Defaults to
#'   [flode_packages()].
#' @param include_flode Logical. Also install flode itself. Default `TRUE`.
#' @param upgrade Logical. Upgrade dependencies that have newer versions
#'   available. Default `FALSE`.
#' @param owner GitHub account that hosts the packages.
#'
#' @return Invisibly returns the GitHub references that were installed.
#' @seealso [flode_sitrep()], [flode_update()]
#' @export
flode_install <- function(
  packages      = flode_packages(),
  include_flode = TRUE,
  upgrade       = FALSE,
  owner         = .flode_owner
) {
  refs <- paste0(owner, "/", c(if (include_flode) "flode", packages))
  cli::cli_h2("Installing flode packages")
  if (.is_installed("pak")) {
    pak::pak(refs, upgrade = upgrade)
  } else {
    flode_check_pkg("remotes", "flode_install()")
    remotes::install_github(refs, upgrade = if (upgrade) "always" else "never")
  }
  cli::cli_alert_success("Done. Restart R to use the new versions.")
  invisible(refs)
}

#' Compare installed flode packages with GitHub
#'
#' Reads each package's `DESCRIPTION` from GitHub and reports whether the
#' installed version is current. If GitHub cannot be reached the latest
#' version is reported as `NA` and the status as `"unknown"`.
#'
#' @param packages Character vector of sub-packages. Defaults to
#'   [flode_packages()].
#' @param owner GitHub account that hosts the packages.
#'
#' @return Invisibly returns a data frame with columns `package`,
#'   `installed`, `latest` and `status`.
#' @seealso [flode_install()], [flode_versions()]
#' @export
flode_sitrep <- function(packages = flode_packages(), owner = .flode_owner) {
  pkgs <- c("flode", packages)
  installed <- vapply(pkgs, function(p) {
    if (.is_installed(p)) as.character(utils::packageVersion(p)) else NA_character_
  }, character(1L))
  latest <- vapply(pkgs, .github_version, character(1L), owner = owner)

  status <- vapply(seq_along(pkgs), function(i) {
    if (is.na(installed[i])) "not installed"
    else if (is.na(latest[i])) "unknown"
    else if (utils::compareVersion(installed[i], latest[i]) < 0L) "update available"
    else "up to date"
  }, character(1L))

  out <- data.frame(
    package   = pkgs,
    installed = unname(installed),
    latest    = unname(latest),
    status    = status,
    stringsAsFactors = FALSE
  )

  cli::cli_h2("Flode situation report")
  for (i in seq_len(nrow(out))) {
    line <- "{out$package[i]}: {out$status[i]} (installed {out$installed[i]}, GitHub {out$latest[i]})"
    switch(out$status[i],
      "up to date"       = cli::cli_alert_success(line),
      "update available" = cli::cli_alert_warning(line),
      "not installed"    = cli::cli_alert_danger(line),
      cli::cli_alert_info(line)
    )
  }
  if (any(out$status %in% c("update available", "not installed"))) {
    cli::cli_alert_info("Run {.run flode::flode_install()} to install or update.")
  }
  invisible(out)
}

.github_version <- function(pkg, owner) {
  u <- sprintf("https://raw.githubusercontent.com/%s/%s/HEAD/DESCRIPTION", owner, pkg)
  tryCatch(
    suppressWarnings(as.character(read.dcf(url(u), fields = "Version")[1L, 1L])),
    error = function(e) NA_character_
  )
}

#' Find function name conflicts between flode packages
#'
#' Looks for exported functions that share a name across the flode
#' sub-packages, or that share a name with a function in base R.
#'
#' @param packages Character vector of sub-packages. Defaults to
#'   [flode_packages()]. Packages that are not installed are ignored.
#'
#' @return Invisibly returns a data frame with columns `fn`, `packages` and
#'   `conflicts_with`. It has zero rows when there are no conflicts.
#' @export
flode_conflicts <- function(packages = flode_packages()) {
  inst <- packages[vapply(packages, .is_installed, logical(1L))]
  empty <- data.frame(
    fn = character(0L), packages = character(0L), conflicts_with = character(0L),
    stringsAsFactors = FALSE
  )
  if (length(inst) == 0L) {
    cli::cli_alert_info("No flode sub-packages are installed.")
    return(invisible(empty))
  }

  exports <- lapply(inst, getNamespaceExports)
  all_fns <- data.frame(
    fn  = unlist(exports, use.names = FALSE),
    pkg = rep(inst, lengths(exports)),
    stringsAsFactors = FALSE
  )

  base_pkgs <- c("base", "stats", "utils", "methods", "graphics", "grDevices", "datasets")
  base_exports <- lapply(base_pkgs, getNamespaceExports)
  names(base_exports) <- base_pkgs

  rows <- list()
  for (fn in unique(all_fns$fn)) {
    owners <- sort(unique(all_fns$pkg[all_fns$fn == fn]))
    base_hit <- base_pkgs[vapply(base_exports, function(e) fn %in% e, logical(1L))]
    with <- c(
      if (length(owners) > 1L) "other flode packages",
      if (length(base_hit) > 0L) paste0("base R (", base_hit[1L], ")")
    )
    if (length(with) > 0L) {
      rows[[length(rows) + 1L]] <- data.frame(
        fn = fn,
        packages = paste(owners, collapse = ", "),
        conflicts_with = paste(with, collapse = "; "),
        stringsAsFactors = FALSE
      )
    }
  }

  out <- if (length(rows) > 0L) do.call(rbind, rows) else empty
  if (nrow(out) == 0L) {
    cli::cli_alert_success("No conflicts between flode packages.")
  } else {
    cli::cli_h2("Conflicts")
    for (i in seq_len(nrow(out))) {
      cli::cli_alert_warning(
        "{.fn {out$fn[i]}} from {out$packages[i]} conflicts with {out$conflicts_with[i]}"
      )
    }
  }
  invisible(out)
}

#' Detach flode sub-packages
#'
#' The inverse of [flode_attach()]. Detaches the sub-packages from the search
#' path without unloading them.
#'
#' @param packages Character vector of sub-packages. Defaults to
#'   [flode_packages()].
#'
#' @return Invisibly returns a named logical vector: `TRUE` for each package
#'   that was detached, `FALSE` for each that was not attached.
#' @export
flode_detach <- function(packages = flode_packages()) {
  attached <- paste0("package:", packages) %in% search()
  for (p in packages[attached]) {
    detach(paste0("package:", p), character.only = TRUE, unload = FALSE)
  }
  invisible(stats::setNames(attached, packages))
}

.flode_option_defaults <- list(
  tz       = "UTC",
  data_dir = "data",
  config   = "config/pipeline.yml",
  quiet    = FALSE
)

#' Get or set flode options
#'
#' Shared settings for flode projects, stored as R options named
#' `flode.<name>`. Call with no arguments to see the current values, or with
#' named arguments to set them.
#'
#' Available options:
#' \describe{
#'   \item{`tz`}{Default time zone. Default `"UTC"`.}
#'   \item{`data_dir`}{Project data directory. Default `"data"`.}
#'   \item{`config`}{Path to the pipeline config read by
#'     [reach.utils::load_config()]. Default `"config/pipeline.yml"`, the file
#'     written by [flode_use_project()].}
#'   \item{`quiet`}{If `TRUE`, `library(flode)` does not print the startup
#'     banner. Warnings about missing packages are still shown. Default
#'     `FALSE`.}
#' }
#'
#' @param ... Named options to set. If none are given, the current options
#'   are returned.
#'
#' @return With no arguments, a named list of current values. When setting,
#'   invisibly returns the previous values, so they can be restored with
#'   `do.call(flode_options, old)`.
#' @export
flode_options <- function(...) {
  args <- list(...)
  current <- .flode_options_current()
  if (length(args) == 0L) {
    return(current)
  }
  if (is.null(names(args)) || any(names(args) == "")) {
    cli::cli_abort("All options must be named.")
  }
  unknown <- setdiff(names(args), names(.flode_option_defaults))
  if (length(unknown) > 0L) {
    cli::cli_abort(c(
      "Unknown flode option{?s}: {.val {unknown}}.",
      "i" = "Available options: {.val {names(.flode_option_defaults)}}"
    ))
  }
  do.call(options, stats::setNames(args, paste0("flode.", names(args))))
  invisible(current[names(args)])
}

.flode_options_current <- function() {
  vals <- lapply(names(.flode_option_defaults), function(n) {
    getOption(paste0("flode.", n), .flode_option_defaults[[n]])
  })
  stats::setNames(vals, names(.flode_option_defaults))
}

#' Check that the flode environment is set up
#'
#' Runs a set of checks: R version, GitHub token, `pak`, installed
#' sub-packages, and the project config (if one exists). Each check is
#' reported as `ok`, `warn` or `fail`.
#'
#' @return Invisibly returns a data frame with columns `check`, `status` and
#'   `detail`.
#' @seealso [flode_sitrep()], [flode_install()]
#' @export
flode_doctor <- function() {
  results <- list()
  add <- function(check, status, detail) {
    results[[length(results) + 1L]] <<- data.frame(
      check = check, status = status, detail = detail, stringsAsFactors = FALSE
    )
  }

  rv <- getRversion()
  if (rv >= "4.2.0") add("R version", "ok", as.character(rv))
  else add("R version", "fail", paste(rv, "(flode needs R >= 4.2.0)"))

  has_token <- nzchar(Sys.getenv("GITHUB_PAT")) || nzchar(Sys.getenv("GITHUB_TOKEN"))
  if (has_token) add("GitHub token", "ok", "GITHUB_PAT or GITHUB_TOKEN is set")
  else add("GitHub token", "warn", "not set; GitHub installs may hit rate limits (see usethis::create_github_token())")

  if (.is_installed("pak")) add("pak", "ok", as.character(utils::packageVersion("pak")))
  else add("pak", "warn", "not installed; flode_install() will fall back to remotes")

  missing <- flode_packages()[!vapply(flode_packages(), .is_installed, logical(1L))]
  if (length(missing) == 0L) add("Sub-packages", "ok", "all installed")
  else add("Sub-packages", "fail", paste("not installed:", paste(missing, collapse = ", ")))

  config <- flode_options()$config
  if (!file.exists(config)) {
    add("Pipeline config", "warn", paste0(config, " not found in ", getwd()))
  } else if (!.is_installed("reach.utils")) {
    add("Pipeline config", "warn", "found, but reach.utils is not installed to validate it")
  } else {
    problem <- tryCatch({
      cfg <- reach.utils::load_config(config)
      reach.utils::validate_config(cfg, "activities")
      NULL
    }, error = function(e) conditionMessage(e))
    if (is.null(problem)) add("Pipeline config", "ok", config)
    else add("Pipeline config", "fail", paste0(config, ": ", problem))
  }

  out <- do.call(rbind, results)
  cli::cli_h2("Flode doctor")
  for (i in seq_len(nrow(out))) {
    line <- "{out$check[i]}: {out$detail[i]}"
    switch(out$status[i],
      ok   = cli::cli_alert_success(line),
      warn = cli::cli_alert_warning(line),
      cli::cli_alert_danger(line)
    )
  }
  invisible(out)
}
