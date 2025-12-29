## if nesscessary, install libglpk-dev, libgsl-dev, libfl-dev
## sudo apt install libcairo2-dev libfontconfig1-dev pandoc
##if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
#BiocManager::install(c("phyloseq", "microbiome", "ComplexHeatmap"), update = FALSE)

# install.packages(
#   "microViz",
#   repos = c(davidbarnett = "https://david-barnett.r-universe.dev", getOption("repos"))
# )

# requirements.R
required_pkgs <- c(
  "phyloseq",
  "tidyverse",
  "data.table",
  "readxl",
  "SpiecEasi",
  "DESeq2",
  "Wrench",
  "devtools"
)

to_install <- setdiff(required_pkgs, rownames(installed.packages()))
if (length(to_install)) BiocManager::install(to_install)
