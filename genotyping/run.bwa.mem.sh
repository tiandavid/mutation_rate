#!/bin/bash

source activate bwa
INDS_ALL=(PR-Dtub6 PR-Dtub7 RT1 RT12 RT13 RT15 RT16 RT18 RT19 RT2 RT20 RT21 RT22 RT23 RT24 RT25 RT26 RT29 RT3 RT31 RT33 RT34 RT35 RT37 RT38 RT39 RT4 RT40 RT5 RT6 RT7 RT8 RT9)
REFERENCE=/global/scratch/users/davidtian/Paper3_big_one/reference_asm
FASTQ_FOLDER=/global/scratch/users/davidtian/mutation_project/trim_fastqs
DHP_BAM_FOLDER=/global/scratch/users/davidtian/mutation_project/bams

for IND in ${INDS_ALL[@]}; do sbatch --job-name=bwa_mem --output=R-%x.${IND}.%j.out --error=R-%x.${IND}.%j.err --account=fc_fishes --partition savio3 --nodes=1 --ntasks=1 --cpus-per-task=32 --time 03-00:00 --mem=90G --mail-type=END,FAIL --mail-user=davidtian@berkeley.edu  --wrap "/global/scratch/users/davidtian/mutation_project/scripts/bwa.mem.sh $IND $REFERENCE $FASTQ_FOLDER $DHP_BAM_FOLDER"; done
