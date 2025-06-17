#!/bin/bash
#SBATCH --output=postBQSR-gather-joint-vcfs_%A.out
#SBATCH --error=postBQSR-gather-joint-vcfs_%A.err
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

GVCF_FOLDER=/global/scratch/users/davidtian/mutation_project/postBQSR_genotypeGVCFs

picard GatherVcfs \
-I $GVCF_FOLDER/Chr21.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr22.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr19.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr24.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr2.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr23.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr17.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr8.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr12.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr20.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr10.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr11.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr4.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr18.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr1.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr9.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr3.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr16.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr7.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr14.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr13.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr6.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr15.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/Chr5.postBQSR.joint.gt.vcf.gz \
-I $GVCF_FOLDER/DHP.postBQSR.short_scaffs.joint.gt.vcf.gz \
-O $GVCF_FOLDER/mut.rate.postBQSR.joint.gt.RAW.vcf.gz
