# The pipeline specified in this script is used to prepare the data for the analysis.
# Each dataset is divded into training and validation sets.
# Author: Zhendong Sha@2023-01-09

#### Parameters ####

pct_validation=0.2
random_seed=25

dir_data=data
dir_res=res

home=$(pwd)

#### Process GWAS datasets #### 
echo "Process GWAS datasets"
mkdir -p $dir_res/GWAS
# move GWAS dataset to rews folder
cp $dir_data/GWAS/WithImputation/*.* $dir_res/GWAS
# goto GAMETES folder
cd $dir_res/GWAS
# get sample id for train cohort and test cohort
python $home/scr/DatasetPrep/split_plink_dataset.py AllSamples_Imputation $random_seed $pct_validation training_set_id_randomSeed_$random_seed.txt validation_set_id_randomSeed_$random_seed.txt
# generate cohort training plink files
plink --bfile AllSamples_Imputation --keep training_set_id_randomSeed_$random_seed.txt --make-bed --out train

# remove garbage
# rm AllSamples_Imputation_training_*

cd $home

#### Process GAMETES datasets ####
echo "Process GAMETES datasets"
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
    echo $folder
    cd $folder
    # split the dataset into training and validation sets
    python $home/scr/DatasetPrep/split_dataset.py alldata.tsv train.tsv validation.tsv $pct_validation $random_seed
    cd $home
done

cd $home

#### Process GEO datasets ####
echo "Process GEO datasets"
mkdir -p $dir_res/GEO_Datasets
# move GEO dataset to res folder
cp $dir_data/GEO\ datasets/*.csv $dir_res/GEO_Datasets 
# goto GEO folder
cd $dir_res/GEO_Datasets
# move GEO datasets
for file in *.csv
do
    # get the name of the dataset
    name=${file%.csv}
    # make a folder for the dataset
    mkdir -p $name
    # move the dataset to the folder
    mv $file $name
    # goto the folder
    cd $name
    # rename the file to alldata.csv
    mv $file alldata.csv
    cd ..
done
cd $home

# split the datasets into training and validation sets
# for each file in the GEO folder
for folder in $dir_res/GEO_Datasets/*
do
    echo $folder
    cd $folder
    # transform the dataset into tsv format
    python $home/scr/DatasetPrep/csv2tsv.py alldata.csv alldata.tsv
    
    # split the dataset into training and validation sets
    python $home/scr/DatasetPrep/split_dataset.py alldata.tsv train.tsv validation.tsv $pct_validation $random_seed
    rm alldata.csv
    cd $home
done

cd $home