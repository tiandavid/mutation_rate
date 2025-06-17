#!/bin/bash

IND=$1
DHP_BAM_FOLDER=$2

echo "$IND"
echo "$DHP_BAM_FOLDER"

module load java/22.0.1
/global/scratch/users/davidtian/download_software/gatk-4.6.1.0/gatk \
MarkDuplicatesSpark \
-I $DHP_BAM_FOLDER/${IND}.bam -O $DHP_BAM_FOLDER/${IND}.markdup.bam -M $DHP_BAM_FOLDER/${IND}.markdup_metrics.txt
echo "Done marking duplicates for $IND"
