## readjust count tables
library(tidyverse)

Filenames = c("count_table_AS1250Cov50.csv",
              "count_table_AS1250Cov70.csv",
              "count_table_AS1250Cov80.csv",
              "count_table_AS1250.csv",
              "count_table_AS1500Cov50.csv",
              "count_table_AS1500Cov70.csv",
              "count_table_AS1500Cov80.csv",
              "count_table_AS1500.csv",
              "count_table_AS1750Cov50.csv",
              "count_table_AS1750Cov70.csv",
              "count_table_AS1750Cov80.csv",
              "count_table_AS1750.csv",
              "count_table_Cov50.csv",
              "count_table_Cov70.csv",
              "count_table_Cov80.csv",
              "count_table.csv")

cleanUp <- function(Dir2Files = "data/2025_11_07_16S_KPC_TT_UW_run01", Filename){
  df <- read_csv(file.path(Dir2Files, Filename))
  xxx <- df %>% 
    mutate(barcode09 = rowSums(select(., contains("barcode09"))),
           barcode10 = rowSums(select(., contains("barcode10"))),
           barcode11 = rowSums(select(., contains("barcode11"))),
           barcode12 = rowSums(select(., contains("barcode12"))),
           barcode13 = rowSums(select(., contains("barcode13"))),
           barcode14 = rowSums(select(., contains("barcode14"))),
           barcode15 = rowSums(select(., contains("barcode15"))),
           barcode16 = rowSums(select(., contains("barcode16"))),
           barcode17 = rowSums(select(., contains("barcode17"))),
           barcode18 = rowSums(select(., contains("barcode18")))) %>% 
    select(taxID, barcode09, barcode10, barcode11, barcode12, barcode13, 
           barcode14, barcode15, barcode16, barcode17, barcode18)
  write_csv(xxx, file.path(Dir2Files, sprintf("adj_%s", Filename)))
  #return(xxx)
}

for(f in Filenames){
  cleanUp(Filename = f)
}


