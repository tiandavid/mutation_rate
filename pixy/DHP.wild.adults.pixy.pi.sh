#!/bin/bash
#SBATCH --job-name=pixy
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err
#SBATCH --time=72:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mail-user=davidtian@berkeley.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --account=co_fishes
#SBATCH -p savio3

pixy --stats pi \
--vcf /global/scratch/users/davidtian/Paper3_big_one/FINAL_RUN/DHP_filtered_variants/final.allsites.filtered.combined.vcf.gz \
--populations /global/scratch/users/davidtian/Paper3_big_one/FINAL_RUN/analyses/pixy2/DHP_wild_adult_popfile.txt \
--window_size 1000000 \
--chromosomes 'Chr1,Chr2,Chr3,Chr4,Chr5,Chr6,Chr7,Chr8,Chr9,Chr10,Chr11,Chr12,Chr13,Chr14,Chr15,Chr16,Chr17,Chr18,Chr19,Chr20,Chr21,Chr22,Chr23,Chr24' \
--n_cores 32 \
--output_folder pixy_output \
--output_prefix pixy_output_DHP_wild_adults_1Mb_win
