#!/bin/bash
#SBATCH --job-name=bcftools_roh_mut_rate
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --time=3-00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mail-user=davidtian@berkeley.edu
#SBATCH -p savio3
#SBATCH --account=co_fishes

source activate bcftools #v1.16

VCF=/global/scratch/users/davidtian/mutation_project/filtered_variants/mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.vcf.gz

#sort VCF 
bcftools sort $VCF \
-o mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.vcf

#bgzip sorted vcf
bgzip -@ 32 -c \
mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.vcf \
> mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.vcf.gz

#index bgzipped vcf
tabix -p vcf --csi \
mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.vcf.gz

# --------------------------------
# Generate allele frequency files for use with bcftools roh & index
bcftools query -f'%CHROM\t%POS\t%REF,%ALT\t%INFO/AF\n' \
mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.vcf.gz \
| bgzip -c > mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.AF.tab.gz
tabix -s1 -b2 -e2 --csi mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.AF.tab.gz

# --------------------------------
# Call ROHs with GT and PL
bcftools roh \
--GTs-only 30 \
--threads 32 \
-o mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted_GTonly.txt \
--AF-file mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.AF.tab.gz \
mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.vcf.gz

bcftools roh \
--threads 32 \
-o mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted_PLonly.txt \
--AF-file mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.AF.tab.gz \
mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted.vcf.gz

# --------------------------------
# Extract information on ROHs (i.e., exclude information on individual sites)
grep "^RG" mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted_GTonly.txt > \
mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted_GTonly_RG_ONLY.txt

grep "^RG" mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted_PLonly.txt > \
mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted_PLonly_RG_ONLY.txt
