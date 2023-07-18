#!/bin/bash

# This is a bash script to unzip all ZIP files in the current directory individually

# Loop over all zip files in the directory
for file in *.zip
do
    # If the file exists
    if [ -f "$file" ]; then
        # Unzip the file
        unzip "$file"
        echo "$file has been unzipped"
    else
        echo "No ZIP files found"
    fi
done
