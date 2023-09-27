main <- function(params) {
  # Load libraries
  library(esqlabsR)

  # Initialize project configuration
  projectConfiguration <- esqlabsR::createDefaultProjectConfiguration(path = params$projectConfigurationFile)

  # Setup scenarios
  scenarioConfigurations <- readScenarioConfigurationFromExcel(
    scenarioNames = "TestScenario",
    projectConfiguration = projectConfiguration
  )


  # Load or Run Simulation
  resultsFolder <- getResultsFolder(projectConfiguration, params$resultsFolder, params$resultsSubFolder)

  if (params$loadPreSimulatedResults) {
    simulatedScenariosResults <-
      loadScenarioResults(
        scenarioNames = names(scenarioConfigurations),
        resultsFolder = resultsFolder
      )

    simulatedScenarios <- simulatedScenariosResults
  } else {
    scenarios <- createScenarios(scenarioConfigurations = scenarioConfigurations)

    simulatedScenariosResults <- runScenarios(
      scenarios = scenarios
    )
    saveScenarioResults(simulatedScenariosResults, projectConfiguration, resultsFolder)

    simulatedScenarios <- simulatedScenariosResults
  }


  # Load observed data
  dataSheets <- "Laskin 1982.Group A"
  observedData <- loadObservedData(projectConfiguration = projectConfiguration, sheets = dataSheets)

  # Generate plots
  plots <- createPlotsFromExcel(
    simulatedScenarios = simulatedScenarios,
    observedData = observedData,
    projectConfiguration = projectConfiguration
  )

  # Setup plot export configuration
  exportConfiguration <- createEsqlabsExportConfiguration(projectConfiguration)
  exportConfiguration$path <- params$figuresFolder

  # Export each plot
  for (plotName in names(plots)) {
    plot <- plots[[plotName]]
    # Replace "\" and "/" by "_" so the file name does not result in folders
    plotName <- gsub(pattern = "\\", "_", plotName, fixed = TRUE)
    plotName <- gsub(pattern = "/", "_", plotName, fixed = TRUE)
    exportConfiguration$name <- plotName
    # Save plot
    exportConfiguration$savePlot(plot)
  }
}
