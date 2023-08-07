#' Create plots excel file from a PK-Sim snapshot.
#'
#' @description
#' Extracts simulation plot definition from an PK-Sim project snapshot and converts
#' it to the esqlabsR plot excel file structure.
#'
#'
#' @param snapshot PK-Sim snapshot as read by `rjson::fromJSON`
#' @param outputPath Path of the excel file to be created.
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' snapshotFile <- file.path("..", "dextromethorphan_aggregated_simulations_v11.1.json")
#' pkSimSnapshot <- rjson::fromJSON(file = snapshotFile)
#' createPlotExcelFromSnapshot(snapshot = pkSimSnapshot,
#' outputPath = "../Plots.xlsx")
#' }
createPlotExcelFromSnapshot <- function(snapshot, outputPath) {
  snapshotSimulations <- snapshot$Simulations
  dataCombinedDf <- data.frame(list(
    "DataCombinedName" = character(),
    "dataType" = character(),
    "label" = character(),
    "scenario" = character(),
    "path" = character(),
    "dataSet" = character(),
    "group" = character(),
    "xOffsets" = numeric(),
    "xOffsetsUnits" = character(),
    "yOffsets" = numeric(),
    "yOffsetsUnits" = character(),
    "xScaleFactors" = numeric(),
    "yScaleFactors" = numeric()
  ))
  plotConfigurationDf <- data.frame(list(
    "plotID" = character(),
    "DataCombinedName" = character(),
    "plotType" = character(),
    "title" = character(),
    "xUnit" = character(),
    "yUnit" = character(),
    "xAxisScale" = character(),
    "yAxisScale" = character(),
    "xAxisLimits" = character(),
    "yAxisLimits" = character(),
    "quantiles" = character(),
    "foldDistance" = character()
  ))
  plotGridsDf <- data.frame(list(
    "name" = character(),
    "plotIDs" = character(),
    "title" = character()
  ))

  for (simulation in snapshotSimulations) {
    # For each simulation, create a plotGrid
    simulationName <- simulation$Name
    plotIDs <- c()

    # Create map of groupings.
    # For one observed data, only one mapping of simulation output can exist
    outputMappings <- list()
    for (outputMapping in simulation$OutputMappings){
      obsData <- outputMapping$ObservedData
      simPath <- .getPath(outputMapping$Path)

      # The group for both observed data and simulated result should be the name
      # of observed data
      outputMappings[[obsData]] <- obsData
      outputMappings[[simPath]] <- obsData
    }

    for (individualAnalysis in simulation$IndividualAnalyses) {
      # For each individual analysis, create a plot, consisting of a DataCombined
      # and a plotGrid
      plotID <- paste0(simulationName, " - ", individualAnalysis$Name)
      plotTitle <- individualAnalysis$Title
      # Replace NULL by NA
      plotTitle <- plotTitle %||% NA

      # Axis specs
      xUnit <- individualAnalysis$Axes[[1]]$Unit
      yUnit <- individualAnalysis$Axes[[2]]$Unit
      if (individualAnalysis$Axes[[1]]$Scaling == "Log"){
        xAxisScale <- "log"
      } else {
        xAxisScale <- "lin"
      }
      if (individualAnalysis$Axes[[2]]$Scaling == "Log"){
        yAxisScale <- "log"
      } else {
        yAxisScale <- "lin"
      }

      # Update grouping names, as for each individual analysis, the same data set
      # can have different names
      outputMappingsForAnalysis <- .updateGroupNames(individualAnalysis = individualAnalysis, outputMappings = outputMappings)
      for (curve in individualAnalysis$Curves) {
        # Skip the curve if it is not visible
        if (!is.null(curve$CurveOptions$Visible) && !curve$CurveOptions$Visible){
          next
        }

        dataCombinedRow <- .getDCRow(plotID, simulationName, curve, outputMappingsForAnalysis)
        dataCombinedDf <- rbind(dataCombinedDf, dataCombinedRow)
      }
      plotConfigurationRow <-
        list(    "plotID" = plotID,
                 "DataCombinedName" = plotID,
                 "plotType" = "individual",
                 "title" = plotTitle,
                 "xUnit" = xUnit,
                 "yUnit" = yUnit,
                 "xAxisScale" = xAxisScale,
                 "yAxisScale" = yAxisScale,
                 "xAxisLimits" = NA,
                 "yAxisLimits" = NA,
                 "quantiles" = NA,
                 "foldDistance" = NA)
      plotConfigurationDf <- rbind(plotConfigurationDf, plotConfigurationRow)

      # Enclosing plotID in parenthesis, so it gets properly parsed
      plotIDs <- c(plotIDs, paste0('"', plotID, '"'))
    }
    plotGridRow <- list(    "name" = simulationName,
                            "plotIDs" = paste0(plotIDs, collapse = ","),
                            "title" =  paste0(simulationName, " - time profile"))
    plotGridsDf <- rbind(plotGridsDf, plotGridRow)
  }

esqlabsR::writeExcel(data = list("DataCombined" = dataCombinedDf,
                                 "plotConfiguration" = plotConfigurationDf,
                                 "plotGrids" = plotGridsDf),
                     path = outputPath)
}

# Guess the type of the curve - simulated or observed
.getDataType <- function(curve){
  # Assumption - the X column from simulations are always called 'Time'. For
  # observed data, the name of the column includes the name of the data
  if (curve$X == "Time"){
    return("simulated")
  }
  return("observed")
}

# Create a DataCombined row for the curve
.getDCRow <- function(plotID, simulationName, curve, outputMappings){
  dataType <- .getDataType(curve)
  group <- NA

  if (dataType == "simulated"){
    # We assume that simulated scenario name is equal to the name of the simulation
    scenario <- simulationName
    # Replace '/' by '_' as this is what happens to pkml files during export.
    scenario <- gsub(pattern = "/", "_", scenario, fixed = TRUE)
    # Path is stored in the name of the Y-variable
    path <- curve$Y
    # However, it contains simulation name as the first path element, which must
    # be removed
    path <- .getPath(path)
    dataSet <- NA
    if (!is.null(outputMappings[[path]])){
      group <- outputMappings[[path]]
    }
  }
  # Observed data
  else {
    scenario <- NA
    path <- NA

    # name of data set is stored in the name of the X-variable
    dataSet <- curve$X
    # However, only the first part is the name of the data set
    dataSet <- .getObsDataName(dataSet)
    if (!is.null(outputMappings[[dataSet]])){
      group <- outputMappings[[dataSet]]
    }
  }
  dataCombinedRow <- list("DataCombinedName" = plotID,
                          "dataType" = dataType,
                          "label" = curve$Name,
                          "scenario" = scenario,
                          "path" = path,
                          "dataSet" = dataSet,
                          "group" = group,
                          "xOffsets" = NA,
                          "xOffsetsUnits" = NA,
                          "yOffsets" = NA,
                          "yOffsetsUnits" = NA,
                          "xScaleFactors" = NA,
                          "yScaleFactors" = NA
  )

  return(dataCombinedRow)
}

# Get the name of observed data from the full name
.getObsDataName <- function(fullName){
  strsplit(fullName, "|", fixed = TRUE)[[1]][[1]]
}

# Get model output path from the full name
.getPath <- function(fullName){
  fullName <- strsplit(fullName, "|", fixed = TRUE)[[1]]
  path <- paste0(fullName[2 : length(fullName)], collapse = "|")
  return(path)
}

# Update names of the group for a specific figure
.updateGroupNames <- function(individualAnalysis, outputMappings){
  for (curve in individualAnalysis$Curves) {
    # Skip the curve if it is not visible
    if (!is.null(curve$CurveOptions$Visible) && !curve$CurveOptions$Visible){
      next
    }
    # Update the name of the group
    if (.getDataType(curve) == "observed"){
      dataName <- .getObsDataName(curve$X)
      # Indeces that belong to this group
      idx <- which(outputMappings == dataName, useNames = FALSE)
      outputMappings[idx] <- curve$Name
    }
  }
  return(outputMappings)
}
