# This py file split dataset into train and validation set.
# Author: Zhendong Sha@2023-01-09
# Parameters:
# 1. input dataset (tsv)
# 2. output train dataset (tsv)
# 3. output validation dataset (tsv)
# 4. validation set pct
# 5. random states

import pandas as pd
import sys
from sklearn.model_selection import train_test_split
import pandas_plink as pp

def split(X, y, pct, seed):
    return train_test_split(X, y, test_size=pct, random_state=seed, stratify=y)


if __name__ == "__main__":
    add_input = sys.argv[1] # input dataset
    add_train = sys.argv[2] # output train dataset
    add_valid = sys.argv[3] # output validation dataset
    pct = float(sys.argv[4]) # validation set pct
    random_state = int(sys.argv[5]) # random state

    #### read dataset ####
    
    df = pd.read_csv(add_input, sep='\t', header=0)
    
    #### split dataset ####

    # drop last column
    X = df.drop(df.columns[-1], axis=1)
    # get last column
    y = df[df.columns[-1]].values
    # split dataset
    X_train, X_valid, y_train, y_valid = split(X, y, pct, random_state)

    #### prepare output dfs ####
    # training set
    df_train = pd.DataFrame(X_train)
    # add labels to training set
    df_train['Labels'] = y_train

    # validation set
    df_valid = pd.DataFrame(X_valid)
    # add labels to validation set
    df_valid['Labels'] = y_valid

    #### write to file ####
    df_train.to_csv(add_train, index=False, sep='\t') # save dataset
    df_valid.to_csv(add_valid, index=False, sep='\t') # save dataset


