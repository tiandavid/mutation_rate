#R
args <- commandArgs(trailingOnly=TRUE)
infile <- args[1]
outfile <- args[2]

df <- read.delim(infile, header=FALSE,
                 col.names=c("CHROM","POS","REF","ALT","QUAL","AC","AN","GT","AD","GQ"))

# Parse AD field into REF and ALT counts
ad_split <- strsplit(as.character(df$AD), ",")
ref <- as.numeric(sapply(ad_split, `[`, 1))
alt <- as.numeric(sapply(ad_split, `[`, 2))
total <- ref + alt

# Identify heterozygotes (0/1, 1/0, 0|1, 1|0)
het <- grepl("^(0[|/]1|1[|/]0)$", df$GT) & total > 0

# Run 2-sided binomial test for ALT frequency = 0.5
pvals <- rep(NA, nrow(df))
pvals[het] <- mapply(function(x, n) {
  binom.test(x, n, p=0.5, alternative="two.sided")$p.value
}, alt[het], total[het])

# Keep sites with p >= 0.05 or not tested
df$pval <- pvals
df_filtered <- df[is.na(df$pval) | df$pval >= 0.05, ]

# Output CHROM and POS of passing SNPs
write.table(df_filtered[, c("CHROM", "POS")],
            file=outfile, sep="\t", quote=FALSE,
            row.names=FALSE, col.names=FALSE)
