#' Create a new report
#'
#' @param file_name
#' @param path
#'
#' @return
#' @export
#'
#' @examples
new_report <- function(file_name, path = NA) {
  fs::file_copy(
    path = system.file("templates", "esqlabsR.reports.qmd", package = "esqlabsR.reports"),
    new_path = file.path(path, glue::glue("{file_name}.qmd"))
    )
}
