#!/bin/bash

# This script applies the fitted BQSR model to each sample, in parallel.

module load java/22.0.1

gatk=/global/scratch/users/davidtian/download_software/gatk-4.6.1.0/gatk
REFERENCE=/global/scratch/users/davidtian/Paper3_big_one/reference_asm
MARKDUP_BAMS=/global/scratch/users/davidtian/mutation_project/bams
BQSR=/global/scratch/users/davidtian/mutation_project/BQSR

echo "Applying BQSR to $1"
$gatk --java-options "-Xmx6G" ApplyBQSR \
    -R $REFERENCE/DHP.FINAL.chrom.fasta \
    -I $MARKDUP_BAMS/$1.markdup.bam \
    --bqsr-recal-file $BQSR/$1_base-recal.table \
    -O $BQSR/$1_BQSR.bam >& $1-apply-BQSR.out
echo "Done"
