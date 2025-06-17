## Genotyping pipeline

1. Trimming fastqs
   * fastp.trim.sh and run.fastp.trim.sh

2. Mapping reads
   * bwa.mem.sh and run.bwa.mem.sh
  
3. Marking duplicates
   * new.markdup.sh and run.new.markdup.sh

4. Assess quality and coverage
   * qualimap.sh and run.qualimap.sh

5. Call GVCFs
   * GATK.haplotype.caller.sh and run.GATK.haplotype.caller.sh

6. Import GVCFs into GenomicsDB datastore 
   * GATK.genomic.database.import.sh
     
7. Genotype GVCFs
   * GATK.genotypeGVCFs.chrs.sh, GATK.genotypeGVCFs.scaffs.sh, and picard.gather.vcfs.sh
  
8. Hard filter and restrict to biallelic SNPs
   * GATK.hard.filter.variants.sh and GATK.exclude.hard.filtered.variants.sh
  
9. Run 1 round of BQSR
   * Build BQSR model
     * GATK.base.recalibrator.sh and GATK.base.recalibrator.parallel.sh
   * Apply BQSR model
     * GATK.apply.bqsr.sh and GATK.apply.bqsr.parallel.sh
   * Run BQSR model again, to see effect of applying BQSR.
     * GATK.base.recalibrator.round2.sh and GATK.base.recalibrator.round2.parallel.sh
     * GATK.BQSR.analyze.covariates.sh and GATK.analyze.covariates.parallel.sh

10. Run steps 5-8 on base quality score recalibrated bams
    * GATK.postBQSR.haplotype.caller.sh and run.GATK.postBQSR.haplotype.caller.sh
    * GATK.postBQSR.genomic.database.import.sh
    * GATK.postBQSR.genotypeGVCFs.chrs.sh, GATK.postBQSR.genotypeGVCFs.scaffs.sh, and picard.postBQSR.gather.vcfs.sh
    * postBQSR.GATK.hard.filter.variants.sh and postBQSR.GATK.exclude.hard.filtered.variants.sh
   
11. Additional SNP filters
    * Mappability mask
      ```bash
      #genmap K 150 -E2 mappability > 0.5 
      bcftools view -T /global/scratch/users/davidtian/Paper3_big_one/mapping_mask/DHP.k150.chrom.genmap.pos -Oz --threads 32 mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.vcf.gz > mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.vcf.gz
      ```

    * Minimum genotype quality filter (GQ >= 30)
      ```bash
      #GQ>30 recode
      bcftools filter -S. -e 'FMT/GQ<30' -Oz --threads 32 -o mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.vcf.gz mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.vcf.gz
      ```

    * Minimum 3 reads filter (FMT/DP >= 3)
      ```bash
      bcftools filter -S. -e 'FMT/DP<3' -Oz --threads 32 -o mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.vcf.gz mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.vcf.gz
      ```

    * Minimum and maximum site level depth filter (INFO/DP within 95th percentile)
      ```bash
      #assess INFO/DP
      vcftools --gzvcf mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.vcf.gz --site-depth --out k150mappable.GQ30.min3reads

      module load r/4.4.0-gcc-11.4.0
      data <- read.table("k150mappable.GQ30.min3reads.ldepth", header = TRUE, sep = "\t")
      sum_depth <- data[[3]]
      quantile(sum_depth, c(0.01, 0.025, 0.5, 0.975, 0.99))
      
      #results
       1%    2.5%     50%   97.5%     99% 
       231.00  406.00 1061.00 1531.00 2132.96

      #apply depth filter
      # min 0.025 = 406, max 0.975 = 1531
      bcftools view -e 'INFO/DP<406 || INFO/DP>1531' --threads 32 -Oz -o mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.vcf.gz mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.vcf.gz
      
      ```

    * Maximum missingness 25% filter
      ```bash
      bcftools view -e 'F_MISSING > 0.25' --threads 32 -Oz -o mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.vcf.gz mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.vcf.gz
      ```







