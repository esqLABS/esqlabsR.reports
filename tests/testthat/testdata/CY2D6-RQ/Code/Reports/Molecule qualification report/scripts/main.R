main <- function(params) {

  source(file = "scripts/utils.R")

  myProjectConfiguration <- initEsqlabsR(projectConfigurationPath = params$projectConfigurationFile)

  myProjectConfiguration$scenarioDefinitionFile <- paste0("Scenarios_", params$molecule, ".xlsx")

  loadResultFolder <- switch(params$molecule,
                             "Dextromethorphan" = "2023-07-21 12-59",
                             "Paroxetine" = "2023-07-23 21-57")

  scenarioNames <- NULL

  scenarioResults <- simulateScenarios(
    projectConfiguration = myProjectConfiguration,
    loadPreSimulatedResults = params$loadPreSimulatedResults,
    setTestParameters = params$setTestParameters,
    scenarioNames = scenarioNames,
    loadResultsFolder = loadResultFolder,
    saveResultsFolder = file.path('data', params$molecule)
  )

  myProjectConfiguration$dataFolder <- file.path("Data/", params$molecule)

  observedData <- esqlabsR::loadObservedDataFromPKML(myProjectConfiguration)

  myProjectConfiguration$plotsFile <- paste0("Plots_", params$molecule, ".xlsx")

  plotGridNames <- NULL
  allPlots <- createPlotsFromExcel(
    simulatedScenarios = scenarioResults$simulatedScenarios,
    observedData = observedData,
    projectConfiguration = myProjectConfiguration,
    plotGridNames = plotGridNames
  )

  exportConfiguration <- createEsqlabsExportConfiguration(myProjectConfiguration)

  exportConfiguration$path <- file.path('figures', params$molecule)
  # Export each created plot
  for (plotName in names(allPlots)){
    plot <- allPlots[[plotName]]
    # Replace "\" and "/" by "_" so the file name does not result in folders
    plotName <- gsub(pattern = "\\", "_", plotName, fixed = TRUE)
    plotName <- gsub(pattern = "/", "_", plotName, fixed = TRUE)
    exportConfiguration$name <- plotName
    # Save plot
    exportConfiguration$savePlot(plot)
  }
}



