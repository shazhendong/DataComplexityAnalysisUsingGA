# this py plots the train, test, and validation AUCs as line plots with error bars
# Author: Zhendong Sha@2023-01-23
# Parameters:
# 1. train_auc_file: the csv file that contains the train, test and validation AUCs
# 2. output_file: the output file name


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import sys

# read in the train, test, and validation AUCs
auc_file = sys.argv[1]
output_file = sys.argv[2]
auc_df = pd.read_csv(auc_file)

# melt auc_roc_train, auc_roc_test and auc_roc_validation columns into one column named auc_roc
# add a column named type to indicate the type of AUCs
auc_df = pd.melt(auc_df, id_vars=['size_lim'], value_vars=['auc_roc_train', 'auc_roc_test', 'auc_roc_validation'], var_name='type', value_name='auc_roc')

# rename the type column
auc_df['type'] = auc_df['type'].str.replace('auc_roc_', '')
# type column use capital letter as the first letter
auc_df['type'] = auc_df['type'].str.capitalize()

# plot the train, test, and validation AUCs using seaborn
# x-axis: the number of sizelimt (detailed in auc_file)
# y-axis: the AUCs
# the three lines represent the 'auc_roc_train', 'auc_roc_test', 'auc_roc_validation' AUCs
# the error bars represent the 25th and 75th percentiles of the train, test, and validation AUCs

# set color palette as blend:#7AB,#EDA
#sns.set_palette(sns.color_palette(['#7AB','#EDA']))

plt = sns.pointplot(x='size_lim', y='auc_roc', hue='type', data=auc_df, ci=50)
plt.set(xlabel='Size limit', ylabel='AUC-ROC')
# set the position of the legend to bottom right


# save the plot as a pdf file
plt.figure.savefig(output_file)