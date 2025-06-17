#!/bin/bash

INDS_ALL=(PR-Dtub3 PR-Dtub5)
DHP_BAM_FOLDER=/global/scratch/users/davidtian/mutation_project/bams

for IND in ${INDS_ALL[@]}; do sbatch --job-name=mdup_spark --output=R-%x.${IND}.%j.out --error=R-%x.${IND}.%j.err --account=fc_fishes --partition savio4_htc --nodes=1 --ntasks=1 --cpus-per-task=10 --time 03-00:00 --mail-type=END,FAIL --mail-user=davidtian@berkeley.edu  --wrap "/global/scratch/users/davidtian/mutation_project/scripts/new.markdup.sh $IND $DHP_BAM_FOLDER"; done
