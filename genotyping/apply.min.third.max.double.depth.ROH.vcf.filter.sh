#!/bin/bash
#SBATCH --output=min_third_max_double_ROH.vcf.%A.out
#SBATCH --error=min_third_max_double_ROH.vcf%A.err
#SBATCH --mail-type=END,FAIL
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mail-user=davidtian@berkeley.edu
#SBATCH -p savio3
#SBATCH --account=co_fishes

source activate bcftools

while read sample min max; do
  echo "Filtering $sample: DP < $min or > $max"
  bcftools filter \
    -S . \
    -e "FMT/DP < $min || FMT/DP > $max" \
    -Oz -o ${sample}.mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.vcf.gz \
    ${sample}.mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.vcf.gz
done < coverages.min.third.max.double.tsv
