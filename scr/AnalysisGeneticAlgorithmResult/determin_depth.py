# This python file determin the depth of train test and validation AUCs interms of size limite.
# Author: Zhendong Sha@2023-01-25
# Parameters:
# 1. train_auc_file: the csv file that contains the train, test and validation AUCs
# 2. output_file: the output file name

import pandas as pd
import sys

# read in the train, test, and validation AUCs
auc_file = sys.argv[1]
output_file = sys.argv[2]
auc_df = pd.read_csv(auc_file)

# group by size_lim for auc_roc_train, auc_roc_test and auc_roc_validation columns
# get the mean of the train, test, and validation AUCs
auc_df = auc_df.groupby('size_lim').agg({'auc_roc_train': ['mean'], 'auc_roc_test': ['mean'], 'auc_roc_validation': ['mean']})
# get the max for each column of auc_df
auc_df_max = auc_df.max()
# get 90% of the max for each column of auc_df
auc_df_max_90 = auc_df_max * 0.9
# get 95% of the max for each column of auc_df
auc_df_max_95 = auc_df_max * 0.95
# get 99% of the max for each column of auc_df
auc_df_max_99 = auc_df_max * 0.99
# get 99.5% of the max for each column of auc_df
auc_df_max_995 = auc_df_max * 0.995
# get 100% of the max for each column of auc_df
auc_df_max_100 = auc_df_max * 1.0

#### Determin the depth of train, test, and validation AUCs using kneed ####
from kneed import KneeLocator
# get the size_lim as the x-axis
x = auc_df.index.values
# transform x into list of float
x = [float(i) for i in x]
# get the train, test, and validation AUCs as the y-axis
y_train = auc_df['auc_roc_train'].values
y_test = auc_df['auc_roc_test'].values
y_validation = auc_df['auc_roc_validation'].values
# transform y_train, y_test, and y_validation into list of float
y_train = [float(i) for i in y_train]
y_test = [float(i) for i in y_test]
y_validation = [float(i) for i in y_validation]
# get the depth of train, test, and validation AUCs using kneed
kneedle_train = KneeLocator(x, y_train, S=1.0, curve='concave', direction='increasing')
kneedle_test = KneeLocator(x, y_test, S=1.0, curve='concave', direction='increasing')
kneedle_validation = KneeLocator(x, y_validation, S=1.0, curve='concave', direction='increasing')
# get the kneedle size_lim for train, test, and validation AUCs
kneedle_train_size_lim = kneedle_train.knee
kneedle_test_size_lim = kneedle_test.knee
kneedle_validation_size_lim = kneedle_validation.knee



#### Determin the depth of train, test, and validation AUCs that reach 90%, 95%, 99%, 99.5%, and 100% of the max ####
# get the value of the smallest size_lim for each column of auc_df that reaches 90% of the max
auc_df_90 = auc_df[auc_df >= auc_df_max_90]
# split auc_df_90 into three dataframes for train, test, and validation AUCs
auc_df_90_train = auc_df_90['auc_roc_train']
auc_df_90_test = auc_df_90['auc_roc_test']
auc_df_90_validation = auc_df_90['auc_roc_validation']
# get the size_lim of the first non-NaN value for auc_df_90_train, auc_df_90_test, and auc_df_90_validation
auc_df_90_train_size_lim = auc_df_90_train.first_valid_index()
auc_df_90_test_size_lim = auc_df_90_test.first_valid_index()
auc_df_90_validation_size_lim = auc_df_90_validation.first_valid_index()

# get the value of the smallest size_lim for each column of auc_df that reaches 95% of the max
auc_df_95 = auc_df[auc_df >= auc_df_max_95]
# split auc_df_95 into three dataframes for train, test, and validation AUCs
auc_df_95_train = auc_df_95['auc_roc_train']
auc_df_95_test = auc_df_95['auc_roc_test']
auc_df_95_validation = auc_df_95['auc_roc_validation']
# get the size_lim of the first non-NaN value for auc_df_95_train, auc_df_95_test, and auc_df_95_validation
auc_df_95_train_size_lim = auc_df_95_train.first_valid_index()
auc_df_95_test_size_lim = auc_df_95_test.first_valid_index()
auc_df_95_validation_size_lim = auc_df_95_validation.first_valid_index()

# get the value of the smallest size_lim for each column of auc_df that reaches 99% of the max
auc_df_99 = auc_df[auc_df >= auc_df_max_99]
# split auc_df_99 into three dataframes for train, test, and validation AUCs
auc_df_99_train = auc_df_99['auc_roc_train']
auc_df_99_test = auc_df_99['auc_roc_test']
auc_df_99_validation = auc_df_99['auc_roc_validation']
# get the size_lim of the first non-NaN value for auc_df_99_train, auc_df_99_test, and auc_df_99_validation
auc_df_99_train_size_lim = auc_df_99_train.first_valid_index()
auc_df_99_test_size_lim = auc_df_99_test.first_valid_index()
auc_df_99_validation_size_lim = auc_df_99_validation.first_valid_index()

# get the value of the smallest size_lim for each column of auc_df that reach 99.5% of the max
auc_df_995 = auc_df[auc_df >= auc_df_max_995]
# split auc_df_995 into three dataframes for train, test, and validation AUCs
auc_df_995_train = auc_df_995['auc_roc_train']
auc_df_995_test = auc_df_995['auc_roc_test']
auc_df_995_validation = auc_df_995['auc_roc_validation']
# get the size_lim of the first non-NaN value for auc_df_995_train, auc_df_995_test, and auc_df_995_validation
auc_df_995_train_size_lim = auc_df_995_train.first_valid_index()
auc_df_995_test_size_lim = auc_df_995_test.first_valid_index()
auc_df_995_validation_size_lim = auc_df_995_validation.first_valid_index()

# get the value of the smallest size_lim for each column of auc_df that reach 100% of the max
auc_df_100 = auc_df[auc_df >= auc_df_max_100]
# split auc_df_100 into three dataframes for train, test, and validation AUCs
auc_df_100_train = auc_df_100['auc_roc_train']
auc_df_100_test = auc_df_100['auc_roc_test']
auc_df_100_validation = auc_df_100['auc_roc_validation']
# get the size_lim of the first non-NaN value for auc_df_100_train, auc_df_100_test, and auc_df_100_validation
auc_df_100_train_size_lim = auc_df_100_train.first_valid_index()
auc_df_100_test_size_lim = auc_df_100_test.first_valid_index()
auc_df_100_validation_size_lim = auc_df_100_validation.first_valid_index()


# merge the size_lim for each column of auc_df that reaches 90%, 95%, 99%, 99.5%, max and kneed of the max with train, test, and validation as the column names
auc_df_90_size_lim = pd.DataFrame({'train': [auc_df_90_train_size_lim], 'test': [auc_df_90_test_size_lim], 'validation': [auc_df_90_validation_size_lim]}) 
auc_df_95_size_lim = pd.DataFrame({'train': [auc_df_95_train_size_lim], 'test': [auc_df_95_test_size_lim], 'validation': [auc_df_95_validation_size_lim]})
auc_df_99_size_lim = pd.DataFrame({'train': [auc_df_99_train_size_lim], 'test': [auc_df_99_test_size_lim], 'validation': [auc_df_99_validation_size_lim]})
auc_df_995_size_lim = pd.DataFrame({'train': [auc_df_995_train_size_lim], 'test': [auc_df_995_test_size_lim], 'validation': [auc_df_995_validation_size_lim]})
auc_df_100_size_lim = pd.DataFrame({'train': [auc_df_100_train_size_lim], 'test': [auc_df_100_test_size_lim], 'validation': [auc_df_100_validation_size_lim]})
auc_df_kneed_size_lim = pd.DataFrame({'train': [kneedle_train_size_lim], 'test': [kneedle_test_size_lim], 'validation': [kneedle_validation_size_lim]})
# merge the these dataframes into one dataframe
auc_df_size_lim = pd.concat([auc_df_90_size_lim, auc_df_95_size_lim, auc_df_99_size_lim, auc_df_995_size_lim, auc_df_100_size_lim, auc_df_kneed_size_lim], ignore_index=True)
# rename the index of auc_df_size_lim
auc_df_size_lim.index = ['90%', '95%', '99%', '99.5%', '100%', 'kneedle']
# write auc_df_size_lim to a csv file
auc_df_size_lim.to_csv(output_file)

