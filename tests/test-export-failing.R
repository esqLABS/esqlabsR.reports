library(esqlabsR)
setwd("./example-project/CY2D6-RQ/Code")

params <- list()
# If `TRUE`, results will be loaded
params$loadPreSimulatedResults <-  TRUE
# Sub-folder where simulated results is located, in case `loadPreSimulatedResults`
# is `TRUE`. If `NULL`, default results folder as specified in `ProjectConfiguration`
# is used.
params$loadResultsFolder <- "2023-07-21 12-59"
# Sub-folder where the results will be stored. If NULL, a folder in the "Results"
# folder with current data name will be created.
params$saveResultsFolder <- NULL
# If TRUE, parameters defined in "InputCode/TestParameters.R" will be applied to all
# simulations
params$setTestParameters <- FALSE
# If set to TRUE, only static content of the report will be generated,
# i.e., R code will not be executed
params$createOnlyStaticContent <- FALSE

source("Report/utilities-report/initEsqlabsProject.R")
projectConfiguration <- initEsqlabsProject()

scenarioNames <- c(
  "Antecip Bioventures EM, 60 mg dextromethorphan hydrobromide multiple dose (capsule_solution), n=10_v9.1",
  # "Armani 2017 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=20_v9.1",
  # "Capon 1996 EM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=6_v9.1",
  # "Capon 1996 PM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=6_v9.1",
  # "Duedahl 2005 EM, 0.5 mg_kg dextromethorphan base (infusion), n=24_v9.1",
  # "Dumond 2010 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=23_v9.1",
  # "Edwards 2017 EM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=48_v9.1",
  # "Ermer 2015 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=30_v9.1",
  # "Feld 2013 EM, 60 mg dextromethorphan hydrobromide (capsule_solution), n=17_v9.1",
  # "Gazzaz 2018 NM, 30 mg dextromethorphan hydrobromide (cocktail), n=30, AS=1.25_v9.1",
  # "Gorski 2004 EM, 30 mg dextromethorphan hydromide (capsule_solution), n=11_v9.1",
  # "Gorski 2004 PM, 30 mg dextromethorphan hydromide (capsule_solution), n=1_v9.1",
  # "Kakuda 2014 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=14_v9.1",
  # "Khalilieh 2018 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=20_v9.1",
  # "Nakashima 2007 EM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=24_v9.1",
  # "Nyunt 2008 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=12_v9.1",
  # "Qiu 2016 IM, 15 mg dextromethorphan hydrobromide (capsule_solution), n=6, AS=0.5_v9.1",
  # "Qiu 2016 NM, 15 mg dextromethorphan hydrobromide (capsule_solution), n=6, AS=1.25_v9.1",
  # "Qiu 2016 NM, 15 mg dextromethorphan hydrobromide (capsule_solution), n=6, AS=2_v9.1",
  # "Sager 2014 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=10_v9.1",
  # "Schadel 1995 EM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=5_v9.1",
  # "Schadel 1995 PM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=4_v9.1",
  # "Stage 2018 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=12_v9.1",
  # "Storelli 2018 IM, 5 mg dextromethorphan base (capsule_solution), n=16_v9.1",
  # "Storelli 2018 NM, 5 mg dextromethorphan base (capsule_solution), n=17, AS=2_v9.1",
  # "Tennezé 1999 EM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=36_v9.1",
  # "Yamazaki 2017 IM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=12, AS=0.5_v9.1",
  # "Yamazaki 2017 NM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=11, AS=2_v9.1",
  # "Zawertailo 2009 NM, 3 mg_kg dextromethorphan hydrobromide (capsule_solution), n=6, AS=2_v9.1",
   "Antecip Bioventures EM, 60 mg dextromethorphan hydrobromide multiple dose (capsule_solution), n=10_v11.2"
  # "Armani 2017 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=20_v11.2",
  # "Capon 1996 EM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=6_v11.2",
  # "Capon 1996 PM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=6_v11.2",
  # "Duedahl 2005 EM, 0.5 mg_kg dextromethorphan base (infusion), n=24_v11.2",
  # "Dumond 2010 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=23_v11.2",
  # "Edwards 2017 EM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=48_v11.2",
  # "Ermer 2015 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=30_v11.2",
  # "Feld 2013 EM, 60 mg dextromethorphan hydrobromide (capsule_solution), n=17_v11.2",
  # "Gazzaz 2018 NM, 30 mg dextromethorphan hydrobromide (cocktail), n=30, AS=1.25_v11.2",
  # "Gorski 2004 EM, 30 mg dextromethorphan hydromide (capsule_solution), n=11_v11.2",
  # "Gorski 2004 PM, 30 mg dextromethorphan hydromide (capsule_solution), n=1_v11.2",
  # "Kakuda 2014 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=14_v11.2",
  # "Khalilieh 2018 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=20_v11.2",
  # "Nakashima 2007 EM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=24_v11.2",
  # "Nyunt 2008 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=12_v11.2",
  # "Qiu 2016 IM, 15 mg dextromethorphan hydrobromide (capsule_solution), n=6, AS=0.5_v11.2",
  # "Qiu 2016 NM, 15 mg dextromethorphan hydrobromide (capsule_solution), n=6, AS=1.25_v11.2",
  # "Qiu 2016 NM, 15 mg dextromethorphan hydrobromide (capsule_solution), n=6, AS=2_v11.2",
  # "Sager 2014 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=10_v11.2",
  # "Schadel 1995 EM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=5_v11.2",
  # "Schadel 1995 PM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=4_v11.2",
  # "Stage 2018 EM, 30 mg dextromethorphan hydrobromide (cocktail), n=12_v11.2",
  # "Storelli 2018 IM, 5 mg dextromethorphan base (capsule_solution), n=16_v11.2",
  # "Storelli 2018 NM, 5 mg dextromethorphan base (capsule_solution), n=17, AS=2_v11.2",
  # "Tennezé 1999 EM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=36_v11.2",
  # "Yamazaki 2017 IM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=12, AS=0.5_v11.2",
  # "Yamazaki 2017 NM, 30 mg dextromethorphan hydrobromide (capsule_solution), n=11, AS=2_v11.2",
  # "Zawertailo 2009 NM, 3 mg_kg dextromethorphan hydrobromide (capsule_solution), n=6, AS=2_v11.2"
)
scenarioResults <- simulateScenarios(
  projectConfiguration = projectConfiguration,
  loadPreSimulatedResults = params$loadPreSimulatedResults,
  setTestParameters = params$setTestParameters,
  scenarioNames = scenarioNames,
  loadResultsFolder = params$loadResultsFolder,
  saveResultsFolder = params$saveResultsFolder
)

observedData <- esqlabsR::loadObservedDataFromPKML(projectConfiguration)

plotGridNames <- NULL
plotGridNames <- "Antecip Bioventures EM, 60 mg dextromethorphan hydrobromide multiple dose (capsule/solution), n=10"
allPlots <- createPlotsFromExcel(
  simulatedScenarios = scenarioResults$simulatedScenarios,
  observedData = observedData,
  projectConfiguration = projectConfiguration,
  plotGridNames = plotGridNames
)

exportConfiguration <- createEsqlabsExportConfiguration(projectConfiguration)
# Figures should be saved in the same folder as the location of the report
# plus subfolder "Figures"
exportConfiguration$path <- file.path(getwd(), "Figures")
# Export each created plot
for (plotName in names(allPlots)){
  print(plotName)
  plot <- allPlots[[plotName]]
  # Replace "\" and "/" by "_" so the file name does not result in folders
  plotName <- gsub(pattern = "\\", "_", plotName, fixed = TRUE)
  plotName <- gsub(pattern = "/", "_", plotName, fixed = TRUE)
  exportConfiguration$name <- plotName
  # Save plot
  exportConfiguration$savePlot(plot, autoscaleText = TRUE)
}
