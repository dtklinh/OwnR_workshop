## Allegra project
## Combine multiple table into one count table
library(tidyverse)
library(readxl)
#library(dplyr)

lst_names <- c("KV17826", "KV17827", "KV17828",
               "KV17829", "KV17830", "KV22923", "KV22924",
               "KV22925", "KV22926", "KV22927", "KV22928")

df_main <- read_xlsx("data/KV17825.xlsx") %>% 
  select(gene_id, KV17825 = FPKM) %>% 
  group_by(gene_id) %>% 
  slice_max(KV17825, n = 1, with_ties = FALSE) %>% 
  ungroup()
# df_2 <- read_xlsx("data/KV22927.xlsx") %>% 
#   select(gene_id, KV22927 = FPKM) %>% 
#   group_by(gene_id) %>% 
#   slice_max(KV22927, n = 1, with_ties = FALSE) %>% 
#   ungroup()
# df_main %>% 
#   left_join(., df_2, by = "gene_id")

for(id in lst_names){
  df_tmp <- read_xlsx(sprintf("data/%s.xlsx", id)) %>% 
    select(gene_id, FPKM) %>% 
    group_by(gene_id) %>% 
    slice_max(FPKM, n = 1, with_ties = FALSE) %>% 
    ungroup() %>% 
    rename(!!id := FPKM)
  df_main <- df_main %>% 
    left_join(., df_tmp, by = "gene_id")
}
write_csv(df_main, "data/ROR2_fpkm_matrix.csv")
