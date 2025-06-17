#!/bin/bash
#SBATCH --output=genomic_database_import_%A_%a.out
#SBATCH --error=genomic_database_import_%A_%a.err
#SBATCH --time=3-00:00
#SBATCH --array=25
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=360G
#SBATCH --mail-user=davidtian@berkeley.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --account=co_fishes
#SBATCH -p savio3_bigmem

module load java/22.0.1
DHP_RAW_VARIANTS_FOLDER=/global/scratch/users/davidtian/mutation_project/variants

id=$SLURM_ARRAY_TASK_ID
scaff=$(sed "${id}q;d" DHP.chrom.chrs.list)

if [ $id == 25 ]
then
	scaff=DHP.chrom.scaffs.list
else
	scaff=$(echo $scaff)
fi

/global/scratch/users/davidtian/download_software/gatk-4.6.1.0/gatk \
--java-options "-Xmx4g -Xms4g" \
GenomicsDBImport \
-L ${scaff} \
-V $DHP_RAW_VARIANTS_FOLDER/RT10.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT11.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT14.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT17.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH1.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH10.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH11.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH12.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH13.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH14.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH15.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH16.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH17.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH18.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH2.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH3.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH4.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH6.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH7.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH8.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH9.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub1.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub10.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub11.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub12.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub2.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub3.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub4.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub5.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub6.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub7.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT1.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT12.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT13.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT15.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT16.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT18.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT19.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT2.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT20.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT21.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT22.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT23.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT24.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT25.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT26.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT29.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT3.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT31.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT33.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT34.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT35.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT37.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT38.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT39.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT4.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT40.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT5.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT6.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT7.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT8.postBQSR.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT9.postBQSR.g.vcf.gz \
--genomicsdb-workspace-path /global/scratch/users/davidtian/mutation_project/postBQSR_genomic_database/DHP_postBQSR_database_${scaff} \
--tmp-dir /global/scratch/users/davidtian/mutation_project/postBQSR_genomic_database/tmp
