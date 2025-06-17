#!/bin/bash
#SBATCH --job-name=analyze_covar
#SBATCH --output=analyze_covar_%j.out
#SBATCH --error=analyze_covar_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=davidtian@berkeley.edu
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --exclusive
#SBATCH --account=co_fishes
#SBATCH -p savio3

# Load the default version of GNU parallel.
module load parallel/20220522

# This script fits the base score quality recalibration tool to each sample, in parallel.
parallel --jobs 10 -a samples.txt ./GATK.BQSR.analyze.covariates.sh {}
