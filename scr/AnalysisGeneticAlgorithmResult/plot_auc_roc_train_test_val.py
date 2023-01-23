# this python file validate the predictive performance of feature selection results of plink, GAMETES and GEO datasets.
# note this file works for binary classification problems only.
# author: Zhendong Sha @2021-01-22
# parameters:
# -p: plink dataset (if -p is specified, -t and -v is individual id)
# -t: training dataset
# -v: validation dataset
# -r: randon seed
# -f: feature selection results
# -o: output file name
# -m: model name

import sys
import pandas as pd
import numpy as np
from sklearn.metrics import roc_auc_score
from sklearn.model_selection import train_test_split


# read parameters
def read_parameters():
    # read parameters
    # if contain -p read plink dataset file name
    if '-p' in sys.argv:
        plink_dataset_file = sys.argv[sys.argv.index('-p') + 1]
    else:
        plink_dataset_file = None
    training_dataset = sys.argv[sys.argv.index('-t') + 1]
    validation_dataset = sys.argv[sys.argv.index('-v') + 1]
    random_seed = int(sys.argv[sys.argv.index('-r') + 1])
    feature_selection_results = sys.argv[sys.argv.index('-f') + 1]
    output_file = sys.argv[sys.argv.index('-o') + 1]
    model_name = sys.argv[sys.argv.index('-m') + 1]
    return training_dataset, validation_dataset, random_seed, feature_selection_results, output_file, model_name, plink_dataset_file

def validate_feature_selection(feature_selection, X_train, y_train, X_test, y_test, X_validation, y_validation, model_name):
    # get feature selection
    feature_selection = np.array(feature_selection)
    # get X_train, X_test, X_validation
    X_train = X_train.iloc[:, feature_selection]
    X_test = X_test.iloc[:, feature_selection]
    X_validation = X_validation.iloc[:, feature_selection]
    # get model
    if model_name == 'rf':
        from sklearn.ensemble import RandomForestClassifier
        model = RandomForestClassifier(n_estimators=100, random_state=0)
    elif model_name == 'svm':
        from sklearn.svm import SVC
        model = SVC(gamma='auto')
    elif model_name == 'knn':
        from sklearn.neighbors import KNeighborsClassifier
        model = KNeighborsClassifier(n_neighbors=5)
    elif model_name == 'dt':
        from sklearn.tree import DecisionTreeClassifier
        model = DecisionTreeClassifier(random_state=0, class_weight='balanced',min_samples_split=0.05)
    elif model_name == 'lr':
        from sklearn.linear_model import LogisticRegression
        model = LogisticRegression(random_state=0, max_iter=10000,class_weight='balanced')
    elif model_name == 'mlp':
        from sklearn.neural_network import MLPClassifier
        model = MLPClassifier(random_state=0)
    else:
        print('model name is not supported')
        exit(1)
    # fit model
    model.fit(X_train, y_train)
    # predict y
    y_pred_train = model.predict(X_train)
    y_pred_test = model.predict(X_test)
    y_pred_validation = model.predict(X_validation)
    # get auc_roc
    auc_roc_train = roc_auc_score(y_train, y_pred_train)
    auc_roc_test = roc_auc_score(y_test, y_pred_test)
    auc_roc_validation = roc_auc_score(y_validation, y_pred_validation)
    return auc_roc_train, auc_roc_test, auc_roc_validation

def labelTransform(y):
    # transform y to 0 and 1. if y is 'normal', then y = 0; else y = 1
    # return y if y is already 0 and 1
    if np.array_equal(np.unique(y), np.array([0, 1])):
        return y
    y = np.array(y)
    y[y == 'normal'] = 0
    y[y != 0] = 1
    return y.astype('int')

if __name__ == '__main__':
    # read parameters
    training_dataset, validation_dataset, random_seed, feature_selection_results, output_file, model_name, plink_dataset_file = read_parameters()

    # if plink dataset is specified, read plink dataset
    if plink_dataset_file is not None:
        # read plink dataset using pandas_plink
        from pandas_plink import read_plink
        (bim, fam, bed) = read_plink(plink_dataset_file,verbose=False)
        dataset_X = bed.compute().T.astype('int8')
        dataset_y = fam['trait'].values.astype('int8')

        # read training and validation ids from training dataset
        df_training_ids = pd.read_csv(training_dataset, sep='\t')
        training_ids = df_training_ids.iloc[:, 1] # get iid
        df_validation_ids = pd.read_csv(validation_dataset, sep='\t')
        validation_ids = df_validation_ids.iloc[:, 1] # get iid

        # get ids of training and validation ids from plink dataset
        training_ids_index = np.where(np.isin(fam['iid'].values, training_ids))[0]
        validation_ids_index = np.where(np.isin(fam['iid'].values, validation_ids))[0]

        # prepare training dataset
        X_training = dataset_X[training_ids_index, :]
        # transform X_training to dataframe
        X_training = pd.DataFrame(X_training)
        y_training = dataset_y[training_ids_index]
        # split training dataset into training and test stratified by y
        X_train, X_test, y_train, y_test = train_test_split(X_training, y_training, test_size=0.2, random_state=random_seed, stratify=y_training)
        # prepare validation dataset
        X_validation = dataset_X[validation_ids_index, :]
        # transform X_validation to dataframe
        X_validation = pd.DataFrame(X_validation)
        y_validation = dataset_y[validation_ids_index]

    else:

        # read training dataset
        df_training = pd.read_csv(training_dataset, sep='\t')
        # get X and y
        X_training = df_training.iloc[:, :-1]
        y_training = df_training.iloc[:, -1]
        # transform y to 0 and 1
        y_training = labelTransform(y_training)

        # split training dataset into training and test stratified by y
        X_train, X_test, y_train, y_test = train_test_split(X_training, y_training, test_size=0.2, random_state=random_seed, stratify=y_training)

        # read validation dataset
        df_validation = pd.read_csv(validation_dataset, sep='\t')
        # get X and y
        X_validation = df_validation.iloc[:, :-1]
        y_validation = df_validation.iloc[:, -1]
        # transform y to 0 and 1
        y_validation = labelTransform(y_validation)

    # read feature selection results
    df_feature_selection = pd.read_csv(feature_selection_results, sep=',')
    # get feature selections
    arr_feature_selections = df_feature_selection.iloc[:, 2].values
    # transform feature selection to 2d list
    arr_feature_selections = [feature_selection.replace(' ', '').replace('[', '').replace(']', '').split(',') for feature_selection in arr_feature_selections]
    # transform feature selection to int
    arr_feature_selections = [[int(feature) for feature in feature_selection] for feature_selection in arr_feature_selections]
    
    # get the predictive performance of each feature selection result using multiprocessing
    # prepare the input for multiprocessing
    input_list = [(feature_selection, X_train, y_train, X_test, y_test, X_validation, y_validation, model_name) for feature_selection in arr_feature_selections]
    # get the predictive performance of each feature selection result
    from multiprocessing import Pool
    # use eight cores
    pool = Pool(8)
    arr_results = pool.starmap(validate_feature_selection, input_list)
    # close pool
    pool.close()
    pool.join()
    # append results to df_feature_selection
    df_feature_selection['auc_roc_train'] = [result[0] for result in arr_results]
    df_feature_selection['auc_roc_test'] = [result[1] for result in arr_results]
    df_feature_selection['auc_roc_validation'] = [result[2] for result in arr_results]

    # output results
    df_feature_selection.to_csv(output_file, sep=',', header=True, index=None)


    