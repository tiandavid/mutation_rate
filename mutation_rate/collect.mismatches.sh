#!/bin/bash

#paths
SEGMENTS="/global/scratch/users/davidtian/mutation_project/autozygous_segs/final.1Mb.cutoff.bed"
SNP_DIR="/global/scratch/users/davidtian/mutation_project/autozygous_segs/final_individual_beds"
OUTPUT_DIR="/global/scratch/users/davidtian/mutation_project/gene_conversion/gene_conversion_output"
mkdir -p "$OUTPUT_DIR"

#loop over snp bed files
for SNP_FILE in "$SNP_DIR"/*_het.bed; do
    INDIVIDUAL=$(basename "$SNP_FILE" _het.bed)

    # Extract segments for the individual
    awk -v ind="$INDIVIDUAL" '$4 == ind' "$SEGMENTS" > tmp_segment.bed

    # Intersect with individual's SNPs, reporting both SNP and segment info
    bedtools intersect -a "$SNP_FILE" -b tmp_segment.bed -wa -wb > "$OUTPUT_DIR/${INDIVIDUAL}_intersect.bed"
done
rm tmp_segment.bed
