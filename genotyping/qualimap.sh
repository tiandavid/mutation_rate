#!/bin/bash

IND=$1
DHP_MARK_DUP_FOLDER=$2

module load java/22.0.1

qualimap bamqc -nt 32 --java-mem-size=90G -bam $DHP_MARK_DUP_FOLDER/${IND}.markdup.bam -outdir $DHP_MARK_DUP_FOLDER/${IND}.markdup.qualimap.results
