#!/bin/bash

IND=$1
REFERENCE=$2
FASTQ_FOLDER=$3
DHP_BAM_FOLDER=$4

echo "$IND"
echo "$REFERENCE"
echo "$FASTQ_FOLDER"
echo "$DHP_BAM_FOLDER"

echo "Aligning fastq files for: $IND"
header=$(zcat $FASTQ_FOLDER/${IND}_R1_trimmed.fq.gz | head -n 1)
echo "Read Group @RG\tID:$IND\tSM:$IND\tLB:$IND"_lib"\tPL:ILLUMINA"

#mapping reads to DHPref
bwa mem $REFERENCE/DHP.FINAL.chrom.fasta -t 32 -R $(echo "@RG\tID:$IND\tSM:$IND\tLB:$IND"_lib"\tPL:ILLUMINA") $FASTQ_FOLDER/${IND}_R1_trimmed.fq.gz $FASTQ_FOLDER/${IND}_R2_trimmed.fq.gz | samtools view -@ 32 -O BAM -o $DHP_BAM_FOLDER/$IND.bam
echo "Done mapping reads to DHP reference."

