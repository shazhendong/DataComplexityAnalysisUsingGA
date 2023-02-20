# This py file perform complexity analysis on tsv, csv and plink dataset using problexity python package.
# parameters:
# -i: input file
# -o: output file
# -f: input file format (tsv, csv, plink)
# -p: phenotype column name

import argparse
import problexity as px
import pandas as pd
from pandas_plink import read_plink
import numpy as np

# read input arguments and call complexity analysis function
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", help="Input file", required=True)
    parser.add_argument("-o", "--output", help="Output file", required=False, default="complexityAnalysis.csv")
    parser.add_argument("-f", "--format", help="Input file format", required=True)
    parser.add_argument("-p", "--phenotype", help="Phenotype column name", required=False, default="trait")
    args = parser.parse_args()
    X, y = readData(args.input, args.output, args.format, args.phenotype)
    df = complexityAnalysis(X, y)
    # add the name of the input file to as a row in the dataframe
    name=args.input.split('/')[-1]
    df = df.append({'index_1d': 'metadata', 'index_2d': 'input_file', 'value': name}, ignore_index=True)
    df.to_csv(args.output, index=False, header=True)


# convert x 
def convertX(X):
    from sklearn.preprocessing import StandardScaler
    scaler = StandardScaler()
    X = scaler.fit_transform(X)
    return X

# covert preport to pandas dataframe
def convertReportToPandas(report):
    n_samples = report['n_samples']
    n_features = report['n_features']
    score = report['score']
    dic_complexities = report['complexities']
    n_classes = report['n_classes']
    classes = report['classes']
    arr_prior_probability = report['prior_probability']
    
    # create pandas dataframe
    df = pd.DataFrame.from_dict(dic_complexities, orient='index')
    # rename column
    df = df.rename(columns={0: "value"})
    # convert index to column named measure
    df['index_2d'] = df.index
    # reset index
    df = df.reset_index(drop=True)
    # add column 'index_1d'
    df['index_1d'] = 'complexity'
    
    # pandas.concat values n_samples, n_features, score, n_classes, classes and arr_prior_probability to dataframe with index_1d = 'metadata' index_2d = 'n_samples', 'n_features', 'score', 'n_classes', 'classes' and 'arr_prior_probability'
    
    df = df.append({'index_1d': 'metadata', 'index_2d': 'n_samples', 'value': n_samples}, ignore_index=True)
    df = df.append({'index_1d': 'metadata', 'index_2d': 'n_features', 'value': n_features}, ignore_index=True)
    df = df.append({'index_1d': 'metadata', 'index_2d': 'score', 'value': score}, ignore_index=True)
    df = df.append({'index_1d': 'metadata', 'index_2d': 'n_classes', 'value': n_classes}, ignore_index=True)
    df = df.append({'index_1d': 'metadata', 'index_2d': 'classes', 'value': classes}, ignore_index=True)
    df = df.append({'index_1d': 'metadata', 'index_2d': 'arr_prior_probability', 'value': arr_prior_probability}, ignore_index=True)

    return df

# read dataset
def readData(inputFile, outputFile, fileFormat, phenotype_col):
    # read input file
    if fileFormat == "tsv":
        df = pd.read_csv(inputFile, sep="\t")
        # get phenotype column
        y = df[phenotype_col].values
        # drop phenotype column
        X = df.drop(phenotype_col, axis=1)
        # convert X and y to numpy ndarray
        X = convertX(X)
        y = np.array(y)
    elif fileFormat == "csv":
        df = pd.read_csv(inputFile)
        # get phenotype column
        y = df[phenotype_col]
        # drop phenotype column
        X = df.drop(phenotype_col, axis=1)
        # convert X and y to numpy ndarray
        X = X.values
        y1 = []
        for i in range(len(y)):
            if y[i] == 'normal':
                y1.append(0)
            else:
                y1.append(1)
        y = np.array(y1)
    elif fileFormat == "plink":
        (bim, fam, bed) = read_plink(inputFile,verbose=False)
        X = bed.compute().T.astype('int8')
        # X to df
        X = pd.DataFrame(X)
        X = convertX(X)
        y = fam['trait']
        # convert y to numpy ndarray
        y1 = []
        for i in range(len(y)):
            if y[i] == '1':
                y1.append(0)
            else:
                y1.append(1)
        y = np.array(y1)
    else:
        print("Invalid file format. Please use tsv, csv or plink.")
        return

    return X, y

# complexity analysis
def complexityAnalysis(X, y):
    # Initialize CoplexityCalculator with default parametrization
    cc = px.ComplexityCalculator()
    # Fit model with data
    cc.fit(X,y)
    # get report and save to csv file
    report = cc.report()
    # convert report to pandas dataframe
    df = convertReportToPandas(report)
    return df

if __name__ == "__main__":
    main()