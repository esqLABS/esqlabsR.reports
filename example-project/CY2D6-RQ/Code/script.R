# # Load v9.1 simulations
# projectConfiguration$modelFolder <- file.path(projectConfiguration$modelFolder, "v9.1")
#
# # List all model names
# allSimFiles <- list.files(projectConfiguration$modelFolder, pattern = "*.pkml")
# write.csv(allSimFiles, file = "../SimNames.csv", fileEncoding = "UTF-8")
#
# # Load v11.2 simulations
# projectConfiguration$modelFolder <- file.path(projectConfiguration$modelFolder, "v11.2")
#
# # List all model names
# allSimFiles <- list.files(projectConfiguration$modelFolder, pattern = "*.pkml")
# write.csv(allSimFiles, file = "../SimNames.csv", fileEncoding = "UTF-8")


snapshotFile <- file.path(
  projectConfiguration$modelFolder, "..", "Snapshots",
  "v11.2", "dextromethorphan_aggregated_simulations_v11.1.json"
)
pkSimSnapshot <- rjson::fromJSON(file = snapshotFile)

createPlotExcelFromSnapshot(snapshot = pkSimSnapshot,
                            outputPath = "../CustomPlots.xlsx")
