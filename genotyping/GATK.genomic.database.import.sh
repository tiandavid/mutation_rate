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
#SBATCH --account=fc_fishes
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
-V $DHP_RAW_VARIANTS_FOLDER/RT10.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT11.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT14.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT17.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH1.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH10.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH11.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH12.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH13.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH14.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH15.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH16.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH17.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH18.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH2.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH3.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH4.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH6.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH7.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH8.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/DH9.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub1.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub10.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub11.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub12.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub2.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub3.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub4.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub5.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub6.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/PR-Dtub7.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT1.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT12.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT13.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT15.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT16.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT18.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT19.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT2.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT20.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT21.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT22.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT23.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT24.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT25.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT26.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT29.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT3.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT31.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT33.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT34.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT35.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT37.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT38.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT39.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT4.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT40.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT5.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT6.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT7.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT8.g.vcf.gz \
-V $DHP_RAW_VARIANTS_FOLDER/RT9.g.vcf.gz \
--genomicsdb-workspace-path /global/scratch/users/davidtian/mutation_project/genomic_database/DHP_database_bigmem_${scaff} \
--tmp-dir /global/scratch/users/davidtian/mutation_project/genomic_database/tmp
