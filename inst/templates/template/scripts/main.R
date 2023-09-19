main <- function(params) {

  source(file = "scripts/utils.R")

  myProjectConfiguration <- initEsqlabsR(projectConfigurationPath = params$projectConfigurationFile)

  scenarioNames <- NULL

  scenarioResults <- simulateScenarios(
    projectConfiguration = myProjectConfiguration,
    loadPreSimulatedResults = params$loadPreSimulatedResults,
    setTestParameters = params$setTestParameters,
    scenarioNames = scenarioNames,
    loadResultsFolder = params$loadResultsFolder,
    saveResultsFolder = params$saveResultsFolder
  )

  observedData <- esqlabsR::loadObservedDataFromPKML(myProjectConfiguration)

  # Or load from excel
  dataSheets <- c("Sheet 1")

  observedData <- esqlabsR::loadObservedData(
    projectConfiguration = myProjectConfiguration,
    sheets = dataSheets
  )

  plotGridNames <- NULL
  allPlots <- createPlotsFromExcel(
    simulatedScenarios = scenarioResults$simulatedScenarios,
    observedData = observedData,
    projectConfiguration = myProjectConfiguration,
    plotGridNames = plotGridNames
  )

  # Export plots to png
  #Create export configuration that will be used for exporting plots.
  exportConfiguration <- createEsqlabsExportConfiguration(myProjectConfiguration)
  # Figures should be saved in the same folder as the location of the report
  # plus subfolder "Figures"
  exportConfiguration$path <- params$saveFiguresFolder
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



