# This py transforms the results of GA into a csv file
# Author: Zhendong Sha@2023-01-22

# Parameters:
# 1. input file name
# 2. output file name

# Columns of the output file:
# 1. sizelimite
# 2. fitness
# 3. feture selection

import sys
import pandas as pd

def main():
    # read the input file
    input_file = open(sys.argv[1], 'r')
    lines = input_file.readlines()
    input_file.close()

    # get size limit from input file name
    size_limit = sys.argv[1].split('.')[0].split('_')[-1]

    # process the input file
    arr_fitness = []
    arr_featureSelection = []
    # interate each line by index
    for i in range(len(lines)):
        # if line is not starts with '[' continue
        if not lines[i].startswith('['):
            continue
        # if line is starts with '['
        else:
            # get feature selection
            arr_featureSelection.append(lines[i].strip())
            # get fitness for previous line
            fitness = lines[i-1].split('\t')[-1].strip()
            arr_fitness.append(fitness)
    # prepare the output df
    df = pd.DataFrame({'size_limit': size_limit, 'fitness': arr_fitness, 'feature_selection': arr_featureSelection})

    # write the df to csv file (without index and header)
    df.to_csv(sys.argv[2], index=False, header=False)


main()