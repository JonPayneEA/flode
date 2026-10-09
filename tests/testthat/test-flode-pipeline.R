library(testthat)

# Integration tests: a pipeline config is run end to end through
# flode_workflow_run() and reach.utils::run_pipeline().

write_pipeline <- function(activities) {
  path <- tempfile(fileext = ".yml")
  yaml::write_yaml(list(activities = activities), path)
  path
}

test_that("flode_workflow_run() fails clearly when the config is missing", {
  expect_error(flode_workflow_run(tempfile(fileext = ".yml")), "Config file not found")
})

test_that("flode_workflow_run() runs a registered activity end to end", {
  skip_if_not_installed("reach.utils")
  skip_if_not_installed("yaml")
  reach.utils::register_activity(
    "flode_test_double", function(x) x * 2, package = "reach.utils"
  )
  path <- write_pipeline(list(
    list(name = "flode_test_double", package = "reach.utils", args = list(x = 21))
  ))
  res <- suppressMessages(flode_workflow_run(path))
  expect_equal(res[["reach.utils::flode_test_double"]], 42)
})

test_that("flode_workflow_run(dry_run = TRUE) reports unregistered activities", {
  skip_if_not_installed("reach.utils")
  skip_if_not_installed("yaml")
  reach.utils::register_activity(
    "flode_test_double", function(x) x * 2, package = "reach.utils"
  )
  path <- write_pipeline(list(
    list(name = "flode_test_double", package = "reach.utils"),
    list(name = "no_such_activity",  package = "reach.utils")
  ))
  res <- suppressMessages(flode_workflow_run(path, dry_run = TRUE))
  expect_equal(res$registered, c(TRUE, FALSE))
})

test_that("flode_workflow_run() warns when a workflow package has no activity", {
  skip_if_not_installed("reach.utils")
  skip_if_not_installed("yaml")
  reach.utils::register_activity(
    "flode_test_double", function(x) x * 2, package = "reach.utils"
  )
  path <- write_pipeline(list(
    list(name = "flode_test_double", package = "reach.utils")
  ))
  expect_warning(
    suppressMessages(flode_workflow_run(path, workflow = "rating_conversion", dry_run = TRUE)),
    "no activities"
  )
})

test_that("all core sub-packages attach together", {
  skip_on_cran()
  pkgs <- flode_packages()
  skip_if_not(all(vapply(pkgs, flode:::.is_installed, logical(1L))),
              "not every sub-package is installed")
  res <- suppressMessages(flode_attach(quietly = TRUE))
  expect_true(all(res))
})
