# The pipeline specified in this script is used to prepare for HPC computation.
# Author: Zhendong Sha@2023-01-09

#### Parameters ####
dir_scr=scr
dir_res=res

#### Prepare genetic algrithms scr ####
echo "Prepare genetic algrithms scr"

# copy GA to GWAS folder
cp -r $dir_scr/GeneticAlgorithm/*.py $dir_res/GWAS

# copy GA to GAMETES folder
for folder in $dir_res/GAMETES/*
do
    cp -r $dir_scr/GeneticAlgorithm/*.py $folder
done

# copy GA to GEO folder
for folder in $dir_res/GEO_Datasets/*
do
    cp -r $dir_scr/GeneticAlgorithm/*.py $folder
done