#!/bin/bash
#SBATCH --output=postBQSR_genotypeGVCFs_%A_%a.out
#SBATCH --error=postBQSR_genotypeGVCFs_%A_%a.err
#SBATCH --time=72:00:00
#SBATCH --array=1-24
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=davidtian@berkeley.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --account=fc_fishes
#SBATCH -p savio4_htc

module load java/22.0.1
gDBImport_FOLDER=/global/scratch/users/davidtian/mutation_project/postBQSR_genomic_database
GVCF_FOLDER=/global/scratch/users/davidtian/mutation_project/postBQSR_genotypeGVCFs

id=$SLURM_ARRAY_TASK_ID

/global/scratch/users/davidtian/download_software/gatk-4.6.1.0/gatk \
--java-options "-Xmx4g -Xms4g" \
GenotypeGVCFs \
-R /global/scratch/users/davidtian/Paper3_big_one/reference_asm/DHP.FINAL.chrom.fasta \
-V gendb://$gDBImport_FOLDER/DHP_postBQSR_database_Chr${id} \
-O $GVCF_FOLDER/Chr${id}.postBQSR.joint.gt.vcf.gz
