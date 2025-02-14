#!/bin/bash

set -e  # Exit on error

output_dir="COMBINED-DATA"

# Clean up and create output directory
[ -d "$output_dir" ] && rm -rf "$output_dir"
mkdir "$output_dir"

# Process each sample directory
find RAW-DATA -type d -name 'DNA*' | while read dir; do
    culture=$(basename "$dir")
    new_name=$(awk -v c="$culture" '$1 == c {print $2}' RAW-DATA/sample-translation.txt)

    cp "$dir/checkm.txt" "$output_dir/${new_name}-CHECKM.txt"
    cp "$dir/gtdb.gtdbtk.tax" "$output_dir/${new_name}-GTDB-TAX.txt"

    mag_idx=1
    bin_idx=1

    for fasta in "$dir/bins"/*.fasta; do
        bin=$(basename "$fasta" .fasta)
        read comp cont <<< $(awk -v b="$bin" '$0 ~ b {print $13, $14}' "$dir/checkm.txt")

        if [[ "$bin" == "bin-unbinned" ]]; then
            fname="${new_name}_UNBINNED.fa"
        elif (( $(echo "$comp >= 50" | bc -l) && $(echo "$cont < 5" | bc -l) )); then
            fname=$(printf "%s_MAG_%03d.fa" "$new_name" $mag_idx)
            ((mag_idx++))
        else
            fname=$(printf "%s_BIN_%03d.fa" "$new_name" $bin_idx)
            ((bin_idx++))
        fi

        cp "$fasta" "$output_dir/$fname" && echo "$fname copied successfully."
    done

done

echo "Script execution completed."