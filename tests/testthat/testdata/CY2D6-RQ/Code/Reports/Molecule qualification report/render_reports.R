molecules <- c("Dextromethorphan", "Paroxetine")

for (m in molecules) {
  quarto::quarto_render("Molecule qualification report.qmd",
                        output_file = paste(m,"qualification report.pdf"),
                        execute_params = list(molecule = m,
                                      runMainScript = FALSE))
}

