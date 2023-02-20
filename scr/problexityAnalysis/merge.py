# this file merge the results of complexity analysis
# parameters:
# [1-end]: input files

import sys
import pandas as pd

if __name__ == "__main__":
    # read input parameters
    input_files = sys.argv[1:]

    # read input files
    dfs = []
    for input_file in input_files:
        df = pd.read_csv(input_file)
        # set index_1d and index_2d as the keys
        df = df.set_index(['index_1d', 'index_2d'])
        dfs.append(df)
    
    # concatenate dataframes by columns
    df = pd.concat(dfs, axis=1)
    # transpose dataframe
    df = df.transpose()
    # reset index
    df = df.reset_index(drop=True)

    # set the (metadata, input_file) as the index
    df = df.set_index(('metadata', 'input_file'))

    # save dataframe to csv file
    df.to_csv('complexity_analysis.csv', index=True)

