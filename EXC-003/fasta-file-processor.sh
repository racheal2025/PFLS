# maximum number parameters or inputs
if [ "$#" -ne 1 ]; then
    echo 'PLEASE RUN IT ON JUST A SINGLE FASTA FILE'; exit 1
fi

# number of sequence
num_seq=$(grep '>' $1 | wc -l)

# Extract and put sequences in one line
sequence=$(awk '/>/ {if (seq) print seq; seq=""; next} {seq=seq $0} END {print seq}' "$1")

num_of_sequence_in_a_file=$(echo "$sequence" | wc -l)

# Total length of sequences
total_length__seq=$(echo "$sequence" | awk '{print length}' | awk '{sum_seq += $1; count++} END {print sum_seq}')

# length of seuences
length_of_seq=$(echo "$sequence" | awk '{print length}')

# length of longest sequence
longest_seq=$(echo "$length_of_seq" | sort -n | tail -n 1)

# Length of the shortest sequence
shortest_seq=$(echo "$length_of_seq" | sort -n | head -n 1)

# Average length of sequences
average_seq_length=$(echo "scale=2; $total_length__seq / $num_seq" | bc -l)

# GC content calculation
gc_con=$(echo "$sequence" | awk '{gc_count += gsub(/[GgCc]/, "", $1)} END {print gc_count}')

# At content calculation 
at_con=$(echo "$sequence" | awk '{at_count += gsub(/[AaTt]/, "", $1)} END {print at_count}')

# Sum of GC and ATcontent
sum_of_all_contents=$(echo "$at_con + $gc_con" | bc -l)

# GC percentage calculation

per_gc_content=$(echo "scale=2; ($gc_con / $sum_of_all_contents) * 100" | bc -l)

# Display the results
echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_seq"
echo "Total length of sequences: $total_length__seq"
echo "Length of the longest sequence: $longest_seq"
echo "Length of the shortest sequence: $shortest_seq"
echo "Average sequence length: $average_seq_length"
echo "GC Content (%): $per_gc_content"