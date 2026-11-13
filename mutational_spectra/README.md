Mutational spectra scripts

Mutational Patterns needs individuals VCF as input.

* Take filtered mutations and intersect with VCF with bedtools
  ``` bash
  VCF=/global/scratch/users/davidtian/mutation_project/filtered_variants/multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.minALT4.filtered.binofiltered.hets_only.vcf.gz
  SNPS_BED=/global/scratch/users/davidtian/mutation_project/autozygous_segs/final_intersecting_snps_coordinates_IGV_checked.bed

  bedtools intersect -a $VCF -b $SNPS_BED -header > multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.minALT4.filtered.binofiltered.hets_only.IGV.checked.mutations.vcf
  ```
* split into ind VCFs
  * IGV.checked.split.putative.mutation.vcf.sh

Average mutation spectra among fishes based on data from Bergeron et al. 2023 (Fig. 4A)
* Data: bergeron8spectra.csv
* Code for plotting: bergeron.8.fish.species.spectra.R

Mutational Patterns (Blokzijl et al. 2018, Manders et al. 2022). Code for plotting Fig. 4B-D and Supp. Fig. 1-3.
* IGV.checked.mutational.patterns.R
