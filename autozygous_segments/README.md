## Pipeline

1. Identify autozygous segments with Bcftools/ROH
   * mut.rate.bcftools.roh.GT30.sh

2. Restrict results to chromosomes only
   ```bash
   grep -v "Sca" mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted_GTonly_RG_ONLY.txt > 
   mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted_GTonly_RG_ONLY_CHR_ONLY.txt
   ```
3. Restrict results to segments >= 5 Mb
   ```bash
   awk -F'\t' '$6 >= 5000000' mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted_GTonly_RG_ONLY_CHR_ONLY.txt > 
   mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.sorted_GTonly_RG_ONLY_CHR_ONLY_5Mb_min.txt
   ```

