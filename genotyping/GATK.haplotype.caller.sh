#!/bin/bash

IND=$1
GATK=$2
REFERENCE=$3
DHP_MARK_DUP_FOLDER=$4
DHP_RAW_VARIANTS_FOLDER=$5

module load java/22.0.1
$GATK --java-options "-Xmx32G" HaplotypeCaller -R $REFERENCE/DHP.FINAL.chrom.fasta -ERC GVCF -I $DHP_MARK_DUP_FOLDER/${IND}.markdup.bam \
-O $DHP_RAW_VARIANTS_FOLDER/${IND}.g.vcf.gz
