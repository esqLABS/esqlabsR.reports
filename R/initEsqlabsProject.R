initEsqlabsProject <- function(){
  library(esqlabsR)
  library(rjson)
  pkSimPath <- "PKSim"
  # For local testing, if required

  initPKSim(pkSimPath)
  sourceAll(file.path(getwd(), "utils"))
  sourceAll(file.path(getwd(), "InputCode"))
  sourceAll(file.path(getwd(), "Scenarios"))
  sourceAll(file.path(getwd(), "TransferFunctions"))
  sourceAll(file.path(getwd(), "Report/utilities-report"))
  # Maybe have to provide a path to the file when using in tests, as current wd
  # will be different
  projectConfiguration <- esqlabsR::createDefaultProjectConfiguration(path = "../ProjectConfiguration.xlsx")

  return(projectConfiguration)
}
