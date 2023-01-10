# this py gather ids for training and validation sets
# Author: Zhendong Sha@2023-01-10
# Parameters:
# 1. input dataset (plink)
# 2. random state
# 3. validation pct
# 4. output training set ids
# 5. output validation set ids

import sys
import pandas as pd
import pandas_plink as pp
from sklearn.model_selection import train_test_split

if __name__ == "__main__":
    # read plink file
    (bim, fam, bed) = pp.read_plink(sys.argv[1],verbose=False)

    # read random state for train_test_split
    random_state = int(sys.argv[2])

    # prepare dataset
    dataset = bed.compute().T
    df = pd.DataFrame(dataset)
    df.columns = bim['snp']
    X = df
    # add labels
    df['Labels'] = fam['trait']
    y = df['Labels'].values
    
    # split dataset
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=float(sys.argv[3]), random_state=random_state, stratify=y)

    # get index of train from fam
    fam_train = fam.loc[X_train.index]
    fam_test = fam.loc[X_test.index]
    
    # prepare training fid and iid
    df_out_train = pd.DataFrame()
    df_out_train['fid'] = fam_train['fid']
    df_out_train['iid'] = fam_train['iid']

    # prepare testing fid and iid
    df_out_test = pd.DataFrame()
    df_out_test['fid'] = fam_test['fid']
    df_out_test['iid'] = fam_test['iid']

    # write to file
    df_out_train.to_csv(sys.argv[4], sep='\t', index=False, header=False)
    df_out_test.to_csv(sys.argv[5], sep='\t', index=False, header=False)
    
    
    

    
    


