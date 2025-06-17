#!/bin/bash

IND=$1
GATK=$2
REFERENCE=$3
BQSR_FOLDER=$4
DHP_RAW_VARIANTS_FOLDER=$5

module load java/22.0.1
$GATK --java-options "-Xmx32G" HaplotypeCaller -R $REFERENCE/DHP.FINAL.chrom.fasta -ERC GVCF -I $BQSR_FOLDER/${IND}_BQSR.bam \
-O $DHP_RAW_VARIANTS_FOLDER/${IND}.postBQSR.g.vcf.gz
