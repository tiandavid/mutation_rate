#!/bin/bash
#SBATCH --output=split_multisample_vcf_for_ROH_%A.out
#SBATCH --error=split_multisample_vcf_for_ROH_%A.err
#SBATCH --mail-type=END,FAIL
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mail-user=davidtian@berkeley.edu
#SBATCH -p savio3
#SBATCH --account=co_fishes

source activate bcftools
samples=$(bcftools query -l mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.vcf.gz)
for s in $samples; do
    echo "Extracting $s..."
    bcftools view -s $s -Oz -o ${s}.mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.vcf.gz mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.vcf.gz 
    bcftools index ${s}.mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.vcf.gz 
done
