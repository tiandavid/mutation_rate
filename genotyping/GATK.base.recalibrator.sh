#!/bin/bash

# This script is used by gnu parallel to build a BQSR model for each sample, to later be applied using the ApplyBQSR function in GATK.

module load java/22.0.1

gatk=/global/scratch/users/davidtian/download_software/gatk-4.6.1.0/gatk
REFERENCE=/global/scratch/users/davidtian/Paper3_big_one/reference_asm
MARKDUP_BAMS=/global/scratch/users/davidtian/mutation_project/bams
SITES=/global/scratch/users/davidtian/mutation_project/filtered_variants
BQSR_BAMS=/global/scratch/users/davidtian/mutation_project/BQSR

echo "Generating recalibration model for $1"
$gatk --java-options "-Xmx6G" BaseRecalibrator \
        -R $REFERENCE/DHP.FINAL.chrom.fasta \
        -I $MARKDUP_BAMS/$1.markdup.bam \
	--known-sites $SITES/mut.rate.biallelic.HARD.FILTER.EXCLUDED.SNPS.vcf.gz \
	--known-sites $SITES/mut.rate.HARD.FILTER.EXCLUDED.INDELs.vcf.gz \
        -O $BQSR_BAMS/$1_base-recal.table >& $1-base-recal-table.out
echo "Done"
