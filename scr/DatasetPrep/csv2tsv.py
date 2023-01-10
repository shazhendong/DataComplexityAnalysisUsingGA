# this py transform csv into tsv
# Author: Zhendong Sha@2023-01-09
# Parameters:
# 1. input dataset (csv)
# 2. output dataset (tsv)

import pandas as pd
import sys

if __name__ == "__main__":
    # read input
    add_input = sys.argv[1] # input dataset
    add_output = sys.argv[2] # output dataset

    # read dataset
    df=pd.read_csv(add_input, sep=',', header=0)

    # write to file
    df.to_csv(add_output, sep='\t', index=False)