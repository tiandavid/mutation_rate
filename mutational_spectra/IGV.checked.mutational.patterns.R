library(MutationalPatterns)
library(BSgenome)
library(patchwork)
library(gridExtra)
library(ggpubr)

#properly load DHP genome
library(BSgenomeForge)

forgeBSgenomeDataPkgFromNCBI(assembly_accession="GCA_030533445.1",
                             pkg_maintainer="David Tian",
                             organism="Cyprinodon diabolis",
                             circ_seqs=character(0))
#Creating package in ./BSgenome.Cdiabolis.NCBI.UCBCyDiab1.0 
devtools::build("./BSgenome.Cdiabolis.NCBI.UCBCyDiab1.0")
devtools::check_built("BSgenome.Cdiabolis.NCBI.UCBCyDiab1.0_1.0.0.tar.gz")
devtools::install_local("BSgenome.Cdiabolis.NCBI.UCBCyDiab1.0_1.0.0.tar.gz")
DHP_genome <- "BSgenome.Cdiabolis.NCBI.UCBCyDiab1.0"

#load individual VCFs
vcf_dir <- "IGV_checked_split_vcfs"
vcf_files <- list.files(path = vcf_dir, pattern = "\\.IGV\\.checked\\.putative\\.mutations\\.vcf$", full.names = TRUE)
lethal_vcf_dir <- "lethal_IGV_checked_split_vcfs"
lethal_vcf_files <- list.files(path = lethal_vcf_dir, pattern = "\\.IGV\\.checked\\.putative\\.mutations\\.vcf$", full.names = TRUE)
adult_vcf_dir <- "adult_IGV_checked_split_vcfs"
adult_vcf_files <- list.files(path = adult_vcf_dir, pattern = "\\.IGV\\.checked\\.putative\\.mutations\\.vcf$", full.names = TRUE)

#get sample names
sample_names <- sub("\\.IGV\\.checked\\.putative\\.mutations\\.vcf$", "", basename(vcf_files))
lethal_names <- sub("\\.IGV\\.checked\\.putative\\.mutations\\.vcf$", "", basename(lethal_vcf_files))
adult_names <- sub("\\.IGV\\.checked\\.putative\\.mutations\\.vcf$", "", basename(adult_vcf_files))

#load GRangesList
grl <- read_vcfs_as_granges(vcf_files, sample_names, 
                            DHP_genome, group = 'none',
                            predefined_dbs_mbs=TRUE)

lethal_grl <- read_vcfs_as_granges(lethal_vcf_files, lethal_names, 
                            DHP_genome, group = 'none',
                            predefined_dbs_mbs=TRUE)

adult_grl <- read_vcfs_as_granges(adult_vcf_files, adult_names, 
                                   DHP_genome, group = 'none',
                                   predefined_dbs_mbs=TRUE)


#Create status groups
status_groups <- sapply(sample_names, function(x) {
  if (startsWith(x, "PR-Dtub") ||
      (startsWith(x, "RT") && as.numeric(gsub("RT", "", x)) > 25) ||
      (startsWith(x, "DH") && as.numeric(gsub("DH", "", x)) > 16)) {
    "embryonic lethal"
  } else if (startsWith(x, "DH") || startsWith(x, "RT")) {
    "mature adult"
  } else {
    NA
  }
})

#Create sample groups
sample_groups <- sapply(sample_names, function(x) {
  if (startsWith(x, "DH")) {
    "C. diabolis"
  } else if (startsWith(x, "PR-Dtub") || (startsWith(x, "RT") && as.numeric(gsub("RT", "", x)) > 25)) {
    "C. diabolis"
  } else if (startsWith(x, "RT")) {
    "C. diabolis"
  } else {
    NA
  }
})

#inspect data (sanity check things are working)
muts <- mutations_from_vcf(grl[[1]])
head(muts, 12)
types <- mut_type(grl[[1]])
head(types, 12)
context <- mut_context(grl[[1]], DHP_genome)
head(context, 12)
type_context <- type_context(grl[[1]], DHP_genome)
lapply(type_context, head, 12)
type_occurrences <- mut_type_occurrences(grl, DHP_genome)
type_occurrences

#lethal
lethal_type_occurrences <- mut_type_occurrences(lethal_grl, DHP_genome)
lethal_type_occurrences

#adult
adult_type_occurrences <- mut_type_occurrences(adult_grl, DHP_genome)
adult_type_occurrences

#Mutation Spectrum
#Error bars indicate the 95% confidence interval
#11/6/26
#Fig. 4B
plotA <- plot_spectrum(type_occurrences, CT = TRUE)
plotA

#Supp. Fig. 1
lethal_plotA <- plot_spectrum(lethal_type_occurrences, CT = TRUE)
lethal_plotA

adult_plotA <- plot_spectrum(adult_type_occurrences, CT = TRUE, legend=FALSE)
adult_plotA

plotA_lethal_adult <- adult_plotA + lethal_plotA
plotA_lethal_adult + plot_annotation(tag_levels = 'A')

# normalize each row (per sample)
type_props_per_sample <- type_occurrences[, base_types] / rowSums(type_occurrences[, base_types])
# mean proportion across samples
mean_type_props <- colMeans(type_props_per_sample, na.rm = TRUE)
print(round(mean_type_props, 3))
#  C>A   C>G   C>T   T>A   T>C   T>G 
#0.138 0.060 0.367 0.108 0.178 0.149 


# C>T at CpG vs. not
ct_subtypes <- type_occurrences[, c("C>T at CpG", "C>T other")] / rowSums(type_occurrences[, base_types])
mean_ct_type_props <- colMeans(ct_subtypes, na.rm = TRUE)
print(round(mean_ct_type_props, 3))
#C>T at CpG  C>T other 
#0.157      0.209 
#percentage C>T at CpG = 0.157/(0.157+0.209) = 0.4289

# Compute row sums (total C>T mutations per sample)
ct_totals <- rowSums(ct_subtypes)

# Calculate proportions per sample
ct_proportions_per_sample <- ct_subtypes / ct_totals

# View results
round(ct_proportions_per_sample, 3)

#96 mutational profile
mut_mat <- mut_matrix(vcf_list = grl, ref_genome = DHP_genome)
head(mut_mat)
plot_96_profile(mut_mat)

#pool across all pops and individuals
pooled_mut_mat <- pool_mut_mat(mut_mat, grouping = sample_groups)
head(pooled_mut_mat)

#96 spectra 11/6/26
#Fig 4C
plotB <- plot_96_profile(pooled_mut_mat, condensed = TRUE, ymax=0.1)
plotB

#pool across adult vs. lethal 
pooled_mut_mat_adult_vs_lethal <- pool_mut_mat(mut_mat, grouping=status_groups)


#11/6/26
#looking at difference between adult and lethal
#Fig Supp. Fig. 2
plotC_with_diff <- plot_compare_profiles(pooled_mut_mat_adult_vs_lethal[, 1],
                                         pooled_mut_mat_adult_vs_lethal[, 2],
                                         profile_names = c("embryonic lethal", "mature adult"),
                                         condensed = TRUE, 
                                         profile_ymax = 0.1
)
plotC_with_diff

#11/6/26
#bootstrap signature refitting (across all ind)
#Supp. Fig. 3

contri_boots <- fit_to_signatures_bootstrapped(pooled_mut_mat,
                                               signatures_artifacts,
                                               n_boots = 1000,
                                               max_delta = 0.1,
                                               method = "strict"
)
contri_boots_no_artifacts <- fit_to_signatures_bootstrapped(pooled_mut_mat,
                                                            signatures,
                                                            n_boots = 1000,
                                                            max_delta = 0.1,
                                                            method = "strict"
)
#Supp. Fig. 3
plotD2 <- plot_bootstrapped_contribution(contri_boots, mode = "relative", plot_type = "barplot")
plotD2

#Fig. 4d
plotD2_no_art <- plot_bootstrapped_contribution(contri_boots_no_artifacts, mode = "relative", plot_type = "barplot")
plotD2_no_art

#11/6/26
#putting together updated conglomerate plot for Fig.4
layout <- "
AAABBB
CCCCCC
DDDDDD
EEEEEE
"
plotA_bottom <- plotA+theme(legend.position = "bottom")
plotA_nolegend <- plotA+theme(legend.position = "none")

legend_object <- get_legend(plotA_bottom) 

finalberg <- bergeron8plot+theme_bw()+theme(legend.position = "none", axis.title.x = element_blank(), axis.text.x  = element_blank(),axis.ticks.x = element_blank())
finalplotA <- plotA+theme_bw()+theme(legend.position = "none", strip.text = element_blank(), strip.background = element_blank(), axis.ticks.x  = element_blank(), axis.text.x  = element_blank())
plotB <- plotB + theme(strip.text.y = element_blank(),strip.background.y = element_blank())
plotD2_no_art <- plotD2_no_art + labs(y = "Relative contribution") + theme(strip.text.y = element_blank(),strip.background.y = element_blank())
blank <- legend_object
plots <- finalberg + finalplotA + blank + plotB + plotD2_no_art +
  plot_layout(design = layout, heights = c(1.4, 0.4, 1, 1))+
  plot_annotation(tag_levels = 'A') &
  theme(text = element_text(size = 12))
plots

#calculate stats
N_lethal <- sum(pooled_mut_mat_adult_vs_lethal[,1])
N_adult <- sum(pooled_mut_mat_adult_vs_lethal[,2])
pooled_mut_mat_adult_vs_lethal_DF <- as.data.frame(pooled_mut_mat_adult_vs_lethal)

pvals <- numeric(nrow(pooled_mut_mat_adult_vs_lethal_DF))
test_type <- character(nrow(pooled_mut_mat_adult_vs_lethal_DF))

for (i in seq_len(nrow(pooled_mut_mat_adult_vs_lethal_DF))) {
  a <- pooled_mut_mat_adult_vs_lethal_DF$`embryonic lethal`[i]
  b <- pooled_mut_mat_adult_vs_lethal_DF$`mature adult`[i]
  table_2x2 <- matrix(c(a, N_lethal - a, b, N_adult - b), nrow = 2, byrow = TRUE)
  
  # Expected counts to decide which test
  expected <- chisq.test(table_2x2)$expected
  if (any(expected < 5)) {
    test_type[i] <- "Fisher"
    pvals[i] <- fisher.test(table_2x2)$p.value
  } else {
    test_type[i] <- "Chi-square"
    pvals[i] <- chisq.test(table_2x2, correct = FALSE)$p.value
  }
}

#multiple test correction
pvals_adj <- p.adjust(pvals, method = "BH")
#nothing significant following correction.