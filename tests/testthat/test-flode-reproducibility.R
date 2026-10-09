library(testthat)

test_that("flode_snapshot() returns versions without writing when path is NULL", {
  snap <- suppressWarnings(suppressMessages(flode_snapshot(path = NULL)))
  expect_s3_class(snap, "data.frame")
  expect_named(snap, c("package", "version", "owner", "repo", "sha"))
})

test_that("flode_snapshot() writes a YAML file that flode_restore() can read", {
  skip_if_not_installed("yaml")
  path <- tempfile(fileext = ".yml")
  suppressWarnings(suppressMessages(flode_snapshot(path = path)))
  expect_true(file.exists(path))
  expect_true(is.list(yaml::read_yaml(path)$flode_snapshot))
})

test_that("flode_restore() fails clearly when the snapshot is missing", {
  expect_error(flode_restore(tempfile(fileext = ".yml")), "Snapshot file not found")
})

test_that("flode_doctor() returns a data frame of checks", {
  res <- suppressMessages(flode_doctor())
  expect_s3_class(res, "data.frame")
  expect_named(res, c("check", "status", "detail"))
  expect_true(all(res$status %in% c("ok", "warn", "fail")))
})

test_that("flode.quiet is a known option", {
  expect_true("quiet" %in% names(flode_options()))
})
