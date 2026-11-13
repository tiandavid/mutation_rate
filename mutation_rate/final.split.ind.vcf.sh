#!/bin/bash

#input VCF file
VCF="/global/scratch/users/davidtian/mutation_project/filtered_variants/multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.minALT4.filtered.binofiltered.hets_only.vcf.gz"

#output
OUTPUT_DIR="final_individual_vcfs"
mkdir -p $OUTPUT_DIR

#get list of individuals in the VCF
INDIVIDUALS=$(bcftools query -l $VCF)

#loop through each ind.
for IND in $INDIVIDUALS; do
    echo "Processing $IND..."

    # Extract VCF for the individual
    bcftools view -s $IND -Oz -o $OUTPUT_DIR/${IND}.vcf.gz $VCF
    bcftools index $OUTPUT_DIR/${IND}.vcf.gz

    # Extract only heterozygous SNPs
    bcftools view -g het -Oz -o $OUTPUT_DIR/${IND}_het.vcf.gz $OUTPUT_DIR/${IND}.vcf.gz
    bcftools index $OUTPUT_DIR/${IND}_het.vcf.gz

    echo "Finished processing $IND: ${IND}.vcf.gz and ${IND}_het.vcf.gz created."
done
