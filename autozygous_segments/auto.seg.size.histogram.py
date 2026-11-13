import pandas as pd
import matplotlib.pyplot as plt

#load file
file_path = "/global/scratch/users/davidtian/mutation_project/autozygous_segs/multisample.postBQSR.biallelic.HARD.FILTER.EXCLUDED.SNPS.k150mappable.maxmiss25.99depth.GQ30.min.third.max.double.filtered.sorted_GTonly_RG_ONLY.CHR_ONLY_5Mb_min.txt"
df = pd.read_csv(file_path, sep="\t", header=None, usecols=[5], names=["segment_size"])

#make histogram
plt.figure(figsize=(8, 6))
plt.hist(df["segment_size"], bins=30, edgecolor="black", alpha=0.7)
plt.title("Distribution of Autozygous Segment Sizes")
plt.xlabel("Segment Size")
plt.ylabel("Frequency")
plt.grid(True)

output_filename = "histogram_all_auto_segs_GQ30_5Mb_min.final.png"
plt.savefig(output_filename)
plt.show()

print(f"Histogram saved: {output_filename}")
#export
df.to_csv("segment_sizes_for.R.csv", index=False)