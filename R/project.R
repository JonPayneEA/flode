# =============================================================================
# Tool: flode project scaffolding
# Description: Start a new forecasting project on top of reach.utils
# Flode Module: core
# Author: Forecasting and Warning Team
# Tier: 1
# Dependencies: reach.utils, cli
# =============================================================================

#' Start a new flode project
#'
#' Scaffolds a project with [reach.utils::create_project()] (folders,
#' `config/pipeline.yml`, `.gitignore`, optional README) and, if a workflow is
#' chosen, adds `R/00_workflow.R`: a starter script that loads flode and lists
#' that workflow's steps as comments to fill in.
#'
#' @param path Root directory of the project. Defaults to the working
#'   directory.
#' @param workflow Name of an example workflow from [flode_workflows()], or
#'   `NULL` to skip the starter script. Default `"realtime"`.
#' @param author Author name, forwarded to [reach.utils::create_readme()].
#' @param readme,config,gitignore Logicals forwarded to
#'   [reach.utils::create_project()].
#'
#' @return `path` invisibly.
#' @seealso [flode_workflow()], [reach.utils::create_project()]
#' @export
#'
#' @examples
#' \dontrun{
#' flode_use_project("~/projects/river-forecast", workflow = "realtime",
#'                   author = "Forecasting and Warning Team")
#' }
flode_use_project <- function(
  path      = getwd(),
  workflow  = "realtime",
  author    = NULL,
  readme    = TRUE,
  config    = TRUE,
  gitignore = TRUE
) {
  if (!is.null(workflow) &&
      (!is.character(workflow) || length(workflow) != 1L ||
       !workflow %in% names(.flode_workflows))) {
    cli::cli_abort(c(
      "Unknown workflow {.val {workflow}}.",
      "i" = "Available workflows: {.val {names(.flode_workflows)}}"
    ))
  }

  path <- reach.utils::create_project(
    path      = path,
    config    = config,
    readme    = readme,
    gitignore = gitignore,
    author    = author
  )

  if (!is.null(workflow)) {
    script <- file.path(path, "R", "00_workflow.R")
    if (file.exists(script)) {
      cli::cli_inform("Skipped (already exists): {.path {script}}")
    } else {
      writeLines(.workflow_script(workflow), script)
      cli::cli_inform("Created: {.path {script}}")
    }
  }

  invisible(path)
}

.workflow_script <- function(name) {
  wf <- .flode_workflows[[name]]
  steps <- vapply(seq_along(wf$steps), function(i) {
    s <- wf$steps[[i]]
    paste0("# ", i, ". ", s$package, ": ", s$task, "\n# ...\n")
  }, character(1L))
  c(
    paste0("# Workflow: ", wf$title),
    paste0("# ", wf$description),
    "# See flode::flode_workflow() for the full list of steps.",
    "",
    "library(flode)",
    "",
    "# Project settings live in config/pipeline.yml",
    'cfg <- reach.utils::load_config("config/pipeline.yml")',
    "",
    steps
  )
}
