library(testthat)

test_that("flode_workflows() lists named workflows", {
  wfs <- flode_workflows()
  expect_type(wfs, "character")
  expect_true("realtime" %in% names(wfs))
  expect_gt(length(wfs), 1L)
})

test_that("flode_workflow() returns steps and rejects unknown names", {
  steps <- suppressMessages(flode_workflow("realtime"))
  expect_s3_class(steps, "data.frame")
  expect_true(all(c("step", "package", "task", "planned") %in% names(steps)))
  expect_error(flode_workflow("nope"), "Unknown workflow")
})

test_that("flode_workflow() can produce a mermaid flowchart", {
  out <- capture.output(txt <- flode_workflow("realtime", format = "mermaid"))
  expect_match(txt, "^flowchart LR")
  expect_match(txt, "reach.io")
})

test_that("every workflow step names a reach package", {
  pkgs <- unlist(lapply(flode:::.flode_workflows, function(w) {
    vapply(w$steps, function(s) s$package, character(1L))
  }))
  expect_true(all(startsWith(pkgs, "reach.")))
})

test_that("flode_options() gets, sets and restores", {
  expect_named(flode_options(), c("tz", "data_dir", "config"))
  old <- flode_options(tz = "Europe/London")
  on.exit(do.call(flode_options, old), add = TRUE)
  expect_equal(flode_options()$tz, "Europe/London")
  expect_error(flode_options(not_an_option = 1), "Unknown flode option")
})

test_that("flode_detach() reports packages that are not attached", {
  res <- flode_detach(packages = "this.package.is.not.attached")
  expect_false(res[["this.package.is.not.attached"]])
})

test_that("flode_conflicts() returns a data frame", {
  res <- suppressMessages(flode_conflicts(packages = "this.package.does.not.exist"))
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 0L)
})

test_that("flode_use_project() scaffolds a project with a workflow script", {
  skip_if_not_installed("reach.utils")
  dir <- file.path(tempfile("flode-project"))
  suppressMessages(flode_use_project(dir, workflow = "data_qc", readme = FALSE))
  expect_true(file.exists(file.path(dir, "R", "00_workflow.R")))
  expect_true(dir.exists(file.path(dir, "config")))
  expect_error(flode_use_project(dir, workflow = "nope"), "Unknown workflow")
})
