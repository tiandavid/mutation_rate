#!/bin/bash
#SBATCH --output=gather-joint-vcfs_%A.out
#SBATCH --error=gather-joint-vcfs_%A.err
#SBATCH --mail-type=END,FAIL
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mail-user=davidtian@berkeley.edu
#SBATCH --account=co_fishes
#SBATCH -p savio3

#Bring all of the VCFs together, can also do with bcftools concat
source activate picard

GVCF_FOLDER=/global/scratch/users/davidtian/mutation_project/genotypeGVCFs

picard GatherVcfs \
-I $GVCF_FOLDER/Chr21.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr22.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr19.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr24.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr2.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr23.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr17.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr8.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr12.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr20.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr10.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr11.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr4.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr18.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr1.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr9.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr3.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr16.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr7.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr14.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr13.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr6.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr15.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr5.joint.gt.vcf.gz \
-I $GVCF_FOLDER/DHP_short_scaffs.joint.gt.vcf.gz \
-O $GVCF_FOLDER/mut.rate.joint.gt.RAW.vcf.gz
