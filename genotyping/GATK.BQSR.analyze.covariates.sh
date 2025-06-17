#!/bin/bash

# This script is used by gnu parallel to run AnalyzeCovariates and create a BQSR recalibration report

module load java/22.0.1
module load r/4.4.0-gcc-11.4.0
module load r-ggplot2/3.4.2

gatk=/global/scratch/users/davidtian/download_software/gatk-4.2.6.1/gatk
BQSR_TABLE=/global/scratch/users/davidtian/mutation_project/BQSR
PLOTS=/global/scratch/users/davidtian/mutation_project/BQSR/analyze_covariates_plots

echo "Generating BQSR recalibration report for $1"
$gatk AnalyzeCovariates \
        -before $BQSR_TABLE/$1_base-recal.table \
        -after $BQSR_TABLE/$1_base-recal2.table \
        -plots $PLOTS/$1_recalibration_plots_round1.pdf >& $PLOTS/$1_recalibration_plots_round1.out
echo "Done"
