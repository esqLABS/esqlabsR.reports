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
  #simulationRunOptions$checkForNegativeValues <- FALSE

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
