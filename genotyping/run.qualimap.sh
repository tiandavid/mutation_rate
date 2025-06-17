#!/bin/bash

source activate qualimap

INDS_ALL=(RT10 RT11 RT14 RT17 DH10 DH11 DH12 DH13 DH14 DH15 DH16 DH17 DH18 DH2 DH3 DH4 DH6 DH7 DH8 DH9 PR-Dtub1 PR-Dtub10 PR-Dtub11 PR-Dtub12 PR-Dtub2 PR-Dtub3 PR-Dtub4 PR-Dtub5 PR-Dtub6 PR-Dtub7 RT1 RT12 RT13 RT15 RT16 RT18 RT19 RT2 RT20 RT21 RT22 RT23 RT24 RT25 RT26 RT29 RT3 RT31 RT33 RT34 RT35 RT37 RT38 RT39 RT4 RT40 RT5 RT6 RT7 RT8 RT9)
DHP_MARK_DUP_FOLDER=/global/scratch/users/davidtian/mutation_project/bams

for IND in ${INDS_ALL[@]}; do sbatch --job-name=qualimap --output=R-%x.${IND}.%j.out --error=R-%x.${IND}.%j.err --account=co_rosalind --partition savio3 --nodes=1 --ntasks=1 --cpus-per-task=32 --time 03-00:00 --mail-type=END,FAIL --mail-user=davidtian@berkeley.edu  --wrap "/global/scratch/users/davidtian/mutation_project/scripts/qualimap.sh $IND $DHP_MARK_DUP_FOLDER"; done
