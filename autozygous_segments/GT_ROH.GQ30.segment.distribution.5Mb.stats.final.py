import pandas as pd
import os
import glob

# parameters
genome_size_chrs_only = 1112767855
rec_rate = 2 #cM/Mb
Mb = 1000000 #convert bp to Mb

#input / output
input_dir = "ind_GT_ROH_GQ30_regions_5Mb_min_final/"
output_file = "ind_GT_ROH_GQ30_segment_distribution_5Mb_stats.final.tsv"

if not os.path.exists(input_dir):
    raise FileNotFoundError(f"Directory {input_dir} does not exist.")

file_list = glob.glob(os.path.join(input_dir, "*.tsv"))

if not file_list:
    raise FileNotFoundError(f"No .tsv files found in {input_dir}.")

summary = []

# process each file
for file_path in file_list:
    df = pd.read_csv(file_path, sep="\t", header=None, skiprows=1)
    if len(df.columns) < 6:
        print(f"File {file_path} skipped: Less than 6 columns.")
        continue
    
    col6 = df[5].dropna()
    col6 = pd.to_numeric(col6, errors='coerce').dropna()
    
    # calc stats
    row_count = len(df)
    minimum = col6.min() / Mb
    median = col6.median() / Mb
    mean = col6.mean() / Mb
    cM_mean = mean * rec_rate
    maximum = col6.max() / Mb
    sum = col6.sum() / Mb
    FROH = sum / (genome_size_chrs_only / Mb)
    meioses = 100 / cM_mean
    
    # store results
    summary.append({
        "File": os.path.basename(file_path),
    "Num. of segments": row_count,
        "Min": minimum,
        "Median": median,
        "Mean": mean,
        "Max": maximum,
    "Sum": sum, 
    "FROH": FROH,
    "Meioses": meioses
    })
    print(f"Processed {file_path}: Num_segments={row_count}, Min={minimum}, Median={median}, Mean={mean}, Max={maximum}, Sum={sum}, FROH={FROH}, Meioses={meioses}")

# convert to df
summary_df = pd.DataFrame(summary)

# save stats
summary_df.to_csv(output_file, sep="\t", index=False)
print(f"Summary statistics saved to {output_file}")
