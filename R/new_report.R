#' Create a new report
#'
#' @param file_name a string that represent the name of the report that will be created.
#' @param path a string that represent the path where to create the report.
#'
#' @export
#'
#' @examples
#' new_report("my_report", "report_folder/")
new_report <- function(file_name, path = NA) {
  fs::file_copy(
    path = system.file("templates", "esqlabsR.reports.qmd", package = "esqlabsR.reports"),
    new_path = file.path(path, glue::glue("{file_name}.qmd"))
    )
}
