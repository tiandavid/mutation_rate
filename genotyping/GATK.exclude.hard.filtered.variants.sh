#!/bin/bash
#SBATCH --output=exclude_hard_filtered_%A.out
#SBATCH --error=exclude_hard_filtered_%A.err
#SBATCH --mail-type=END,FAIL
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mail-user=davidtian@berkeley.edu
#SBATCH -p savio3
#SBATCH --account=co_fishes

module load java/22.0.1
gatk=/global/scratch/users/davidtian/download_software/gatk-4.6.1.0/gatk
FILT=/global/scratch/users/davidtian/mutation_project/filtered_variants

# Excluding hard filtered variants (leaving only passing ones)

echo "Excluding hard filtered SNPs"
$gatk SelectVariants \
--exclude-filtered \
-V $FILT/mut.rate.biallelic.HARD.FILTERED.SNPS.vcf.gz \
-O $FILT/mut.rate.biallelic.HARD.FILTER.EXCLUDED.SNPS.vcf.gz >& mut.rate.biallelic.HARD.FILTER.EXCLUDED.SNPS.out

echo "Excluding hard filtered INDELs"
$gatk SelectVariants \
--exclude-filtered \
-V $FILT/mut.rate.HARD.FILTERED.INDELs.vcf.gz \
-O $FILT/mut.rate.HARD.FILTER.EXCLUDED.INDELs.vcf.gz >& mut.rate.HARD.FILTER.EXCLUDED.INDELs.out
