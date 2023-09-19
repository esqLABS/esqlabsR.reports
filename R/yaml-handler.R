editYaml <- function(file_path, args) {

  original_yaml <- extractYaml(text = readLines(file_path))

  new_yaml <- original_yaml

  for (arg in names(args)) {
    if(!is.na(args[[arg]])){
      new_yaml[[arg]] <- args[[arg]]
    }
  }

  replaceYaml(file_path = file_path,
              new_yaml =  new_yaml)

}


#' Get YAML header from a text vector
#'
#' @param text a vector of string the text read from a file
#'
#' @return a list representing the yaml that can be exported back to yaml format
#'
#' @examples
extractYaml <- function(text) {

  yaml_lines_index <- getYamlStartEnd(text = text)

  yaml <- yaml::read_yaml(text = text[yaml_lines_index[1]:yaml_lines_index[2]])

  return(yaml)

}


#' Replace yaml header of a file
#'
#' @param file_path a string representing the file containing the yaml header to replace.
#' @param new_yaml a list representing the yaml header to inject
#' @export
#'
#' @examples
replaceYaml <- function(file_path, new_yaml) {

  text <- readLines(file_path)

  yaml_start_end <- getYamlStartEnd(text = text, only_content = FALSE)

  text_without_yaml <- text[-c(yaml_start_end[1]:yaml_start_end[2])]

  text_with_new_yaml <- c("---",
                          yaml::as.yaml(new_yaml),
                          "---",
                          text_without_yaml)

  writeLines(text_with_new_yaml, file_path)

}

#' Identify where the yaml header starts and end in a file
#'
#' @param text a string vector containing the read lines of a file
#' @param only_content a logical defining if the returned index should be for
#' the yaml delimiters or the yaml content.
#'
#' @return a numeric vector of size two representing the index
#' @export
#'
#' @examples
getYamlStartEnd <- function(text, only_content = TRUE) {
  yaml_delimiters_index <- which(text == "---")

  if (only_content) {
    index_correction = 1
  } else {
    index_correction = 0
  }

  yaml_lines_start_index <- yaml_delimiters_index[1]+index_correction
  yaml_lines_end_index <- yaml_delimiters_index[2]-index_correction

  return(c(yaml_lines_start_index, yaml_lines_end_index))

}
