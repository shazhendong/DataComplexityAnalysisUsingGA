#!/bin/bash

# This is a bash script to zip all CSV files in the current directory individually

# Loop over all csv files in the directory
for file in *.csv
do
    # If the file exists
    if [ -f "$file" ]; then
        # Zip the file
        zip "${file%.csv}.zip" "$file"
        echo "$file has been zipped"
    else
        echo "No CSV files found"
    fi
done
