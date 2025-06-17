#!/bin/bash

IND=$1
FASTP=$2
FASTQ_FOLDER=$3
TRIM_FOLDER=$4

echo "Trimming adapters for: $IND"
#different versions of fastp command depending on file name stucture
$FASTP --thread 20 --in1 $FASTQ_FOLDER/${IND}_*_L008_R1_001.fastq.gz --out1 $TRIM_FOLDER/${IND}_R1_trimmed.fq.gz \
--in2 $FASTQ_FOLDER/${IND}_*_L008_R2_001.fastq.gz --out2 $TRIM_FOLDER/${IND}_R2_trimmed.fq.gz \
-j $TRIM_FOLDER/${IND}.json -h $TRIM_FOLDER/${IND}.html
echo "Done trimming for: $IND."
