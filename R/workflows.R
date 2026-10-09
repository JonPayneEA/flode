# =============================================================================
# Tool: flode workflows
# Description: Example reaches workflows, listed and printed from R
# Flode Module: core
# Author: Forecasting and Warning Team
# Tier: 1
# Dependencies: cli
# =============================================================================

.step <- function(package, task) list(package = package, task = task)

# Example workflows. Each is a title, a description and an ordered list of
# steps. Keep in step with the "Example workflows" section of the README.
.flode_workflows <- list(
  realtime = list(
    title = "Real-time forecasting run",
    description = paste(
      "Observed and meteorological inputs are ingested, transformed to",
      "catchment rainfall and flow, run through the rainfall-runoff models,",
      "corrected and validated."
    ),
    steps = list(
      .step("reach.io",       "Ingest observed rainfall, flow and stage"),
      .step("reach.meteo",    "Ingest radar, temperature, MOSES PE and NWP"),
      .step("reach.rate",     "Transform stage to flow"),
      .step("reach.basin",    "Create Thiessen polygons and calculate weighted rainfall"),
      .step("reach.hydro",    "Run Snowpack then PDM"),
      .step("reach.postproc", "Apply ARMA correction"),
      .step("reach.validate", "Assess model performance")
    )
  ),
  catchment_rainfall = list(
    title = "Catchment average rainfall",
    description = "Turn gauge and radar rainfall into a catchment average.",
    steps = list(
      .step("reach.io",    "Ingest rain gauge observations"),
      .step("reach.meteo", "Ingest radar observations"),
      .step("reach.basin", "Create Thiessen polygons"),
      .step("reach.basin", "Calculate weighted rainfall")
    )
  ),
  rating_conversion = list(
    title = "Stage to flow conversion",
    description = "Convert observed stage to flow and summarise it.",
    steps = list(
      .step("reach.io",    "Ingest observed stage"),
      .step("reach.rate",  "Transform stage to flow"),
      .step("reach.hydro", "Calculate flow statistics")
    )
  ),
  data_qc = list(
    title = "Quality control of observed series",
    description = "Check observed series before they are used for modelling.",
    steps = list(
      .step("reach.io",    "Ingest observed flow"),
      .step("reach.utils", "Run QC checks (gaps, flatlines, bounds, rate of change)"),
      .step("reach.hydro", "Calculate flow statistics on the cleaned series")
    )
  ),
  flood_frequency = list(
    title = "Flood peaks and frequency",
    description = "Extract annual flood peaks from a long flow record.",
    steps = list(
      .step("reach.io",    "Ingest observed flow"),
      .step("reach.utils", "Assign water years and check completeness"),
      .step("reach.hydro", "Extract flood peaks and calculate flow statistics")
    )
  ),
  forecast_correction = list(
    title = "Forecast correction and validation",
    description = "Correct model output against observations and score it.",
    steps = list(
      .step("reach.hydro",    "Model flow output (Snowpack then PDM)"),
      .step("reach.io",       "Ingest observed flow"),
      .step("reach.postproc", "Apply ARMA correction"),
      .step("reach.validate", "Assess model performance")
    )
  )
)

#' List the example flode workflows
#'
#' @return Named character vector: workflow names, with their titles as values.
#' @seealso [flode_workflow()]
#' @export
flode_workflows <- function() {
  vapply(.flode_workflows, function(w) w$title, character(1L))
}

#' Show an example flode workflow
#'
#' Prints the ordered steps of an example workflow and which reaches package
#' handles each one. Packages that are planned but not yet part of flode are
#' flagged.
#'
#' @param name Name of the workflow, as returned by [flode_workflows()].
#'   Defaults to `"realtime"`.
#' @param format `"console"` (default) prints the steps. `"mermaid"` prints a
#'   Mermaid flowchart that can be pasted into a README or Quarto document.
#'
#' @return Invisibly returns a data frame of the steps (`"console"`) or the
#'   Mermaid text (`"mermaid"`).
#' @seealso [flode_workflows()], [flode_use_project()]
#' @export
flode_workflow <- function(name = "realtime", format = c("console", "mermaid")) {
  format <- match.arg(format)
  if (!is.character(name) || length(name) != 1L || !name %in% names(.flode_workflows)) {
    cli::cli_abort(c(
      "Unknown workflow {.val {name}}.",
      "i" = "Available workflows: {.val {names(.flode_workflows)}}"
    ))
  }
  wf <- .flode_workflows[[name]]
  steps <- data.frame(
    step    = seq_along(wf$steps),
    package = vapply(wf$steps, function(s) s$package, character(1L)),
    task    = vapply(wf$steps, function(s) s$task, character(1L)),
    stringsAsFactors = FALSE
  )
  steps$planned <- !steps$package %in% flode_packages()

  if (format == "mermaid") {
    return(invisible(.workflow_mermaid(steps)))
  }

  cli::cli_h2(wf$title)
  cli::cli_text(wf$description)
  for (i in seq_len(nrow(steps))) {
    note <- if (steps$planned[i]) " (planned)" else ""
    cli::cli_text("{steps$step[i]}. {.pkg {steps$package[i]}}{note}: {steps$task[i]}")
  }
  invisible(steps)
}

.workflow_mermaid <- function(steps) {
  ids <- paste0("S", steps$step)
  nodes <- sprintf('  %s["<b>%s</b><br/>%s"]', ids, steps$package, steps$task)
  edges <- if (length(ids) > 1L) {
    paste0("  ", paste(ids, collapse = " --> "))
  } else {
    character(0L)
  }
  styles <- if (any(steps$planned)) {
    sprintf("  style %s stroke-dasharray: 5 5", ids[steps$planned])
  } else {
    character(0L)
  }
  out <- paste(c("flowchart LR", nodes, edges, styles), collapse = "\n")
  cat(out, "\n", sep = "")
  out
}
