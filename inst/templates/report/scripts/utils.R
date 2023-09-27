initEsqlabsR <- function(projectConfigurationPath) {
  library(esqlabsR)

  projectConfiguration <- esqlabsR::createDefaultProjectConfiguration(path = projectConfigurationPath)
  return(projectConfiguration)
}


simulateScenarios <- function(projectConfiguration,
                              loadPreSimulatedResults = FALSE,
                              setTestParameters = FALSE,
                              scenarioNames = NULL,
                              loadResultsFolder = NULL,
                              saveResultsFolder = NULL) {
  ########### Initializing and running scenarios########
  ospsuite.utils::validateIsOfType(projectConfiguration, ProjectConfiguration)

  # Create `ScenarioConfiguration` objects from excel files
  scenarioConfigurations <- readScenarioConfigurationFromExcel(
    scenarioNames = scenarioNames,
    projectConfiguration = projectConfiguration
  )

  # Adjust simulation run options, if necessary.
  # E.g. disable check for negative values if required
  simulationRunOptions <- SimulationRunOptions$new()
  # simulationRunOptions$checkForNegativeValues <- FALSE

  customParams <- NULL
  # Apply parameters defined in "InputCoode/TestParameters.R"
  if (setTestParameters) {
    customParams <- getTestParameters(customParams)
  }

  # Run or load scenarios
  if (loadPreSimulatedResults) {
    simulatedScenariosResults <- loadScenarioResults(
      names(scenarioConfigurations),
      file.path(projectConfiguration$outputFolder, "SimulationResults", loadResultsFolder)
    )

    return(list(simulatedScenarios = simulatedScenariosResults))
  } else {
    # Create scenarios
    scenarios <- createScenarios(scenarioConfigurations = scenarioConfigurations, customParams = customParams)

    simulatedScenariosResults <- runScenarios(
      scenarios = scenarios,
      simulationRunOptions = simulationRunOptions
    )
    saveScenarioResults(simulatedScenariosResults, projectConfiguration, saveResultsFolder)
  }

  # Return simulated scenarios
  return(list(simulatedScenarios = simulatedScenariosResults))
}

getTestParameters <- function(params) {
  paramVals <- enum(list(
    #    "Neighborhoods|Periportal_pls_Periportal_int|Insulin|ActiveTransport_Pl2Int|k_activeTransport" = 0.005
  ))

  paramUnits <- enum(list(
    # "Neighborhoods|Periportal_pls_Periportal_int|Insulin|ActiveTransport_Pl2Int|k_activeTransport" = "cm/min"
  ))

  # Construct the default parameters structure
  paths <- names(paramVals)
  values <- unname(paramVals[paths])
  units <- unname(paramUnits[paths])

  return(list(paths = paths, values = values, units = units))
}

getResultsFolder <- function(projectConfiguration, resultsFolder, resultsSubFolder) {
  if (is.null(resultsFolder)) {
    resultsFolder <- projectConfiguration$outputFolder
  } else {
    resultsFolder <- resultsFolder
  }

  if (!is.null(resultsSubFolder)) {
    resultsFolder <- file.path(resultsFolder, resultsSubFolder)
  }
}
