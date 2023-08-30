test_that("initializing new report works", {
  tmp_dir <- withr::local_tempdir()

  new_report("test_report", path = tmp_dir)
  expect_true(file.exists(file.path(tmp_dir,"test_report.qmd")))
})
