#!/bin/bash

INDS_ALL=(RT26 RT29 RT31 RT33 RT34 RT35 RT37 RT38 RT39 RT40)
FASTP=/global/scratch/users/davidtian/download_software/fastp
FASTQ_FOLDER=/clusterfs/fishes/david/genomes/M004347
TRIM_FOLDER=/global/scratch/users/davidtian/mutation_project/trim_fastqs

for IND in ${INDS_ALL[@]}; do sbatch --job-name=fastp.trim --output=R-%x.${IND}.%j.out --error=R-%x.${IND}.%j.err --account=co_fishes -p savio4_htc --nodes=1 --ntasks=1 --cpus-per-task=4 -t 03-00:00 --mail-type=END,FAIL --mail-user=davidtian@berkeley.edu  --wrap "/global/scratch/users/davidtian/mutation_project/scripts/fastp.trim.sh $IND $FASTP $FASTQ_FOLDER $TRIM_FOLDER"; done
