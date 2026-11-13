#!/bin/bash
#SBATCH --job-name=igv_reports_intersecting_snp
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --mail-user=davidtian@berkeley.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --account=co_fishes
#SBATCH -p savio3

source activate igv_reports
INTERSECTING_SNP=/global/scratch/users/davidtian/mutation_project/autozygous_segs/final_autozygous_intersecting_snps_coordinates.tsv
INTERSECTING_SNP_BED=/global/scratch/users/davidtian/mutation_project/autozygous_segs/intersecting_snps_beds
BQSR_BAM=/global/scratch/users/davidtian/mutation_project/BQSR
OUT=/global/scratch/users/davidtian/mutation_project/IGV_reports

for sample in $(cut -f4 $INTERSECTING_SNP | sort -u); do
  bed="$INTERSECTING_SNP_BED/${sample}.intersecting.snp.coord.bed"
  bam="$BQSR_BAM/${sample}_BQSR.bam"
  create_report "$bed" \
    --fasta /global/scratch/users/davidtian/Paper3_big_one/reference_asm/DHP.FINAL.chrom.fasta \
    --flanking 1000 \
    --tracks "$bed" "$bam" \
    --output $OUT/${sample}.BQSR.intersecting.snp.bed.html
done
