#' Create a new report
#'
#' @param file_name a string that represent the name of the report that will be created.
#' @param path a string that represent the path where to create the report.
#' @param subtitle the subtitle of the report. empty by default.
#' @param author the name of the author(s). "esqlabs Gmbh" by default.
#' @param datetime the date time that will appear on the report in "YYYY-MM-DD HH:MM:SS" format. default to time of generation of the report.
#'
#' @export
#'
#' @examples
#' newReport("my_report", "report_folder/")
newReport <- function(report_title, path = "Reports/", subtitle = NA, author = NA, datetime = NA) {

  template_dir <- system.file("templates/template", package = "esqlabsR.reports")
  target_dir <- file.path(path, report_title)
  project_filename <- glue::glue("{report_title}.Rproj")
  project_fullpath <- file.path(target_dir, project_filename)
  report_filename <-  glue::glue("{report_title}.qmd")
  report_fullpath <- file.path(target_dir, report_filename)

  fs::dir_copy(path = template_dir, new_path = target_dir)

  file.rename(file.path(target_dir, "template.Rproj"),
              project_fullpath)

  file.rename(file.path(target_dir, "template.qmd"),
              report_fullpath)

  args <- list(title = report_title,
               subtitle = subtitle,
               author = author,
               date = datetime)

  edit_yaml(report_fullpath, args)

  if(interactive()){
    rstudioapi::openProject(project_fullpath)
  }

}

