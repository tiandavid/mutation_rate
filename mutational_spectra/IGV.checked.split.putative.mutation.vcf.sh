#!/bin/bash

#data
VCF="/global/scratch/users/davidtian/mutation_project/spectra/multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.minALT4.filtered.binofiltered.hets_only.IGV.checked.mutations.vcf"
SNP_COR="/global/scratch/users/davidtian/mutation_project/autozygous_segs/final_autozygous_intersecting_snps_coordinates_IGV_checked.tsv"
SAMPLE_LIST="IGV_checked_inds_with_mutations.txt"

#output
OUTDIR="/global/scratch/users/davidtian/mutation_project/spectra/IGV_checked_split_vcfs"
mkdir -p "$OUTDIR"

#Loop through each individual
while read -r IND; do
  echo "Processing $IND..."

  # Extract matching lines for the individual
  grep -w "$IND" "$SNP_COR" > "${IND}.IGV.checked.mutations.tsv"

  # Convert to BED format
  awk '{print $5, $6, $7}' OFS="\t" "${IND}.IGV.checked.mutations.tsv" > "${IND}.IGV.checked.mutations.bed"

  # Intersect with VCF
  bedtools intersect -a "$VCF" -b "${IND}.IGV.checked.mutations.bed" -header > "${OUTDIR}/${IND}.IGV.checked.putative.mutations.vcf"

done < "$SAMPLE_LIST"
