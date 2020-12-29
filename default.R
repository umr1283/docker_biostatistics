### Project Setup ==================================================================================
library(here)
project_name <- gsub("(.*)_.*", "\\1", basename(here()))
output_directory <- here("outputs", "99-new_script")
dir.create(output_directory, recursive = TRUE, showWarnings = FALSE, mode = "0775")


### Load Packages ==================================================================================
suppressPackageStartupMessages({
  # library(ggplot2)
})


### Tables and Figures Theme =======================================================================
# theme_set(theme_light())


### Functions ======================================================================================


### Analysis =======================================================================================


### Complete =======================================================================================
message("Success!", appendLF = TRUE)
