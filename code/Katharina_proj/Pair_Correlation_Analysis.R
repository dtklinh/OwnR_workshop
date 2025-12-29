## correlation analysis
#library(devtools)
#install_github("zdk123/SpiecEasi")
library(SpiecEasi)
library(phyloseq)
library(dplyr)
library(taxizedb)
library(DESeq2)
library(Wrench)
library(pheatmap)
#library(SpiecEasi)

## ---- wrench normalization wrapper
WrenchWrapper <- function(PhyloObjct){
  cnt_table <- PhyloObjct %>% otu_table()
  group <- PhyloObjct %>% sample_data() %>% pull(sample_type)
  w <- wrench(cnt_table, condition = group)
  
  deseq.obj <- DESeqDataSetFromMatrix(cnt_table %>% as.data.frame() %>% round(), DataFrame(group), ~group)
  DESeq2::sizeFactors(deseq.obj) <- w$nf
  cnt_table_normalized <- DESeq2::counts(deseq.obj, normalized=TRUE)
  ##if(roundUp){cnt_table_normalized <- cnt_table_normalized %>% round()}
  return(phyloseq(otu_table(cnt_table_normalized, taxa_are_rows = T), tax_table(PhyloObjct %>% tax_table()), sample_data(PhyloObjct %>% sample_data())))
}

CRC <- readRDS("./data/Katharina_proj/raw_data/CRC_677_seqs_tree_v2.rds")

#tax_tab <- CRC %>% tax_table() %>% as.data.frame()

# Species_lst <- c("Bacteroides fragilis", "Fusobacterium necrophorum", "Gemella morbillorum",
#                  "Parvimonas micra", "Peptostreptococcus stomatis", "Prevotella intermedia",
#                  "Solobacterium moorei", "Streptococcus gallolyticus", "Bifidobacterium pseudocatenulatum", "Lacticaseibacillus casei")
Species_lst <- c("Fusobacterium nucleatum", "Gemella morbillorum", "Parvimonas micra", 
                 "Prevotella intermedia", "Peptostreptococcus stomatis", "Solobacterium moorei")
taxa_lst <- name2taxid(Species_lst)

##CRC_wrench <- CRC %>% WrenchWrapper()

## Calculate SPARCC
### Filter out OTUs that have less than 2 reads on average
CRC_RmLowTaxa <- prune_taxa(rowMeans(CRC %>% otu_table())>=2, CRC)
### Filter to only species list
CRC_RmLowTaxa <- prune_taxa(taxa_names(CRC_RmLowTaxa) %in% taxa_lst, CRC_RmLowTaxa )
### Remove sample with no taxa
CRC_RmLowTaxa <- prune_samples(sample_sums(CRC_RmLowTaxa)>250, CRC_RmLowTaxa)

### For each OTU, calculate rel abun in PT and STN
CRC_RmLowTaxa_RelAbun <- phyloseq::transform_sample_counts(CRC_RmLowTaxa, function(x) x/sum(x))

## calculate and plot SparCC
cc <- sparcc(CRC_RmLowTaxa %>% otu_table() %>% t(), iter = 100)
dat <- cc$Cor
rownames(dat) <- CRC_RmLowTaxa %>% tax_table() %>% as.data.frame() %>%  select(species) %>% unlist()
colnames(dat) <- rownames(dat)

png("SparCC.png")
pheatmap(dat, display_numbers = T)
dev.off()

ggplot2::ggsave("./results/Katharina_proj/SparCC_Dec2025.png", pheatmap(dat, display_numbers = T))

## test
tmp_tab <- CRC_wrench %>% otu_table() %>% as.data.frame()

