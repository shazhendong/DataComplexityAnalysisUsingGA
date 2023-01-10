# The pipeline specified in this script is used to prepare the data for the analysis.
# Each dataset is divded into training and validation sets.
# Author: Zhendong Sha@2023-01-09

#### Parameters ####

pct_validation=0.2

dir_data=data
dir_res=res

home=$(pwd)

#### Process GAMETES datasets ####

mkdir -p $dir_res/GAMETES
# move GAMETES dataset to res folder
cp $dir_data/GAMETES/*.tsv $dir_res/GAMETES 
# goto GAMETES folder
cd $dir_res/GAMETES
# move GAMETES datasets
for file in *.tsv
do
    # get the name of the dataset
    name=${file%.tsv}
    # make a folder for the dataset
    mkdir -p $name
    # move the dataset to the folder
    mv $file $name
    # goto the folder
    cd $name
    # rename the file to alldata.tsv
    mv $file alldata.tsv
    cd ..
done
cd $home

# split the datasets into training and validation sets
# for each file in the GAMETES folder
for folder in $dir_res/GAMETES/*
do
    cd $folder
    # split the dataset into training and validation sets
    python $home/scr/DatasetPrep/split_dataset.py alldata.tsv train.tsv validation.tsv 0.2 25
    cd $home
done

cd $home