## Calculating mutation rate and plotting for Fig. 2

* Start with identified autozygous segments from ../autozygous_segments and remove 1 Mb from each end due to uncertainty
  ```bash
  awk -F'\t' 'BEGIN {OFS="\t"} {if (NR>0) {start=$4+1000000; end=($5-1000000>start) ? $5-1000000 : start; print $3, start, end, $2}}' multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.sorted_GTonly_RG_ONLY.CHR_ONLY_5Mb_min.txt > final.1Mb.cutoff.bed
  ```

* False positives found by checking read alignments with IGV-reports: IGV_false_positives.txt

### Plotting 

* Input data: gene_conversion_mut_rates_across_MAF_bins.csv, singleton_rates_final.csv
* Plotting: Fig.2.mut.rate.plot.stats.R gene_conversion.Rproj
