# =============================================================================
# Tool: flode pipeline runner
# Description: Run a workflow from a reach.utils pipeline config
# Flode Module: core
# Author: Forecasting and Warning Team
# Tier: 1
# Dependencies: reach.utils, cli
# =============================================================================

# Load the sub-packages so each can register its activities in .onLoad
.load_flode_namespaces <- function() {
  for (p in flode_packages()) {
    if (.is_installed(p)) loadNamespace(p)
  }
  invisible(NULL)
}

.activity_field <- function(activity, field) {
  value <- activity[[field]]
  if (is.null(value)) NA_character_ else as.character(value)
}

#' List the activities registered by the flode sub-packages
#'
#' Loads the installed sub-packages, so they register their activities with
#' [reach.utils::register_activity()], then lists what is available to a
#' pipeline config.
#'
#' @return Invisibly returns a data frame with columns `package` and
#'   `activity`.
#' @seealso [flode_workflow_run()]
#' @export
flode_activities <- function() {
  .load_flode_namespaces()
  keys <- reach.utils::list_activities()
  out <- data.frame(
    package  = sub("::.*$", "", keys),
    activity = sub("^.*::", "", keys),
    stringsAsFactors = FALSE
  )
  cli::cli_h2("Registered activities")
  if (nrow(out) == 0L) {
    cli::cli_alert_info("No activities are registered.")
  } else {
    for (p in unique(out$package)) {
      cli::cli_text("{.pkg {p}}: {out$activity[out$package == p]}")
    }
  }
  invisible(out)
}

#' Run a workflow from a pipeline config
#'
#' Loads the flode sub-packages and then runs a `pipeline.yml` with
#' [reach.utils::run_pipeline()]. Each entry in the config's `activities` is
#' dispatched, in order, to a function registered by one of the packages. See
#' [flode_activities()] for what is available, and [flode_use_project()] for a
#' starter config.
#'
#' @param config Path to the pipeline config. Defaults to the `config` option
#'   from [flode_options()].
#' @param workflow Optional name of an example workflow from
#'   [flode_workflows()]. If given, a warning lists any of the workflow's
#'   packages that have no activity in the config.
#' @param dry_run Logical. If `TRUE`, check that every activity in the config
#'   is registered, without running anything. Default `FALSE`.
#'
#' @return The named list returned by [reach.utils::run_pipeline()], invisibly.
#'   With `dry_run = TRUE`, a data frame with columns `activity` and
#'   `registered`.
#' @seealso [flode_activities()], [flode_workflow()]
#' @export
flode_workflow_run <- function(
  config   = flode_options()$config,
  workflow = NULL,
  dry_run  = FALSE
) {
  if (!file.exists(config)) {
    cli::cli_abort(c(
      "Config file not found: {.path {config}}",
      "i" = "Create a project with a starter config using {.run flode::flode_use_project()}."
    ))
  }
  if (!is.null(workflow) &&
      (!is.character(workflow) || length(workflow) != 1L ||
       !workflow %in% names(.flode_workflows))) {
    cli::cli_abort(c(
      "Unknown workflow {.val {workflow}}.",
      "i" = "Available workflows: {.val {names(.flode_workflows)}}"
    ))
  }

  .load_flode_namespaces()
  cfg <- reach.utils::load_config(config)
  acts <- cfg$activities
  if (!is.list(acts) || length(acts) == 0L) {
    cli::cli_abort("Config key {.val activities} must be a non-empty list.")
  }
  pkgs <- vapply(acts, .activity_field, character(1L), field = "package")
  nms  <- vapply(acts, .activity_field, character(1L), field = "name")

  if (!is.null(workflow)) {
    steps <- .flode_workflows[[workflow]]$steps
    wanted <- intersect(
      unique(vapply(steps, function(s) s$package, character(1L))),
      flode_packages()
    )
    absent <- setdiff(wanted, pkgs)
    if (length(absent) > 0L) {
      cli::cli_warn(c(
        "The config has no activities for some packages in workflow {.val {workflow}}:",
        "!" = paste(absent, collapse = ", ")
      ))
    }
  }

  if (!dry_run) {
    return(invisible(reach.utils::run_pipeline(config)))
  }

  keys <- paste0(pkgs, "::", nms)
  registered <- keys %in% reach.utils::list_activities()
  cli::cli_h2("Dry run: {.path {config}}")
  for (i in seq_along(keys)) {
    if (registered[i]) {
      cli::cli_alert_success("{keys[i]}")
    } else {
      cli::cli_alert_danger("{keys[i]}: not registered")
    }
  }
  invisible(data.frame(activity = keys, registered = registered, stringsAsFactors = FALSE))
}
