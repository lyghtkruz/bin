#!/bin/bash

output_dir="/home/kruz/test"
mkdir -p "$output_dir"

counter=1

for f in ./*.raw; do
    # Find JPEG start
    start=$(grep -aob $'\xFF\xD8\xFF' "$f" | head -1 | cut -d: -f1)

    # If no start found, skip
    [ -z "$start" ] && continue

    # Find JPEG end marker *after* start
    end=$(tail -c +$((start+1)) "$f" | grep -aob $'\xFF\xD9' | tail -1 | cut -d: -f1)

    # If no end found, skip
    [ -z "$end" ] && continue

    # Calculate total length of JPEG segment
    length=$((end + 2))

    # Output filename as 001.jpg, 002.jpg, ...
    printf -v num "%03d" "$counter"

    dd if="$f" bs=1 skip="$start" count="$length" of="$output_dir/$num.jpg" 2>/dev/null

    counter=$((counter+1))
done

