snapshotFile <- file.path("..",
                          "Models",
                          "Snapshots",
                          "v11.2",
                          "paroxetine-model_v11.2.json")
pkSimSnapshot <- rjson::fromJSON(file = snapshotFile,
                                 simplify = FALSE)


##### Consolidate expression profiles
updatedSnapshot <- removeIdenticalExpProfilesFromSnapshot(pkSimSnapshot)
write(rjson::toJSON(updatedSnapshot, indent = 1), file = file.path("..",
                                                       "Models",
                                                       "Snapshots",
                                                       "v11.2",
                                                       "paroxetine-model_v11.2_updated.json"))
jsonlite::write_json(rjson::toJSON(updatedSnapshot), path = file.path("..",
                                                                      "Models",
                                                                      "Snapshots",
                                                                      "v11.2",
                                                                      "paroxetine-model_v11.2_updated.json"))

##### Create Scenarios from snapshot
snapshotFile <- file.path("..",
                          "Models",
                          "Snapshots",
                          "v11.2",
                          "paroxetine-model_v11.2_updated.json")
pkSimSnapshot <- rjson::fromJSON(file = snapshotFile,
                                 simplify = FALSE)
createScenariosFromSnapshots(snapshot = pkSimSnapshot,
                             outputPath = "../Scenarios.xlsx")

# Create plots
createPlotExcelFromSnapshot(snapshot = pkSimSnapshot,
                            outputPath = "../plots_paraxentine.xlsx")
