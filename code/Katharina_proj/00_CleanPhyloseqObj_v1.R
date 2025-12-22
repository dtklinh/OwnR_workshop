## clean phyloseq object
library(phyloseq)
library(tidyverse)
library(taxizedb)

CRC <- readRDS("../raw_data/CRC_677_seqs_tree.rds")
df_taxa <- tax_table(CRC) %>% as.matrix() %>% as.data.frame()

## filtering NA value
df_taxa_correct <- df_taxa %>% 
  mutate(phylum_co = ifelse(is.na(Phylum), paste0(Kingdom, "_", "unclassified"), Phylum)) %>% 
  mutate(class_co = ifelse(is.na(Class), paste0(Phylum, "_", "unclassified"), Class)) %>% 
  mutate(order_co = ifelse(is.na(Order), 
                           ifelse(grepl("unclassified", class_co, fixed = TRUE), class_co, paste0(class_co, "_", "unclassified")), Order)) %>% 
  mutate(family_co = ifelse(is.na(Family), 
                            ifelse(grepl("unclassified", order_co, fixed = TRUE), order_co, paste0(order_co, "_", "unclassified")), Family)) %>% 
  mutate(genus_co = ifelse(is.na(Genus), 
                           ifelse(grepl("unclassified", family_co, fixed = TRUE), family_co, paste0(family_co, "_", "unclassified")), Genus)) %>% 
  select(superkingdom = Kingdom, phylum = phylum_co, class = class_co, order = order_co, family = family_co, genus = genus_co, species = Species)

df_taxa_correct <- as.matrix(df_taxa_correct)
tax_table(CRC) <- tax_table(df_taxa_correct)
saveRDS(CRC, "../raw_data/CRC_677_seqs_tree_v2.rds")

df_sample <- sample_data(CRC) %>% as.matrix() %>% as.data.frame()
