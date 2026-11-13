## Calculating mutation rate and plotting for Fig. 2

* Start with identified autozygous segments from ../autozygous_segments and remove 1 Mb from each end due to uncertainty
  ```bash
  awk -F'\t' 'BEGIN {OFS="\t"} {if (NR>0) {start=$4+1000000; end=($5-1000000>start) ? $5-1000000 : start; print $3, start, end, $2}}' multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.sorted_GTonly_RG_ONLY.CHR_ONLY_5Mb_min.txt > final.1Mb.cutoff.bed
  ```

* Make a directory and generate a bed file per segment
  ```bash
  mkdir final_split_bed_files
  cd final_split_bed_files
  awk '{print > $1"_"$2"_"$3"_"$4".bed"}' ../final.1Mb.cutoff.bed
  ```
* Split mutation VCF into ind VCF / .bed to make it easier to intersect segments and het variants in each individual.
  * final.split.ind.vcf.sh
  * convert into .bed format
    ```bash
    for vcf in final_individual_vcfs/*_het.vcf.gz; do zcat "$vcf" | awk '!/^#/ {print $1, $2-1, $2}' OFS="\t" > "final_individual_beds/$(basename "$vcf" .vcf.gz).bed"; done
    ```
* Use bedtools to intersect het snps with autozygous segments to get putative mutations
  ```bash
  awk '{print $1, $2, $3, $4}' OFS="\t" final.1Mb.cutoff.bed | while IFS=$'\t' read -r CHR START END IND; do 
    BED_FILE="final_individual_beds/${IND}_het.bed"; 
    if [[ -f "$BED_FILE" ]]; then 
        bedtools intersect -a <(echo -e "$CHR\t$START\t$END") -b "$BED_FILE" | awk -v chr="$CHR" -v start="$START" -v end="$END" -v ind="$IND" '{print chr, start, end, ind, $0}' OFS="\t"; 
    else 
        echo -e "$CHR\t$START\t$END\t$IND\tNA\tNA\tNA";  
    fi
  done >> final_autozygous_intersecting_snps_coordinates.tsv

  awk -F'\t' -v OFS='\t' '{ print $5, $6, $7 > ($4 ".intersecting.snp.coord.bed") }' ../final_autozygous_intersecting_snps_coordinates.tsv
  ```

* False positives found by checking read alignments with IGV-reports - see ../genotyping to see how these igv-reports was run.
  * IGV_false_positives.txt
 
* Remove false positives
  ```bash
  awk -F'\t' 'NR==FNR { seen[$1,$2,$3,$4]; next } !(($4,$5,$6,$7) in seen)' IGV_false_positives.tsv final_autozygous_intersecting_snps_coordinates.tsv | cut -f5-7 > final_autozygous_intersecting_snps_coordinates_IGV_checked.tsv
  ```

Apply same pipeline just for singletons.

* Gene conversion processing and calculation
  * collect.mismatches.sh
    ```bash
    cat *_intersect.bed | cut -f1-3 > all_mismatches_snps_only.bed
    #reorder columns and remove IGV false positives
    awk 'BEGIN{FS=OFS="\t"} {print $2, $3, $4, $1}' /global/scratch/users/davidtian/mutation_project/autozygous_segs/IGV_false_positives.tsv > IGV_false_positives_reordered.tsv
    grep -vFf IGV_false_positives_reordered.tsv all_mismatches_snps_only.bed > all_mismatches_snps_only_IGV_inspected.bed
    ```
  # gene.conversion.sh

### Plotting 

* Input data: gene_conversion_mut_rates_across_MAF_bins.csv, singleton_rates_final.csv
* Plotting: Fig.2.mut.rate.plot.stats.R gene_conversion.Rproj
