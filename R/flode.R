# =============================================================================
# Tool: flode meta-package
# Description: Loads and attaches all flode sub-packages on library(flode)
# Flode Module: core
# Author: Forecasting and Warning Team
# Created: 2026-02-01
# Tier: 1
# Dependencies: reach.io, reach.hydro, reach.ensemble, reach.validate,
#               reach.viz, reach.utils, cli
# =============================================================================

#' @keywords internal
"_PACKAGE"

# The sub-packages that flode loads, in dependency order
.flode_packages <- c(
  "reach.utils",
  "reach.io",
  "reach.hydro",
  "reach.viz",
  "reach.basin"
  # "reach.ensemble",
  # "reach.validate"
)

# .onAttach runs when the user calls library(flode)
.onAttach <- function(libname, pkgname) {
  packageStartupMessage(flode_startup_message())
  attach_flode_packages()
}

#' Attach all flode sub-packages
#'
#' Called automatically by `.onAttach`. Can also be called manually to
#' re-attach packages if needed (e.g. after a detach).
#'
#' @param packages Character vector of package names to attach.
#'   Defaults to all core flode sub-packages.
#' @param quietly Logical. Suppress individual package startup messages.
#'   Default `TRUE`.
#'
#' @return Invisibly returns a named logical vector: `TRUE` for each
#'   package successfully attached, `FALSE` for each failure.
#'
#' @export
flode_attach <- function(packages = flode_packages(), quietly = TRUE) {
  not_installed <- packages[!vapply(packages, .is_installed, logical(1L))]

  if (length(not_installed) > 0L) {
    cli::cli_warn(c(
      "The following flode sub-packages are not installed and will be skipped:",
      "!" = paste(not_installed, collapse = ", "),
      "i" = "Install with: {.run install.packages(c({paste0('\"', not_installed, '\"', collapse = ', ')}))}",
      "i" = "Or from the team repo: {.run remotes::install_git('https://git.internal/forecasting/flode-pkgs')}"
    ))
    packages <- setdiff(packages, not_installed)
  }

  results <- vapply(packages, function(pkg) {
    tryCatch({
      suppressPackageStartupMessages(
        do.call(
          "library",
          list(pkg, quietly = quietly, warn.conflicts = FALSE)
        )
      )
      TRUE
    }, error = function(e) {
      cli::cli_warn("Failed to attach {.pkg {pkg}}: {conditionMessage(e)}")
      FALSE
    })
  }, logical(1L))

  invisible(results)
}

#' List the core flode sub-packages
#'
#' @return Character vector of sub-package names, in load order.
#' @export
flode_packages <- function() .flode_packages

#' Report the version of each flode sub-package
#'
#' Prints a table of each sub-package and its installed version.
#' Packages that are not installed are flagged.
#'
#' @return Invisibly returns a named character vector of versions.
#' @export
flode_versions <- function() {
  pkgs <- c("flode", flode_packages())
  vers <- vapply(pkgs, function(p) {
    if (.is_installed(p)) as.character(utils::packageVersion(p)) else NA_character_
  }, character(1L))

  cli::cli_h2("Flode package versions")
  for (i in seq_along(pkgs)) {
    if (is.na(vers[i])) {
      cli::cli_alert_danger("{pkgs[i]}: not installed")
    } else {
      cli::cli_alert_success("{pkgs[i]} {.field {vers[i]}}")
    }
  }
  invisible(vers)
}

#' Update all flode sub-packages
#'
#' Convenience wrapper: re-installs all flode sub-packages from the team's
#' internal Git repository. Requires `remotes`.
#'
#' @param repo Character. Base URL of the team Git platform.
#' @param ... Additional arguments passed to [remotes::install_git()].
#'
#' @export
flode_update <- function(repo = "https://git.internal/JonPayneEA", ...) {
  flode_check_pkg("remotes", "flode_update()")
  pkgs <- c("flode", flode_packages())
  cli::cli_h2("Updating flode packages")
  for (pkg in pkgs) {
    url <- paste0(repo, "/", pkg)
    cli::cli_progress_step("Installing {pkg} from {url}")
    remotes::install_git(url, quiet = TRUE, ...)
  }
  cli::cli_alert_success("All flode packages updated. Restart R to use the new versions.")
}

# ---- Internal helpers -------------------------------------------------------

attach_flode_packages <- function() {
  results <- flode_attach(quietly = TRUE)
  failed  <- names(results[!results])
  if (length(failed) > 0L) {
    packageStartupMessage(
      "Note: the following sub-packages could not be loaded: ",
      paste(failed, collapse = ", ")
    )
  }
}

flode_startup_message <- function() {
  pkgs    <- flode_packages()
  ver     <- tryCatch(
    as.character(utils::packageVersion("flode")),
    error = function(e) "dev"
  )

  pkg_vers <- vapply(pkgs, function(p) {
    if (.is_installed(p)) {
      paste0(p, " ", utils::packageVersion(p))
    } else {
      paste0(p, " [not installed]")
    }
  }, character(1L))

  # Split into two columns
  n      <- length(pkg_vers)
  half   <- ceiling(n / 2)
  left   <- pkg_vers[seq_len(half)]
  right  <- if (n > half) pkg_vers[(half + 1):n] else character(0L)
  width  <- max(nchar(left)) + 2L
  rows   <- mapply(
    function(l, r) formatC(l, width = width, flag = "-"),
    left,
    c(right, rep("", half - length(right)))
  )

  header <- paste0(
    "\n-- flode ", ver,
    " -- Forecasting Operations and Development Environment --\n"
  )
  body   <- paste(
    "v Attaching core packages:",
    paste(paste0("  ", rows), collapse = "\n"),
    sep = "\n"
  )

  paste0(header, body, "\n")
}

.is_installed <- function(pkg) {
  requireNamespace(pkg, quietly = TRUE)
}

flode_check_pkg <- function(pkg, context) {
  if (!.is_installed(pkg)) {
    cli::cli_abort(c(
      "{.pkg {pkg}} is required for {.fn {context}}.",
      "i" = "Install with: {.run install.packages('{pkg}')}"
    ))
  }
}
