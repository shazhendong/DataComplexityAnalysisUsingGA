# this python file validate the predictive performance of feature selection results of GAMETES and GEO datasets.
# author: Zhendong Sha @2021-01-22
# parameters:
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
    training_dataset = sys.argv[sys.argv.index('-t') + 1]
    validation_dataset = sys.argv[sys.argv.index('-v') + 1]
    random_seed = int(sys.argv[sys.argv.index('-r') + 1])
    feature_selection_results = sys.argv[sys.argv.index('-f') + 1]
    output_file = sys.argv[sys.argv.index('-o') + 1]
    model_name = sys.argv[sys.argv.index('-m') + 1]
    return training_dataset, validation_dataset, random_seed, feature_selection_results, output_file, model_name

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
        model = DecisionTreeClassifier(random_state=0)
    elif model_name == 'lr':
        from sklearn.linear_model import LogisticRegression
        model = LogisticRegression(random_state=0)
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

if __name__ == '__main__':
    # read parameters
    training_dataset, validation_dataset, random_seed, feature_selection_results, output_file, model_name = read_parameters()

    # read training dataset
    df_training = pd.read_csv(training_dataset, sep='\t')
    # get X and y
    X_training = df_training.iloc[:, :-1]
    y_training = df_training.iloc[:, -1]
    # split training dataset into training and test stratified by y
    X_train, X_test, y_train, y_test = train_test_split(X_training, y_training, test_size=0.2, random_state=random_seed, stratify=y_training)

    # read validation dataset
    df_validation = pd.read_csv(validation_dataset, sep='\t')
    # get X and y
    X_validation = df_validation.iloc[:, :-1]
    y_validation = df_validation.iloc[:, -1]

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
    # use all available cores
    pool = Pool()
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


    