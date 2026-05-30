import pandas as pd
import os

# read tsv output into df
file_path = 'multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.sorted_GTonly_RG_ONLY.CHR_ONLY_5Mb_min.txt'
output_dir = 'ind_GT_ROH_GQ30_regions_5Mb_min_final/'  

os.makedirs(output_dir, exist_ok=True)

# read file
df = pd.read_csv(file_path, sep='\t', header=None)

# group by ind (2nd column)
unique_id_column = df.columns[1]
grouped = df.groupby(unique_id_column)

# save per ind output
for unique_id, group in grouped:
    output_file = f"{output_dir}{unique_id}.GT.ROHs.GQ30.5Mb.min.final.tsv"  
    group.to_csv(output_file, sep='\t', index=False)  
    print(f"Saved {output_file}")
