#!/bin/bash

#split VCF 
samples=$(bcftools query -l multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.vcf.gz)
for s in $samples; do
    echo "Extracting $s..."
    bcftools view -s $s -Oz -o ${s}.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.vcf.gz multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.vcf.gz
    tabix -p vcf ${s}.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.vcf.gz
done

#min alt depth 4 filter
for file in *.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.vcf.gz
do
  echo "Filtering $file for ALT depth >3..."
  bcftools view -i 'MAX(FORMAT/AD[:1]) > 3' "$file" -Oz -o "${file%.vcf.gz}.minALT4.filtered.vcf.gz"
  tabix -p vcf "${file%.vcf.gz}.minALT4.filtered.vcf.gz"
done

#binomial

#collect ind. sample AD
for vcf in *.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.minALT4.filtered.vcf.gz
do
  sample=$(basename "$vcf" .vcf.gz)
  echo "Processing $sample..."

  bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%INFO/AC\t%INFO/AN[\t%GT\t%AD\t%GQ]\n' "$vcf" > "$sample.AD_data.v2.tsv"
done

#run R scirpt to filter
for tsv in *.AD_data.v2.tsv
do
  sample_prefix="${tsv%.AD_data.v2.tsv}"  # strips the suffix
  vcf="${sample_prefix}.vcf.gz"        # reconstruct matching VCF filename

  echo "Running binomial filter for $sample_prefix..."

  #Rscript to create list of good sites
  Rscript filter_binomial.R "$tsv" "${sample_prefix}.keep_sites.v2.txt"

  #Only run filtering if keep_sites.txt exists and is non-empty
  if [[ ! -s "${sample_prefix}.keep_sites.v2.txt" ]]; then
    echo "No passing sites or error for $sample_prefix — skipping VCF filtering"
    continue
  fi

  #Filter the original VCF using site list
  bcftools view -T "${sample_prefix}.keep_sites.v2.txt" "$vcf" -Oz -o "${sample_prefix}.binofiltered.vcf.gz"
  tabix -p vcf "${sample_prefix}.binofiltered.vcf.gz"
done

#filter ind vcfs to be hets only
for vcf in *minALT4.filtered.binofiltered.vcf.gz; do
  sample=$(basename "$vcf" .vcf.gz)
  echo "Filtering heterozygous sites for $sample..."

  bcftools view -i 'GT="het"' "$vcf" -Oz -o "${sample}.hets_only.vcf.gz"
  tabix -p vcf "${sample}.hets_only.vcf.gz"
done

#merge ind. vcfs together
bcftools merge *.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.minALT4.filtered.binofiltered.hets_only.vcf.gz -Oz -o multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.minALT4.filtered.binofiltered.hets_only.vcf.gz
tabix -p vcf multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.minALT4.filtered.binofiltered.hets_only.vcf.gz