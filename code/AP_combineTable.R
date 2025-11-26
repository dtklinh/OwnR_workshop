## Allegra project
## Combine multiple table into one count table
library(tidyverse)
library(readxl)
library(dplyr)

lst_names <- c("KV17826", "KV17827", "KV17828",
               "KV17829", "KV17830", "KV22923", "KV22924",
               "KV22925", "KV22926", "KV22927", "KV22928")

df_main <- read_xlsx("data/KV17825.xlsx") %>% 
  select(gene_id, FPKM)

for(id in lst_names){
  
}

