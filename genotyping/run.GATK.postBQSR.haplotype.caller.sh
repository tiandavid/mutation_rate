#!/bin/bash

INDS_ALL=(RT10 RT11 RT14 RT17)
GATK=/global/scratch/users/davidtian/download_software/gatk-4.6.1.0/gatk
REFERENCE=/global/scratch/users/davidtian/Paper3_big_one/reference_asm
BQSR_FOLDER=/global/scratch/users/davidtian/mutation_project/BQSR
DHP_RAW_VARIANTS_FOLDER=/global/scratch/users/davidtian/mutation_project/variants

for IND in ${INDS_ALL[@]}; do sbatch --job-name=GATK.postBQSR.haplotype.caller --output=R-%x.${IND}.%j.out --error=R-%x.${IND}.%j.err --account=co_fishes --partition savio4_htc --nodes=1 --ntasks=1 --cpus-per-task=4 --time 03-00:00 --mail-type=END,FAIL --mail-user=davidtian@berkeley.edu  --wrap "/global/scratch/users/davidtian/mutation_project/scripts/GATK.postBQSR.haplotype.caller.sh $IND $GATK $REFERENCE $BQSR_FOLDER $DHP_RAW_VARIANTS_FOLDER"; done
