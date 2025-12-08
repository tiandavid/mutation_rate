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

  * Maximum missingness 25% filter
      ```bash
      bcftools view -e 'F_MISSING > 0.25' --threads 32 -Oz -o mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.maxmiss25.vcf.gz mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.GQ30.min3reads.95.percentile.depth.vcf.gz
      ```

* Minimum and maximum site level depth filter (INFO/DP within 95th percentile)
      ```bash
      #assess INFO/DP
  vcftools --gzvcf mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.vcf.gz --site-depth --out mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25

      module load r/4.4.0-gcc-11.4.0
      R
      data <- read.table("mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.ldepth", header = TRUE, sep = "\t")
      sum_depth <- data[[3]]
      quantile(sum_depth, c(0.01, 0.025, 0.5, 0.975, 0.99))
       1%    2.5%     50%   97.5%     99% 
      401.00  529.00 1065.00 1457.00 2027.77 


      do 99% site level depth #2027
      bcftools filter -e 'INFO/DP>2027' --threads 32 -Oz -o mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.vcf.gz mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.vcf.gz
      
      ```

    * Minimum genotype quality filter (GQ >= 30)
      ```bash
      #GQ>30 recode
      bcftools filter -S. -e 'FMT/GQ<30' -Oz --threads 32 -o mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.vcf.gz mut.rate.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.vcf.gz
      ```

   
