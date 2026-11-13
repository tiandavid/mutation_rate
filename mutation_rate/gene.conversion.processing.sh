#!/bin/bash

mismatch_VCF=/global/scratch/users/davidtian/mutation_project/filtered_variants/multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.hets_only.QUAL100.GQ40.minALT4.filtered.binofiltered.hets_only.vcf.gz

#convert vcf into bed format
conda activate bedops
zcat $mismatch_VCF | convert2bed --input=vcf > mismatch_VCF.bed

#filter out IGV inspected false positives
bedtools intersect -a all_mismatches_snps_only_IGV_inspected.bed -b mismatch_VCF.bed -wa -wb \
| awk 'BEGIN{OFS="\t"; print "CHROM","POS","REF","ALT","AF","IND_ID"}
       {
         info=$13;  #INFO is the 13th column of the combined line (4 from snps.bed + 9 from vcf.bed)
         match(info, /AF=([^;]+)/, af);
         af_val = (RLENGTH>0 ? af[1] : "NA");
         print $1, $3, $10, $11, af_val, $4
       }' > mismatches_indID_with_AF_IGV_inspected.tsv


#convert AF to MAF 
awk '{ 
    af = $5; 
    maf = (af <= 0.5) ? af : 1 - af; 
    print $1, $2, $3, maf, $6
}' OFS='\t' mismatches_indID_with_AF_IGV_inspected.tsv > all_348_mismatches_with_MAF.tsv

#add pop column
awk 'BEGIN{OFS="\t"}
     NR==1 {print $0, "POP"; next}  # Add header
     {
       pop="lethal";                # Default
       if ($5 ~ /^DH([1-9]|1[0-6])$/) pop="adult";
       else if ($5 ~ /^DH(17|18)$/) pop="lethal";
       else if ($5 ~ /^RT([1-9]|1[0-9]|2[0-5])$/) pop="adult";
       print $0, pop;
     }' all_348_mismatches_with_MAF.tsv > all_348_mismatches_with_MAF_POPid.tsv

#separate our embryonic lethals from mature adults
awk 'NR==1 || $6 == "lethal"' all_348_mismatches_with_MAF_POPid.tsv > all_348_mismatches_with_MAF_POPid_lethal_only.tsv
awk 'NR==1 || $6 == "adult"' all_348_mismatches_with_MAF_POPid.tsv > all_348_mismatches_with_MAF_POPid_adult_only.tsv


#calculate number of mutations per min AF frequency
awk '{
  v=$4
  if(v!="") {
    for(i=100;i<=500;i+=25) {
      if(v*1000 <= i + 1e-6) c[i]++
    }
  }
}
END {
  for(i=100;i<=500;i+=25)
    printf "≤%.3f\t%d\n", i/1000, c[i]+0
}' all_348_mismatches_with_MAF_POPid_lethal_only.tsv

awk '{
  v=$4
  if(v!="") {
    for(i=100;i<=500;i+=25) {
      if(v*1000 <= i + 1e-6) c[i]++
    }
  }
}
END {
  for(i=100;i<=500;i+=25)
    printf "≤%.3f\t%d\n", i/1000, c[i]+0
}' all_348_mismatches_with_MAF_POPid_adult_only.tsv
