##Genotyping pipeline

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
      
      ```

    * Minimum GQ30 filter 

    * Minimum 3 reads filter (FMT/DP)

    * Minimum and maximum site level depth filter (INFO/DP)

    * Maximum missingness 25% filter 







