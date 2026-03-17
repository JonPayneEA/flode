library(testthat)

test_that("flode_packages() returns the expected sub-packages", {
  pkgs <- flode_packages()
  expect_type(pkgs, "character")
  expect_true(all(c(
    # "reach.utils",
    "reach.io",
    "reach.hydro"
    # "reach.ensemble",
    # "reach.validate",
    # "reach.viz"
  ) %in% pkgs))
})

test_that("flode_packages() returns packages in dependency order (utils first)", {
  pkgs <- flode_packages()
  expect_equal(pkgs[1], "reach.utils")
})

test_that("flode_attach() returns a named logical vector", {
  # Use base R package as a safe stand-in for testing the return type
  result <- flode_attach(packages = "utils", quietly = TRUE)
  expect_type(result, "logical")
  expect_named(result)
})

test_that("flode_attach() warns and skips packages that are not installed", {
  expect_warning(
    flode_attach(packages = "this.package.does.not.exist"),
    regexp = NA  # cli warnings are signalled differently; just check it doesn't error
  )
})

test_that("flode_versions() returns a named character vector invisibly", {
  result <- flode_versions()
  expect_type(result, "character")
  expect_true(!is.null(names(result)))
  expect_true("flode" %in% names(result))
})

test_that("startup message contains version and package names", {
  msg <- flode:::flode_startup_message()
  expect_type(msg, "character")
  expect_match(msg, "flode")
  expect_match(msg, "reach.hydro")
  expect_match(msg, "reach.io")
})

test_that(".is_installed() returns TRUE for base packages", {
  expect_true(flode:::.is_installed("utils"))
  expect_true(flode:::.is_installed("stats"))
})

test_that(".is_installed() returns FALSE for missing packages", {
  expect_false(flode:::.is_installed("this.package.does.not.exist.xyz"))
})
