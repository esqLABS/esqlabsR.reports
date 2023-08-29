test_that("initializing new report works with default", {
  tmp_dir <- withr::local_tempdir()

  new_report(report_title = "test_report", path = tmp_dir)
  expect_true(dir.exists(file.path(tmp_dir,"test_report")))
  expect_true(dir.exists(file.path(tmp_dir, "test_report","figures")))
  expect_true(file.exists(file.path(tmp_dir, "test_report","_quarto.yml")))
  # name of the report file should have been replaced by report_title
  expect_true(file.exists(file.path(tmp_dir, "test_report","test_report.qmd")))
  # title of the report should have been replaced by report_title
  expect_equal(readLines(file.path(tmp_dir, "test_report", "test_report.qmd"))[2], "title: test_report")
})
