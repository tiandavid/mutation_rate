#!/bin/bash
#SBATCH --output=filt-vcf_%A.out
#SBATCH --error=filt-vcf_%A.err
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
REF=/global/scratch/users/davidtian/Paper3_big_one/reference_asm/DHP.FINAL.chrom.fasta
RAW=/global/scratch/users/davidtian/mutation_project/genotypeGVCFs
FILT=/global/scratch/users/davidtian/mutation_project/filtered_variants

# Now we will select variants, and conduct hard filtering with GATK.

echo "Pulling out SNPs"
$gatk SelectVariants \
-V $RAW/mut.rate.joint.gt.RAW.vcf.gz \
-select-type SNP \
--restrict-alleles-to BIALLELIC \
-O $FILT/mut.rate.biallelic.RAW.SNPS.vcf.gz >& $FILT/mut.rate.biallelic.RAW.SNPS.vcf.out

echo "Pulling out INDELs"
$gatk SelectVariants \
-V $RAW/mut.rate.joint.gt.RAW.vcf.gz \
-select-type INDEL \
-O $FILT/mut.rate.RAW.INDELs.vcf.gz >& $FILT/mut.rate.RAW.INDELs.out

echo "Hard filtering SNPs"
# Hard filter the SNPs
$gatk VariantFiltration \
-R $REF \
-V $FILT/mut.rate.biallelic.RAW.SNPS.vcf.gz \
-O $FILT/mut.rate.biallelic.HARD.FILTERED.SNPS.vcf.gz \
-filter "QD < 2.0" --filter-name "QD2" \
-filter "QUAL < 30.0" --filter-name "QUAL30" \
-filter "SOR > 3.0" --filter-name "SOR3" \
-filter "FS > 60.0" --filter-name "FS60" \
-filter "MQ < 40.0" --filter-name "MQ40" \
-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
-filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" >& mut.rate.biallelic.HARD.FILTERED.SNPS.out

echo "Hard filtering INDELs"
# Hard filter the indels
$gatk VariantFiltration \
-R $REF \
-V $FILT/mut.rate.RAW.INDELs.vcf.gz \
-O $FILT/mut.rate.HARD.FILTERED.INDELs.vcf.gz \
-filter "QD < 2.0" --filter-name "QD2" \
-filter "QUAL < 30.0" --filter-name "QUAL30" \
-filter "FS > 200.0" --filter-name "FS200" \
-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" >& mut.rate.HARD.FILTERED.INDELs.out
