# This pipeline prepare the datasets for simulation analysis.
# Each dataset is moved from the data folder to the res folder.
# Author: Zhendong Sha@2023-02-01

#### Parameters ####
dir_proj=/Volumes/WorkingProj/DataComplexityAnalysisUsingGA
dir_data=$dir_proj/data_epistasis/GAMETES
dir_script=$dir_proj/scr
dir_res=$dir_proj/res_epistasis
folder_name=SimulationStudy

random_seed=25
pct_validation=0.2

# create a folder for the simulation study
rm -r $dir_res/$folder_name
mkdir -p $dir_res/$folder_name

# copy the GAMETES datasets to the simulation study folder
cp $dir_data/*.tsv $dir_res/$folder_name
# goto simulation study folder
cd $dir_res/$folder_name
# move GAMETES datasets
for file in *.tsv
do
    # get the name of the dataset
    name=${file%.tsv}
    echo $name
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

# split the datasets into training and validation sets
# for each file in the GAMETES folder
for folder in $dir_res/$folder_name/*
do
    echo $folder
    cd $folder
    # split the dataset into training and validation sets
    python $dir_script/DatasetPrep/split_dataset.py alldata.tsv train.tsv test.tsv $pct_validation $random_seed
    cd $home
done
